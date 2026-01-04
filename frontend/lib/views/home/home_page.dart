import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_gate.dart';
<<<<<<< HEAD
import '../../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const JiraHomePage(),
    );
  }
}

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
                        await AuthService.instance.logout();
                        // Xóa tất cả route và quay về AuthGate
                        if (mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AuthGate(child: HomePage()),
                            ),
                            (route) => false,
                          );
                        }
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
=======
import '../../services/auth/auth_service.dart';
import 'space_templates.dart';

// ============ MAIN APP ============
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0052CC),
        fontFamily: 'Segoe UI',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedMenu = 'For you';
  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(isMobile),
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) _buildSidebar(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: const Color(0xFF0052CC),
      elevation: 0,
      leading: isMobile
          ? null
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.dashboard,
                  color: Color(0xFF0052CC),
                  size: 20,
                ),
              ),
            ),
      title: Row(
        children: [
          if (!isMobile)
            const Text(
              'TaskFlow',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          if (!isMobile) const SizedBox(width: 24),
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF0747A6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            _showCreateDialog();
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Create', style: TextStyle(fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0052CC),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 8),

        // --- LOGOUT MENU ---
        PopupMenuButton<int>(
          offset: const Offset(0, 48),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF6554C0),
              child: const Text(
                'U',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
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
                await AuthService.instance.logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AuthGate(child: HomePage()),
                    ),
                    (route) => false,
                  );
                }
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
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF0052CC)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'TaskFlow',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Project Management',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          _buildMenuItem('For you', Icons.person_outline, false),
          _buildMenuItem('Recent', Icons.access_time, false),
          _buildMenuItem('Starred', Icons.star_border, false),
          _buildMenuItem('Apps', Icons.apps, false),
          _buildMenuItem('Plans', Icons.calendar_today_outlined, false),
          const Divider(),
          _buildMenuItem('Spaces', Icons.dashboard_outlined, false),
          _buildMenuItem('Filters', Icons.filter_list, false),
          _buildMenuItem('Dashboards', Icons.dashboard, false),
>>>>>>> main
        ],
      ),
    );
  }

<<<<<<< HEAD
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
=======
  Widget _buildSidebar() {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildMenuItem('For you', Icons.person_outline, true),
          _buildMenuItem('Recent', Icons.access_time, true),
          _buildMenuItem('Starred', Icons.star_border, true),
          _buildMenuItem('Apps', Icons.apps, true),
          _buildMenuItem('Plans', Icons.calendar_today_outlined, true),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Divider(height: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Spaces',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5E6C84),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    _showCreateDialog();
                  },
>>>>>>> main
                ),
              ],
            ),
          ),
<<<<<<< HEAD

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
=======
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Once you visit or create spaces, they\'ll show up here.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF5E6C84)),
            ),
          ),
          _buildMenuItem(
            'More spaces',
            Icons.chevron_right,
            true,
            indent: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Divider(height: 1),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Recommended',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5E6C84),
              ),
            ),
          ),
          _buildMenuItem(
            'Create a roadmap',
            Icons.timeline,
            true,
            badge: 'TRY',
            indent: true,
          ),
          _buildMenuItem('Filters', Icons.filter_list, true, indent: true),
          _buildMenuItem('Dashboards', Icons.dashboard, true, indent: true),
          _buildMenuItem(
            'Operations',
            Icons.build_outlined,
            true,
            indent: true,
          ),
          _buildMenuItem('Customers', Icons.people_outline, true, indent: true),
          _buildMenuItem(
            'Customer experiences',
            Icons.headset_mic_outlined,
            true,
            indent: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Divider(height: 1),
          ),
          _buildMenuItem(
            'Assets',
            Icons.extension_outlined,
            true,
            external: true,
            indent: true,
          ),
          _buildMenuItem(
            'Teams',
            Icons.groups_outlined,
            true,
            external: true,
            indent: true,
          ),
          _buildMenuItem(
            'Give feedback on the new...',
            Icons.feedback_outlined,
            true,
            indent: true,
          ),
>>>>>>> main
        ],
      ),
    );
  }

<<<<<<< HEAD
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
=======
  Widget _buildMenuItem(
    String title,
    IconData? icon,
    bool showText, {
    bool indent = false,
    String? badge,
    bool external = false,
  }) {
    final isSelected = _selectedMenu == title;
    return Container(
      margin: EdgeInsets.only(left: indent ? 24 : 0),
      child: ListTile(
        dense: true,
        leading: icon != null
            ? Icon(
                icon,
                size: 20,
                color: isSelected
                    ? const Color(0xFF0052CC)
                    : const Color(0xFF5E6C84),
              )
            : null,
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? const Color(0xFF0052CC)
                      : const Color(0xFF172B4D),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0052CC),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (external)
              const Icon(Icons.open_in_new, size: 14, color: Color(0xFF5E6C84)),
          ],
        ),
        trailing: title == 'Recent' || title == 'Starred'
            ? const Icon(
                Icons.chevron_right,
                size: 18,
                color: Color(0xFF5E6C84),
              )
            : null,
        selected: isSelected,
        selectedTileColor: const Color(0xFFDEEBFF),
        onTap: () {
          setState(() => _selectedMenu = title);
        },
>>>>>>> main
      ),
    );
  }

<<<<<<< HEAD
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
=======
  Widget _buildSpaceItem(String name, Color color) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 48, right: 16),
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.dashboard, size: 14, color: Colors.white),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 14, color: Color(0xFF172B4D)),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC400),
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.lock_outline,
                  size: 60,
                  color: Color(0xFF172B4D),
                ),
                Positioned(
                  right: 15,
                  top: 20,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0052CC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.vpn_key,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Space not found',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF172B4D),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'You tried to access a space that doesn\'t exist, or that you don\'t have permission to access. Speak to your Jira admin or space admin to get access.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5E6C84),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _showCreateDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Create your first scrum board',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Go back to home',
                style: TextStyle(
                  color: Color(0xFF0052CC),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SpaceTemplatesPage()),
    );
>>>>>>> main
  }
}
