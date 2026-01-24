import 'package:flutter/material.dart';
import '../../models/home/workspace_model.dart';
import '../../models/backlog/sprint_model.dart';
import '../../viewmodels/backlog/backlog_view_model.dart';
import '../../services/backlog/sprint_service.dart';
import '../../components/home/workspace_header.dart';
import '../../components/home/backlog_common.dart';
import '../../components/home/sprint_section.dart';
import '../../components/home/backlog_section.dart';
import '../../components/home/sprint_graph_screen.dart';

class WorkspaceBacklogView extends StatefulWidget {
  final WorkspaceModel workspace;

  const WorkspaceBacklogView({Key? key, required this.workspace})
    : super(key: key);

  @override
  State<WorkspaceBacklogView> createState() => _WorkspaceBacklogViewState();
}

class _WorkspaceBacklogViewState extends State<WorkspaceBacklogView> {
  final BacklogViewModel _viewModel = BacklogViewModel();
  final SprintService _sprintService = SprintService();

  final TextEditingController _sprintInputController = TextEditingController();
  final FocusNode _sprintInputFocusNode = FocusNode();

  String _activeTab = 'Backlog';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchBacklog(widget.workspace.id);
      _viewModel.fetchSprints(widget.workspace.id);
    });
  }

  @override
  void dispose() {
    _sprintInputController.dispose();
    _sprintInputFocusNode.dispose();
    super.dispose();
  }

  void _onSprintCreated() {
    _viewModel.fetchSprints(widget.workspace.id);
  }

  void _handleCreateStory(String text) async {
    if (text.isEmpty) return;
    final success = await _viewModel.createStory(widget.workspace.id, text);
    if (mounted) {
      if (success) {
        _sprintInputController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User story created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create user story'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleMoveStoryToSprint(String sprintId, String storyId) async {
    final success = await _sprintService.addStoryToSprint(
      sprintId: sprintId,
      userStoryId: storyId,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Moved story to sprint successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 700),
          ),
        );
      }
      _viewModel.fetchBacklog(widget.workspace.id);
      _viewModel.fetchSprints(widget.workspace.id);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to move story'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _focusCreateIssue() {
    _sprintInputFocusNode.requestFocus();
  }

  Widget _buildGraphTab() {
    SprintModel? activeSprint;
    try {
      activeSprint = _viewModel.sprintList.firstWhere(
        (s) => s.status == 'ACTIVE' || s.status == 'IN_PROGRESS',
      );
    } catch (e) {
      activeSprint = null;
    }

    if (activeSprint == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.hub_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No active sprint found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Please go to the Backlog tab and start a sprint first.",
              style: TextStyle(color: Color(0xFF5E6C84)),
            ),
          ],
        ),
      );
    }

    return SprintGraphScreen(
      sprintId: activeSprint.id,
      sprintName: activeSprint.name,
    );
  }

  // --- [MỚI] Hàm xây dựng giao diện Tab Backlog (Code cũ tách ra) ---
  Widget _buildBacklogTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BacklogSearchBar(),
          const SizedBox(height: 24),

          // Section Sprint
          SprintSection(
            controller: _sprintInputController,
            onCreateStory: _handleCreateStory,
            sprints: _viewModel.sprintList,
            onMoveStoryToSprint: _handleMoveStoryToSprint,
          ),

          const SizedBox(height: 24),

          // Section Backlog
          BacklogSection(
            onCreateStory: _handleCreateStory,
            backlogList: _viewModel.backlogList,
            workspaceId: widget.workspace.id,
            onSprintCreated: _onSprintCreated,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return Stack(
          children: [
            Column(
              children: [
                // Header Workspace
                WorkspaceHeader(
                  workspace: widget.workspace,
                  activeTab: _activeTab,
                  onTabSelected: (tab) {
                    setState(() => _activeTab = tab);
                    // Nếu bấm vào tab Graph, refresh lại data để đảm bảo lấy đúng status Active
                    if (tab == 'Graph') {
                      _viewModel.fetchSprints(widget.workspace.id);
                    }
                  },
                ),

                // Nội dung thay đổi dựa trên Tab
                Expanded(
                  child: Container(
                    color: const Color(0xFFF4F5F7),
                    // Logic chuyển đổi giao diện
                    child: _activeTab == 'Graph'
                        ? _buildGraphTab()
                        : _buildBacklogTab(),
                  ),
                ),
              ],
            ),

            // Loading Overlay
            if (_viewModel.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
