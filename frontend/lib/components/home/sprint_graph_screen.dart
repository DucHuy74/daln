// lib/components/home/sprint_graph_screen.dart

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import '../../services/backlog/sprint_graph_service.dart';

class SprintGraphScreen extends StatefulWidget {
  final String sprintId;
  final String sprintName;

  const SprintGraphScreen({
    Key? key,
    required this.sprintId,
    required this.sprintName,
  }) : super(key: key);

  @override
  _SprintGraphScreenState createState() => _SprintGraphScreenState();
}

class _SprintGraphScreenState extends State<SprintGraphScreen> {
  final SprintGraphService _service = SprintGraphService();

  // Khởi tạo Graph
  final Graph graph = Graph()..isTree = false;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  bool _isLoading = true;
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);

    _loadData();
  }

  void _loadData() async {
    final data = await _service.fetchSprintGraph(widget.sprintId);

    if (data != null) {
      final List nodesData = data['nodes'] ?? []; // Kiểm tra null an toàn
      final List edgesData = data['edges'] ?? []; // Kiểm tra null an toàn

      // Map để lưu Node theo ID
      Map<String, Node> nodeMap = {};

      for (var n in nodesData) {
        Widget nodeWidget = _buildNodeWidget(n['id'], n['type']);
        Node node = Node.Id(nodeWidget);
        nodeMap[n['id']] = node;
        graph.addNode(node);
      }

      for (var e in edgesData) {
        Node? fromNode = nodeMap[e['from']];
        Node? toNode = nodeMap[e['to']];

        if (fromNode != null && toNode != null) {
          graph.addEdge(
            fromNode,
            toNode,
            paint: Paint()
              ..color = _getEdgeColor(e['type'])
              ..strokeWidth = 2,
          );
        }
      }

      // Cập nhật biến cờ _hasData
      if (nodesData.isNotEmpty) {
        _hasData = true;
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ... (Giữ nguyên hàm _buildNodeWidget và _getEdgeColor cũ của bạn) ...
  Widget _buildNodeWidget(String id, String type) {
    Color color = type == 'UserStory' ? Colors.blueAccent : Colors.orangeAccent;
    IconData icon = type == 'UserStory'
        ? Icons.bookmark
        : Icons.check_circle_outline;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            type,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          // Cắt chuỗi ID cho gọn, tránh lỗi nếu ID quá ngắn
          Text(
            id.length > 4 ? id.substring(0, 4) : id,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getEdgeColor(String type) {
    if (type == 'BLOCKS') return Colors.red;
    return Colors.black54;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Graph: ${widget.sprintName}")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_hasData
          // [MỚI] Quan trọng: Nếu không có dữ liệu thì hiện Text, KHÔNG vẽ GraphView
          ? const Center(
              child: Text(
                "Không có dữ liệu phụ thuộc (dependencies) trong sprint này.",
              ),
            )
          : InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.01,
              maxScale: 5.6,
              child: GraphView(
                graph: graph,
                algorithm: BuchheimWalkerAlgorithm(
                  builder,
                  TreeEdgeRenderer(builder),
                ),
                paint: Paint()
                  ..color = Colors.black
                  ..strokeWidth = 1
                  ..style = PaintingStyle.stroke,
                builder: (Node node) {
                  return node.key?.value as Widget;
                },
              ),
            ),
    );
  }
}
