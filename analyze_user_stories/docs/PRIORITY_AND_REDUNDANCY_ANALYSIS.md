# Phân tích `priority_service.py` và `redundancy_classification_service.py`

**File nguồn:**

- `src/services/priority_service.py`
- `src/services/redundancy_classification_service.py`
- Orchestration: `src/services/graph_batch_service.py`

---

# Mục lục

1. Bối cảnh pipeline
2. PriorityService — công thức và code
3. RedundancyClassificationService — công thức và code
4. Tích hợp GraphBatchService
5. Bảng tổng hợp công thức
6. Ví dụ số minh họa
7. Sequence: `rebuild_workspace`
8. Lưu ý vận hành

---

# 1. Bối cảnh pipeline

```mermaid
flowchart LR
  subgraph batch [GraphBatchService.rebuild_workspace]
    SVO[SVO + Neo4j graph]
    PRI[PriorityService]
    RED[RedundancyClassificationService]
    OUT[priority_final + redundancy pairs]
  end

  SVO --> PRI
  PRI -->|priority_map| RED
  RED --> OUT
```

| Service | Đầu ra chính | Vai trò |
|---|---|---|
| **PriorityService** | `UserStory.priority ∈ (0,1)` | Độ ưu tiên cấu trúc từ centrality object trên đồ thị Term |
| **RedundancyClassificationService** | `redundancy_prob`, `is_redundant`, `group_*` | Phân loại cặp story trùng lặp |
| **GraphBatchService** | `priority_refined`, `priority_final` | Trộn priority với similarity/rule và giảm theo redundancy |

---

# 2. PriorityService — công thức và code

## 2.1 Vai trò class

`PriorityService` nhận `neo4j_service` và `db`.

Nhiệm vụ chính:

- Tính centrality cho `Term`
- Mapping story → objects
- Sinh priority cấu trúc cho `UserStory`

Entry point:

```python
compute_priority_for_workspace(workspace_id)
```

---

## 2.2 Degree trên Term

### Cypher

```cypher
MATCH (n:Term {workspace_id: $ws})
OPTIONAL MATCH (n)--(m:Term {workspace_id: $ws})
WITH n, count(m) AS deg
SET n.degree = deg
```

### Công thức

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{degree}(n)=|\{m:(n)--(m),m\in\mathrm{Term}\}|" />
</p>

### Ý nghĩa

- Degree càng cao → object càng phổ biến trong graph.
- Term kết nối nhiều node khác → ảnh hưởng domain lớn hơn.

---

## 2.3 Betweenness Centrality

### Pipeline

1. Drop graph projection cũ
2. Project `Term → Term`
3. Chạy `gds.betweenness.write`
4. Normalize min-max
5. Drop graph projection

### Chuẩn hóa

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{betweenness}_{norm}(m)=\frac{B(m)}{\max(B)}" />
</p>

### Ý nghĩa

- Term nằm trên nhiều shortest path → đóng vai trò bridge.
- Giá trị sau normalize nằm trong `[0,1]`.

---

## 2.4 Fallback khi GDS lỗi

```cypher
SET n.betweenness = coalesce(n.degree, 0) * 1.0
```

### Công thức

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{betweenness}(n):=\mathrm{degree}(n)" />
</p>

### Lưu ý

Fallback không normalize.

Điều này làm scale khác với nhánh GDS thật.

---

## 2.5 Object theo story

### Mô hình graph

```text
Subject -[PERFORM {story_id}]-> Action -[TARGET]-> Object
```

### Cypher

```cypher
MATCH (sub:Term {workspace_id: $ws})-[r:PERFORM]->(act:Term)
WHERE r.story_id IS NOT NULL
MATCH (act)-[:TARGET]->(obj:Term)
RETURN r.story_id AS story_id, collect(DISTINCT obj.name) AS objects
```

---

## 2.6 Điểm cấu trúc story

### Degree trung bình

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\bar{d}_s=\frac{1}{|O_s|}\sum_{o\in%20O_s}\mathrm{degree}(o)" />
</p>

### Betweenness trung bình

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\bar{b}_s=\frac{1}{|O_s|}\sum_{o\in%20O_s}\mathrm{betweenness}(o)" />
</p>

### Structural score

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?x_s=0.5\cdot\bar{d}_s+0.5\cdot\bar{b}_s" />
</p>

### Code tương ứng

```python
degree_avg = degree_sum / len(objects)
between_avg = between_sum / len(objects)
x = 0.5 * degree_avg + 0.5 * between_avg
```

---

## 2.7 Robust scaling

### Median + IQR

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?IQR=Q3-Q1" />
</p>

### Khi IQR > 0

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\alpha=\frac{4}{IQR},\quad\beta=-\alpha\cdot\mathrm{median}(x)" />
</p>

### Transform trước sigmoid

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?z_s=\alpha\cdot%20x_s+\beta" />
</p>

---

## 2.8 Sigmoid — priority cuối

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{priority}_s=\sigma(z_s)=\frac{1}{1+e^{-z_s}}" />
</p>

### Code

```python
def sigmoid(self, x):
    return 1 / (1 + math.exp(-x))
```

---

# 3. RedundancyClassificationService — công thức và code

## 3.1 Vai trò class

Service này:

1. Sinh feature cho từng cặp story
2. Weak labeling
3. Train baseline ML
4. Predict redundancy probability
5. Gom nhóm bằng Union-Find

---

## 3.2 Pair features

| Feature | Ý nghĩa |
|---|---|
| `same_subject` | Subject giống nhau |
| `same_action` | Action giống nhau |
| `same_object` | Object giống nhau |
| `object_similarity` | Similarity giữa object |
| `action_similarity` | Similarity giữa action |
| `rule_confidence` | Confidence association rule |
| `rule_lift` | Lift association rule |
| `priority_gap` | Chênh lệch priority |

### Priority gap

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{priority\_gap}=|p_L-p_R|" />
</p>

---

## 3.3 Weak labeling

### Positive label

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?(obj\ge0.75\lor(same\_obj\land%20act\ge0.5))\land%20conf\ge0.5\land%20lift\ge1" />
</p>

### Negative label

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?obj\le0.25\land%20act\le0.25\land%20\neg%20same\_obj\land%20conf\le0.3" />
</p>

---

## 3.4 Baseline models

| Model | Ghi chú |
|---|---|
| Logistic Regression | Có StandardScaler |
| Random Forest | Balanced subsample |
| HistGradientBoosting | Gradient boosting histogram |

### Chọn model tốt nhất

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{best}=\arg\max\limits_mF1(m)" />
</p>

---

## 3.5 Predict redundancy

### Fallback score

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?score=0.35s_{obj}+0.2s_{act}+0.15same_{obj}+0.15conf+0.15same_{act}" />
</p>

### Probability

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{redundancy\_prob}=P(y=1|x)" />
</p>

### Decision rule

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{is\_redundant}=(prob\ge threshold)" />
</p>

---

## 3.6 Union-Find grouping

- Mỗi story ban đầu là root riêng.
- Nếu redundant → union.
- Các story connected gián tiếp sẽ cùng group.

Ví dụ:

```text
A -- B
B -- C
=> group(A) = group(B) = group(C)
```

---

## 3.7 Aggregate redundancy score

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{redundancy\_score}(s)=\max_{t\neq%20s}\mathrm{redundancy\_prob}(s,t)" />
</p>

---

# 4. Tích hợp GraphBatchService

## 4.1 Priority refined

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{priority\_refined}=w_0p_{initial}+w_1s_{sim}+w_2s_{rule}" />
</p>

---

## 4.2 Priority final

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\mathrm{priority\_final}=\mathrm{priority\_refined}(1-\alpha_r\cdot\mathrm{redundancy\_prob})" />
</p>

---

## 4.3 Pipeline tổng quát

```mermaid
flowchart TB
  subgraph priority_svc [PriorityService]
    Centrality[degree + betweenness]
    Struct[x structural score]
    Sigmoid[priority sigmoid]
  end

  subgraph redundancy_svc [RedundancyClassificationService]
    Pair[Pair Features]
    Weak[Weak Labels]
    ML[ML Training]
    UF[Union-Find]
  end

  subgraph batch [GraphBatchService]
    Refine[priority_refined]
    Final[priority_final]
  end

  Centrality --> Struct --> Sigmoid
  Sigmoid --> Pair
  Pair --> Weak --> ML --> UF
  Sigmoid --> Refine
  ML --> Refine --> Final
```

---

# 5. Ví dụ số minh họa

## 5.1 Centrality

| Object | degree | betweenness |
|---|---|---|
| payment | 4 | 1.0 |
| invoice | 2 | 0.5 |
| report | 1 | 0.0 |

---

## 5.2 Structural score

| Story | Object | x_s |
|---|---|---|
| S1 | payment | 2.5 |
| S2 | invoice | 1.25 |
| S3 | report | 0.5 |

### Ví dụ

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?x_{S1}=0.5(4)+0.5(1)=2.5" />
</p>

---

## 5.3 Scaling

Giả sử:

- median = 1.25
- IQR = 1

### Hệ số

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?\alpha=4,\quad\beta=-5" />
</p>

### Priority

| Story | z | priority |
|---|---|---|
| S1 | 5 | 0.993 |
| S2 | 0 | 0.500 |
| S3 | -3 | 0.047 |

---

## 5.4 Priority final

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?0.8615\times(1-0.6\times0.65)\approx0.525" />
</p>

---

# 6. Sequence — rebuild_workspace

```mermaid
sequenceDiagram
  participant GBS as GraphBatchService
  participant DB as MySQL
  participant Sem as SemanticService
  participant Stat as StatisticsService
  participant Neo as Neo4jService
  participant Pri as PriorityService
  participant Red as RedundancyClassificationService

  GBS->>DB: query AnalyzeStoryResult
  GBS->>Sem: process(all_svo)
  GBS->>Stat: generate_association_rules
  GBS->>Neo: clear_workspace
  GBS->>Neo: save_svo, save_similarity, save_rules
  GBS->>Pri: compute_priority_for_workspace
  Pri->>Neo: degree + betweenness
  GBS->>Red: build_pair_dataset
  GBS->>Red: build_weak_labels
  GBS->>Red: train_baseline_models
  GBS->>Red: predict_redundancy
  GBS->>GBS: priority_refined + priority_final
```

---

# 7. Lưu ý vận hành

| Chủ đề | Chi tiết |
|---|---|
| Complexity | Redundancy O(n²) |
| Weak labels | Có thể nhiều unlabeled pairs |
| GDS fallback | Scale khác branch GDS |
| Export graph | Chỉ top-K redundancy pairs |
| Priority gap | Feature ML quan trọng |

---

# 8. Kết luận

Pipeline hiện tại kết hợp:

- Graph centrality
- Semantic similarity
- Association rules
- Weak supervision
- Machine learning
- Redundancy-aware prioritization

để sinh:

- `priority_initial`
- `priority_refined`
- `priority_final`
- `redundancy_prob`
- `redundancy_groups`

trên toàn bộ workspace user story.

