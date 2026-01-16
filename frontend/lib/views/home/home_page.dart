import 'package:flutter/material.dart';

import '../../components/home/taskflow_appbar.dart';
import '../../components/home/taskflow_drawer.dart';
import '../../components/home/taskflow_sidebar.dart';
import '../../components/home/taskflow_main_content.dart';

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

  List<String> _workspaces = [];

  @override
  void initState() {
    super.initState();
    if (widget.newWorkspaceName != null) {
      _workspaces.add(widget.newWorkspaceName!);
      _selectedMenu = widget.newWorkspaceName!;
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
            ),

          Expanded(child: TaskFlowMainContent(onCreate: _showCreateDialog)),
        ],
      ),
    );
  }
}
