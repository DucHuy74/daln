import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Segoe UI',
        primaryColor: const Color(0xFF0052CC),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const JiraHomePage(),
    );
  }
}

// --- 2. DATA MODELS (Dữ liệu giả) ---
class Issue {
  final String id;
  final String title;
  final String type; // 'story', 'bug', 'task'
  final String priority; // 'high', 'medium', 'low'
  final Color avatarColor;
  final String assignee;

  Issue(
    this.id,
    this.title,
    this.type,
    this.priority,
    this.avatarColor,
    this.assignee,
  );
}

// --- 3. JIRA HOME PAGE UI ---
class JiraHomePage extends StatefulWidget {
  const JiraHomePage({Key? key}) : super(key: key);

  @override
  State<JiraHomePage> createState() => _JiraHomePageState();
}

class _JiraHomePageState extends State<JiraHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Dữ liệu mẫu (Hardcode để test UI)
  final List<Issue> _todoIssues = [
    Issue(
      'TASK-101',
      'Research Flutter architecture',
      'story',
      'high',
      Colors.blue,
      'AB',
    ),
    Issue(
      'TASK-102',
      'Setup CI/CD Pipeline',
      'task',
      'medium',
      Colors.red,
      'CD',
    ),
    Issue(
      'TASK-103',
      'Fix login screen overflow',
      'bug',
      'high',
      Colors.green,
      'EF',
    ),
  ];

  final List<Issue> _inProgressIssues = [
    Issue(
      'TASK-104',
      'Implement Authentication',
      'story',
      'high',
      Colors.orange,
      'GH',
    ),
    Issue(
      'TASK-105',
      'Design database schema',
      'task',
      'low',
      Colors.purple,
      'JK',
    ),
  ];

  final List<Issue> _doneIssues = [
    Issue(
      'TASK-99',
      'Initial Project Setup',
      'task',
      'medium',
      Colors.teal,
      'LM',
    ),
    Issue(
      'TASK-98',
      'Create Git Repository',
      'task',
      'low',
      Colors.blueGrey,
      'XY',
    ),
  ];

  // Logic kiểm tra màn hình (Desktop >= 900px)
  bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktop(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      // --- APP BAR ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFDFE1E6))),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Mobile: Hamburger Menu
                if (!isDesktop)
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF172B4D)),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),

                // Logo & App Name
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0052CC),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.dashboard,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'TaskFlow',
                  style: TextStyle(
                    color: Color(0xFF172B4D),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                // Desktop: Top Menu Items
                if (isDesktop) ...[
                  const SizedBox(width: 32),
                  _buildTopMenuItem('Your Work'),
                  _buildTopMenuItem('Projects'),
                  _buildTopMenuItem('Filters'),
                  _buildTopMenuItem('Dashboards'),
                  _buildTopMenuItem('People'),
                  _buildTopMenuItem('Apps'),
                ],

                const Spacer(),

                // Search Box
                Container(
                  width: isDesktop ? 200 : 40,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDFE1E6)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: isDesktop
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search,
                        size: 20,
                        color: Color(0xFF5E6C84),
                      ),
                      if (isDesktop) ...[
                        const SizedBox(width: 8),
                        const Text(
                          'Search',
                          style: TextStyle(color: Color(0xFF5E6C84)),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                PopupMenuButton<int>(
                  offset: const Offset(0, 48),
                  onSelected: (value) async {
                    if (value == 1) {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirm logout'),
                          content: const Text('Do you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Color(0xFF172B4D)),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFF0052CC),
                      child: Text(
                        'ME',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      drawer: !isDesktop ? _buildSidebar(isMobile: true) : null,

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            SizedBox(width: 260, child: _buildSidebar(isMobile: false)),

          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildBoardHeader(),
                  const Divider(height: 1, color: Color(0xFFDFE1E6)),

                  Expanded(
                    child: Container(
                      color: const Color(0xFFF4F5F7),
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildKanbanColumn('TO DO', _todoIssues),
                            _buildKanbanColumn(
                              'IN PROGRESS',
                              _inProgressIssues,
                            ),
                            _buildKanbanColumn('DONE', _doneIssues),

                            // Nút "Create Column"
                            Container(
                              width: 300,
                              height: 50,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBECF0).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add, color: Color(0xFF42526E)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Create column',
                                      style: TextStyle(
                                        color: Color(0xFF42526E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SUB-WIDGETS (Helper Methods) ---

  // 1. Top Menu Item Text
  Widget _buildTopMenuItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF42526E),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  // 2. Sidebar (Dùng chung cho Desktop và Mobile Drawer)
  Widget _buildSidebar({required bool isMobile}) {
    final content = Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        border: const Border(right: BorderSide(color: Color(0xFFDFE1E6))),
      ),
      child: Column(
        children: [
          // Project Info Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFAB00),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.rocket_launch, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'TaskFlow Project',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Software Project',
                      style: TextStyle(color: Color(0xFF5E6C84), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFDFE1E6)),

          // Menu List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              children: [
                _buildSidebarItem(Icons.view_kanban, 'Board', isSelected: true),
                _buildSidebarItem(Icons.list, 'Backlog'),
                _buildSidebarItem(Icons.timeline, 'Timeline'),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'DEVELOPMENT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E6C84),
                    ),
                  ),
                ),
                _buildSidebarItem(Icons.code, 'Code'),
                _buildSidebarItem(Icons.rocket, 'Releases'),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E6C84),
                    ),
                  ),
                ),
                _buildSidebarItem(Icons.settings, 'Project settings'),
              ],
            ),
          ),
        ],
      ),
    );

    return isMobile ? Drawer(child: content) : content;
  }

  // 3. Single Item in Sidebar
  Widget _buildSidebarItem(
    IconData icon,
    String title, {
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFDEEBFF)
            : Colors.transparent, // Highlight xanh nhạt khi chọn
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 20,
          color: isSelected ? const Color(0xFF0052CC) : const Color(0xFF42526E),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF0052CC)
                : const Color(0xFF172B4D),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        onTap: () {},
      ),
    );
  }

  // 4. Board Header Area (Breadcrumbs, Title, Filters)
  Widget _buildBoardHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumbs
          Row(
            children: const [
              Text('Projects', style: TextStyle(color: Color(0xFF5E6C84))),
              Text(' / ', style: TextStyle(color: Color(0xFF5E6C84))),
              Text('TaskFlow', style: TextStyle(color: Color(0xFF5E6C84))),
              Text(' / ', style: TextStyle(color: Color(0xFF5E6C84))),
              Text(
                'TF Board',
                style: TextStyle(
                  color: Color(0xFF172B4D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Title & Main Actions
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              const Text(
                'TF Board',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172B4D),
                ),
              ),
              const SizedBox(width: 12),
              _buildHeaderFilterButton('Complete Sprint', isPrimary: false),
            ],
          ),
          const SizedBox(height: 20),
          // Search & Filters Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 36,
                  width: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDFE1E6)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search this board',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5E6C84),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: Color(0xFF5E6C84),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // User Avatars
                Row(
                  children: [
                    for (var color in [Colors.blue, Colors.red, Colors.green])
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: color,
                          child: const Text(
                            'U',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                const Text(
                  'Only my issues',
                  style: TextStyle(
                    color: Color(0xFF172B4D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Clear all',
                  style: TextStyle(color: Color(0xFF5E6C84)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. Helper for Filter Buttons
  Widget _buildHeaderFilterButton(String text, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF0052CC) : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? Colors.white : const Color(0xFF42526E),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  // 6. Kanban Column Widget
  Widget _buildKanbanColumn(String title, List<Issue> issues) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEBECF0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title ${issues.length}',
                  style: const TextStyle(
                    color: Color(0xFF5E6C84),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const Icon(
                  Icons.more_horiz,
                  size: 16,
                  color: Color(0xFF5E6C84),
                ),
              ],
            ),
          ),

          // Cards List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: issues.length,
              itemBuilder: (context, index) {
                return _buildIssueCard(issues[index]);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Icon(Icons.add, size: 16, color: Color(0xFF5E6C84)),
                    SizedBox(width: 4),
                    Text(
                      'Create issue',
                      style: TextStyle(color: Color(0xFF5E6C84), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Issue Card Widget
  Widget _buildIssueCard(Issue issue) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            issue.title,
            style: const TextStyle(
              color: Color(0xFF172B4D),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildIssueTypeIcon(issue.type),
              const SizedBox(width: 8),
              _buildPriorityIcon(issue.priority),
              const Spacer(),
              Text(
                issue.id,
                style: const TextStyle(color: Color(0xFF5E6C84), fontSize: 12),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 10,
                backgroundColor: issue.avatarColor,
                child: Text(
                  issue.assignee,
                  style: const TextStyle(fontSize: 9, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper: Icons for Issue Type
  Widget _buildIssueTypeIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'bug':
        icon = Icons.bug_report;
        color = Colors.redAccent;
        break;
      case 'story':
        icon = Icons.bookmark;
        color = Colors.green;
        break;
      default:
        icon = Icons.check_box;
        color = Colors.blue;
    }
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }

  // Helper: Icons for Priority
  Widget _buildPriorityIcon(String priority) {
    IconData icon;
    Color color;
    switch (priority) {
      case 'high':
        icon = Icons.arrow_upward;
        color = Colors.red;
        break;
      case 'low':
        icon = Icons.arrow_downward;
        color = Colors.green;
        break;
      default:
        icon = Icons.remove;
        color = Colors.orange;
    }
    return Icon(icon, size: 14, color: color);
  }
}
