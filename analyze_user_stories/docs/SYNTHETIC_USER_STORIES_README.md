# Synthetic user stories (Conextra-style) — kiểm thử redundancy / classification

File này chứa **câu synthetic** theo template Agile phổ biến:

> **As a** \<role\>, **I want** \<capability\> **so that** \<benefit\>.

Mục đích:

- Test pipeline parse → S-V-O → similarity / rules / priority.
- Có **cụm trùng hoặc gần nghĩa** (cùng intent, wording hơi khác) và **câu tách biệt** để baseline redundancy không “dính” hết.

**Gợi ý dùng:** map mỗi dòng `US-xxx` → `user_story_id` khi gọi API learn; sau rebuild graph trong cùng workspace để weak-label / model pairwise có đủ cặp.

---

## Bảng tóm tụm (tham chiếu khi gán nhãn tay)

| Nhóm | US-ID (gợi ý) | Mô tả ngắn |
|------|----------------|------------|
| A — Đăng ký / tài khoản | US-001 … US-012 | Cùng intent “tạo tài khoản”, diễn đạt khác nhau |
| B — Đăng nhập / phiên | US-013 … US-022 | Login, session, remember me |
| C — Quên mật khẩu | US-023 … US-030 | Reset / OTP / email |
| D — Giỏ hàng | US-031 … US-042 | Thêm / sửa / xóa item, merge giỏ |
| E — Thanh toán | US-043 … US-052 | Checkout, card, invoice |
| F — Admin người dùng | US-053 … US-062 | CRUD user, role, khóa tài khoản |
| G — Thông báo | US-063 … US-072 | Push, email digest, preferences |
| H — Báo cáo / export | US-073 … US-082 | CSV/PDF, lịch export |
| I — Tìm kiếm catalog | US-083 … US-092 | Search, filter, sort |
| J — Câu độc lập (ít overlap) | US-093 … US-120 | Domain khác nhau, khó coi trùng |

---

## Danh sách synthetic (120 câu)

### Nhóm A — Đăng ký / tài khoản (trùng nghĩa cao)

| ID | User story |
|----|------------|
| US-001 | As a new visitor, I want to create an account so that I can save my preferences. |
| US-002 | As a guest, I want to register with my email so that I can access member features. |
| US-003 | As a prospective customer, I want to sign up quickly so that I can start shopping. |
| US-004 | As a user, I want to open a new account with minimal fields so that onboarding is fast. |
| US-005 | As a newcomer, I want account creation to validate my email so that my identity is confirmed. |
| US-006 | As a customer, I want to complete registration in one step so that I do not abandon the flow. |
| US-007 | As a visitor, I want to choose a username when signing up so that my profile is unique. |
| US-008 | As a user, I want to accept terms during signup so that I comply with policy. |
| US-009 | As a guest, I want social login as an alternative so that signup is easier. |
| US-010 | As a new user, I want confirmation after signup so that I know the account is active. |
| US-011 | As a shopper, I want to create a profile after purchase so that returns are smoother. |
| US-012 | As a visitor, I want optional marketing opt-in at signup so that I control communications. |

### Nhóm B — Đăng nhập / phiên

| ID | User story |
|----|------------|
| US-013 | As a returning user, I want to log in with email and password so that I reach my dashboard. |
| US-014 | As a member, I want secure login so that my data stays protected. |
| US-015 | As a user, I want session timeout after inactivity so that shared devices stay safe. |
| US-016 | As a customer, I want to stay logged in on trusted devices so that I skip frequent logins. |
| US-017 | As a user, I want logout from all devices so that a stolen session is invalidated. |
| US-018 | As a mobile user, I want biometric login so that access is faster. |
| US-019 | As a user, I want login rate limiting so that brute force attacks fail. |
| US-020 | As a member, I want to see last login time so that I detect suspicious access. |
| US-021 | As a user, I want CAPTCHA after failed attempts so that bots are slowed down. |
| US-022 | As a customer, I want SSO with my workplace IdP so that I use corporate credentials. |

### Nhóm C — Quên mật khẩu / reset

| ID | User story |
|----|------------|
| US-023 | As a user who forgot my password, I want to request a reset link so that I regain access. |
| US-024 | As a customer, I want password reset via verified email so that only I can change it. |
| US-025 | As a user, I want the reset link to expire so that old links are useless. |
| US-026 | As a member, I want to set a new password meeting policy so that my account stays secure. |
| US-027 | As a user, I want OTP to my phone for reset so that I have a second channel. |
| US-028 | As a customer, I want notification when my password changes so that I detect fraud. |
| US-029 | As a user, I want to cancel an accidental reset request so that my inbox is not spammed. |
| US-030 | As a member, I want security questions as backup so that I recover without email access. |

### Nhóm D — Giỏ hàng (trùng / gần nghĩa)

| ID | User story |
|----|------------|
| US-031 | As a shopper, I want to add products to my cart so that I can buy multiple items together. |
| US-032 | As a customer, I want items to stay in my cart across sessions so that I do not lose selections. |
| US-033 | As a buyer, I want to update quantities in the cart so that my order total is correct. |
| US-034 | As a user, I want to remove an item from the cart so that I only pay for what I need. |
| US-035 | As a shopper, I want to see line-item subtotals so that I understand pricing. |
| US-036 | As a customer, I want cart to reflect stock availability so that I avoid checkout errors. |
| US-037 | As a buyer, I want to save cart as a list for later so that I can compare options. |
| US-038 | As a user, I want to merge guest cart after login so that nothing is lost. |
| US-039 | As a shopper, I want estimated tax in the cart so that surprises at payment are reduced. |
| US-040 | As a customer, I want promo codes applied in cart so that discounts are visible early. |
| US-041 | As a buyer, I want to clear the entire cart quickly so that I can start over. |
| US-042 | As a user, I want cart icon to show item count so that I notice pending purchases. |

### Nhóm E — Thanh toán / checkout

| ID | User story |
|----|------------|
| US-043 | As a customer, I want to pay with credit card so that checkout completes online. |
| US-044 | As a shopper, I want PCI-compliant card entry so that my payment data is safe. |
| US-045 | As a buyer, I want digital wallet support so that checkout is one tap. |
| US-046 | As a customer, I want billing address separate from shipping so that gifts work correctly. |
| US-047 | As a user, I want order review before final pay so that I catch mistakes. |
| US-048 | As a shopper, I want email receipt after payment so that I have records. |
| US-049 | As a customer, I want failed payment retry with clear errors so that I can fix issues. |
| US-050 | As a buyer, I want partial refunds shown on invoice so that accounting is clear. |
| US-051 | As a user, I want subscription billing with proration so that plan changes are fair. |
| US-052 | As a customer, I want tax ID on B2B invoices so that VAT reclaim is possible. |

### Nhóm F — Admin quản lý người dùng

| ID | User story |
|----|------------|
| US-053 | As an admin, I want to list all users so that I can audit access. |
| US-054 | As an administrator, I want to deactivate a user account so that leavers lose access. |
| US-055 | As an admin, I want to assign roles to users so that permissions follow least privilege. |
| US-056 | As a system admin, I want to reset a user password so that support can help lockouts. |
| US-057 | As an admin, I want to export user directory to CSV so that compliance reviews are easier. |
| US-058 | As an administrator, I want to filter users by last login so that I find stale accounts. |
| US-059 | As an admin, I want bulk invite users so that onboarding scales. |
| US-060 | As a system admin, I want audit log of permission changes so that investigations are possible. |
| US-061 | As an admin, I want to merge duplicate user records so that data quality improves. |
| US-062 | As an administrator, I want mandatory MFA for admins so that privileged access is hardened. |

### Nhóm G — Thông báo

| ID | User story |
|----|------------|
| US-063 | As a user, I want email notifications for order updates so that I track shipments. |
| US-064 | As a customer, I want push notifications on mobile so that urgent alerts reach me. |
| US-065 | As a member, I want to mute non-critical notifications so that I am not overwhelmed. |
| US-066 | As a user, I want a daily digest instead of instant emails so that my inbox stays clean. |
| US-067 | As a customer, I want SMS alerts for delivery day so that I am home to receive. |
| US-068 | As a user, I want per-channel notification preferences so that I control noise. |
| US-069 | As a member, I want in-app notification center so that I see history. |
| US-070 | As a user, I want quiet hours for pushes so that sleep is not disturbed. |
| US-071 | As a customer, I want critical security alerts always on so that I never miss them. |
| US-072 | As a user, I want to unsubscribe from marketing with one click so that consent is easy. |

### Nhóm H — Báo cáo / export

| ID | User story |
|----|------------|
| US-073 | As a manager, I want monthly sales reports so that I can track revenue. |
| US-074 | As an analyst, I want to export reports to CSV so that I can pivot in Excel. |
| US-075 | As a finance user, I want PDF invoices in bulk so that audits are faster. |
| US-076 | As a manager, I want scheduled report emails so that I do not log in manually. |
| US-077 | As an analyst, I want filters by region and product line so that slices are meaningful. |
| US-078 | As a user, I want report generation progress indicator so that long jobs feel responsive. |
| US-079 | As a manager, I want comparison to prior quarter so that trends are visible. |
| US-080 | As an analyst, I want raw data export with API so that pipelines automate. |
| US-081 | As a compliance officer, I want tamper-evident report hashes so that integrity is provable. |
| US-082 | As a user, I want to save report templates so that recurring work is faster. |

### Nhóm I — Tìm kiếm catalog

| ID | User story |
|----|------------|
| US-083 | As a shopper, I want full-text search on products so that I find items quickly. |
| US-084 | As a customer, I want autocomplete suggestions so that typos matter less. |
| US-085 | As a user, I want filters by price range so that I stay on budget. |
| US-086 | As a buyer, I want filters by brand so that I narrow choices. |
| US-087 | As a shopper, I want sort by relevance so that best matches appear first. |
| US-088 | As a customer, I want sort by newest so that I see fresh inventory. |
| US-089 | As a user, I want zero-result suggestions so that I recover from dead ends. |
| US-090 | As a shopper, I want search within category so that scope is controlled. |
| US-091 | As a customer, I want recent searches listed so that repeat lookups are easy. |
| US-092 | As a user, I want synonym expansion in search so that regional naming still finds products. |

### Nhóm J — Câu độc lập (ít overlap với các nhóm trên)

| ID | User story |
|----|------------|
| US-093 | As a warehouse worker, I want to scan barcodes for inbound pallets so that receiving is accurate. |
| US-094 | As a field technician, I want offline work orders so that remote sites without Wi-Fi still function. |
| US-095 | As a pilot user, I want feature flags per environment so that staged rollouts are safe. |
| US-096 | As a data engineer, I want schema versioning for pipelines so that breaking changes are tracked. |
| US-097 | As a support agent, I want co-browsing with consent so that I guide confused users. |
| US-098 | As a patient, I want to book telehealth slots so that I avoid travel when ill. |
| US-099 | As a librarian, I want overdue notices automated so that returns improve. |
| US-100 | As a cyclist, I want route elevation profiles so that I plan climbs. |
| US-101 | As a podcast host, I want chapter markers in exports so that listeners can skip sections. |
| US-102 | As a beekeeper, I want hive temperature alerts so that swarming risks are reduced. |
| US-103 | As an astronomer, I want FITS metadata preserved on upload so that analysis pipelines work. |
| US-104 | As a game modder, I want dependency resolution for mods so that load order conflicts surface. |
| US-105 | As a music teacher, I want metronome sync across student devices so that ensemble practice aligns. |
| US-106 | As a marathon coach, I want heart-rate zone summaries per week so that training load is visible. |
| US-107 | As a city planner, I want pedestrian footfall heatmaps so that crosswalk placement is evidence-based. |
| US-108 | As a marine biologist, I want tag photo GPS stripped by default so that endangered sites stay private. |
| US-109 | As a conference organizer, I want badge printing queues throttled so that printers do not jam. |
| US-110 | As a proofreader, I want change-tracking export to DOCX so that clients review edits natively. |
| US-111 | As a drone operator, I want no-fly zone overlays so that compliance is obvious pre-flight. |
| US-112 | As a winemaker, I want fermentation curve alerts so that temperature excursions are caught early. |
| US-113 | As a chess club admin, I want Swiss pairing automation so that tournaments run on time. |
| US-114 | As a call center supervisor, I want whisper coaching to agents so that quality improves live. |
| US-115 | As a museum visitor, I want AR overlays for exhibits so that context enriches self tours. |
| US-116 | As a supply chain planner, I want safety stock recommendations so that stockouts drop. |
| US-117 | As a journalist, I want source redaction presets so that sensitive quotes export safely. |
| US-118 | As a home baker, I want recipe scaling by pan size so that batter volumes match tins. |
| US-119 | As a solar installer, I want shading simulation from LIDAR so that production estimates improve. |
| US-120 | As a scuba instructor, I want dive computer log import so that certification dives are verified. |

---

## Payload JSON mẫu (copy khi test API)

Mỗi phần tử: `user_story_id` trùng `US-xxx`, `text` là câu đầy đủ. Bạn có thể cắt nhỏ batch nếu API giới hạn body size.

```json
[
  {"user_story_id": "US-001", "text": "As a new visitor, I want to create an account so that I can save my preferences."},
  {"user_story_id": "US-002", "text": "As a guest, I want to register with my email so that I can access member features."}
]
```

*(Chỉ minh họa 2 dòng — full list nằm ở bảng trên; có thể export bằng script từ bảng Markdown nếu cần.)*

---

## Ghi chú

- Số lượng trong file: **120 câu** (nằm trong khoảng 50–200). Muốn **200 câu**, có thể nhân đôi nhóm A–I với biến thể wording nhỏ (đổi role/so that) hoặc thêm 80 câu J-style.
- Các nhóm **A–I** cố ý **overlap** để test redundancy; nhóm **J** cố ý **tách domain** để test false-positive rate.
