import 'package:flutter/material.dart';

import '../../components/home/taskflow_appbar.dart';
import '../../components/home/taskflow_drawer.dart';
import '../../components/home/taskflow_sidebar.dart';
import '../../components/home/taskflow_main_content.dart';
import '../../components/home/taskflow_backlog.dart';

import '../../services/home/workspace_service.dart';
import '../../models/home/workspace_model.dart';

import 'space_templates.dart';

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
  final String? newWorkspaceName;

  const HomePage({Key? key, this.newWorkspaceName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedMenu = 'For you';

  List<WorkspaceModel> _workspaces = [];
  final WorkspaceService _workspaceService = WorkspaceService();

  @override
  void initState() {
    super.initState();
    if (widget.newWorkspaceName != null) {
      _selectedMenu = widget.newWorkspaceName!;
    }
    _loadWorkspaces();
  }

  Future<void> _loadWorkspaces() async {
    final spaces = await _workspaceService.getWorkspaces();
    if (mounted) {
      setState(() {
        _workspaces = spaces;
      });
    }
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  void _onMenuSelected(String menu) {
    setState(() => _selectedMenu = menu);
    if (_isMobile(context) && Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context);
    }
  }

  void _showCreateDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SpaceTemplatesPage()),
    );
  }

  // --- LOGIC CHUYỂN ĐỔI MÀN HÌNH CHÍNH ---
  Widget _buildMainContent() {
    // 1. Tìm xem _selectedMenu có phải là tên của một Workspace không
    WorkspaceModel? selectedWorkspace;
    try {
      selectedWorkspace = _workspaces.firstWhere(
        (ws) => ws.name == _selectedMenu,
      );
    } catch (e) {
      selectedWorkspace = null;
    }

    // 2. Nếu tìm thấy Workspace -> Hiển thị Backlog View
    if (selectedWorkspace != null) {
      return WorkspaceBacklogView(workspace: selectedWorkspace);
    }

    // 3. Nếu không (vd: "For you", "Recent") -> Hiển thị màn hình mặc định
    return TaskFlowMainContent(onCreate: _showCreateDialog);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: TaskFlowAppBar(isMobile: isMobile, onCreate: _showCreateDialog),

      drawer: isMobile
          ? TaskFlowDrawer(
              selectedMenu: _selectedMenu,
              onMenuSelected: _onMenuSelected,
            )
          : null,

      body: Row(
        children: [
          if (!isMobile)
            TaskFlowSidebar(
              selectedMenu: _selectedMenu,
              onMenuSelected: _onMenuSelected,
              onCreate: _showCreateDialog,
              workspaces: _workspaces,
            ),

          // --- THAY ĐỔI Ở ĐÂY ---
          // Thay vì fix cứng TaskFlowMainContent, ta gọi hàm _buildMainContent
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }
}
