import 'package:flutter/material.dart';
import '../../models/home/workspace_model.dart';

class WorkspaceBacklogView extends StatefulWidget {
  final WorkspaceModel workspace;

  const WorkspaceBacklogView({Key? key, required this.workspace}) : super(key: key);

  @override
  State<WorkspaceBacklogView> createState() => _WorkspaceBacklogViewState();
}

class _WorkspaceBacklogViewState extends State<WorkspaceBacklogView> {
  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFF0052CC),
      const Color(0xFFDE350B),
      const Color(0xFF008DA6),
      const Color(0xFF403294),
      const Color(0xFFFF991F),
    ];
    return colors[name.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Space Header ---
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getAvatarColor(widget.workspace.name), // Dùng màu động
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.workspace.name.isNotEmpty ? widget.workspace.name[0].toUpperCase() : "",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.workspace.name, // Dùng tên thật từ model
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF172B4D)),
                  ),
                  const SizedBox(width: 12),
                  IconButton(icon: const Icon(Icons.people_outline, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.more_horiz, size: 20), onPressed: () {}),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.share_outlined, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.flash_on_outlined, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.fullscreen, size: 20), onPressed: () {}),
                ],
              ),
              const SizedBox(height: 16),
              // Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTab('Summary', Icons.summarize_outlined, false),
                    _buildTab('Timeline', Icons.timeline_outlined, false),
                    _buildTab('Backlog', Icons.view_list, true), // Active tab
                    _buildTab('Board', Icons.dashboard_outlined, false),
                    _buildTab('Calendar', Icons.calendar_today_outlined, false),
                    _buildTab('List', Icons.list_alt, false),
                    _buildTab('Forms', Icons.assignment_outlined, false),
                    _buildTab('Development', Icons.code, false),
                    _buildTab('Code', Icons.integration_instructions, false),
                    _buildTab('Archived work items', Icons.archive_outlined, false),
                    TextButton(
                      onPressed: () {},
                      child: const Text('More', style: TextStyle(color: Color(0xFF5E6C84))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- Backlog Content ---
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search and Filter
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFBFC),
                          border: Border.all(color: const Color(0xFFDFE1E6)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search backlog',
                            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF5E6C84)),
                            prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF5E6C84)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF6554C0),
                      child: const Text('U', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list, size: 18),
                      label: const Text('Filter'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF172B4D),
                        side: const BorderSide(color: Color(0xFFDFE1E6)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.open_in_full, size: 18), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.settings_outlined, size: 18), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.more_horiz, size: 18), onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 24),

                // Sprint Section
                _buildSprintSection(),

                const SizedBox(height: 24),

                // Backlog Section
                _buildBacklogSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String title, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18, color: isActive ? const Color(0xFF0052CC) : const Color(0xFF5E6C84)),
        label: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF0052CC) : const Color(0xFF5E6C84),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: isActive ? const Color(0xFFDEEBFF) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  Widget _buildSprintSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDFE1E6)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Sprint Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFBFC),
              border: Border(bottom: BorderSide(color: Color(0xFFDFE1E6))),
            ),
            child: Row(
              children: [
                const Icon(Icons.keyboard_arrow_down, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'QN Sprint 1',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF172B4D)),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_calendar, size: 16),
                  label: const Text('Add dates', style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0052CC),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('(0 work items)', style: TextStyle(fontSize: 14, color: Color(0xFF5E6C84))),
                const Spacer(),
                _buildStatusBadge('0', Colors.grey),
                const SizedBox(width: 8),
                _buildStatusBadge('0', const Color(0xFF0052CC)),
                const SizedBox(width: 8),
                _buildStatusBadge('0', const Color(0xFF00875A)),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Start sprint'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0052CC),
                    side: const BorderSide(color: Color(0xFFDFE1E6)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                IconButton(icon: const Icon(Icons.more_horiz, size: 18), onPressed: () {}),
              ],
            ),
          ),

          // Sprint Empty State
          Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                // Nếu bạn chưa có ảnh assets, dùng Icon thay thế để tránh lỗi
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEEBFF),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(Icons.assignment_outlined, size: 40, color: Color(0xFF0052CC)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Plan your sprint',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF172B4D)),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14, color: Color(0xFF5E6C84), height: 1.5),
                    children: [
                      TextSpan(text: 'Drag work items from the '),
                      TextSpan(text: 'Backlog', style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ' section or create new ones to plan the work for this sprint. Select '),
                      TextSpan(text: 'Start sprint', style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ' when you\'re ready.'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Create field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFDFE1E6))),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_box_outline_blank, size: 18, color: Color(0xFF5E6C84)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'What needs to be done?',
                      hintStyle: const TextStyle(color: Color(0xFF5E6C84)),
                      border: InputBorder.none,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.calendar_today_outlined, size: 18), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.person_outline, size: 18), onPressed: () {}),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Create'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBacklogSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDFE1E6)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFBFC),
              border: Border(bottom: BorderSide(color: Color(0xFFDFE1E6))),
            ),
            child: Row(
              children: [
                const Icon(Icons.keyboard_arrow_down, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Backlog',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF172B4D)),
                ),
                const SizedBox(width: 8),
                const Text('(0 work items)', style: TextStyle(fontSize: 14, color: Color(0xFF5E6C84))),
                const Spacer(),
                _buildStatusBadge('0', Colors.grey),
                const SizedBox(width: 8),
                _buildStatusBadge('0', const Color(0xFF0052CC)),
                const SizedBox(width: 8),
                _buildStatusBadge('0', const Color(0xFF00875A)),
                const SizedBox(width: 16),
                IconButton(icon: const Icon(Icons.swap_vert, size: 18), onPressed: () {}),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Create sprint'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0052CC),
                    side: const BorderSide(color: Color(0xFFDFE1E6)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Icon(Icons.inbox_outlined, size: 48, color: Color(0xFF5E6C84)),
                const SizedBox(height: 16),
                const Text(
                  'Your backlog is empty.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF5E6C84)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFDFE1E6))),
            ),
            child: Row(
              children: [
                const Icon(Icons.add, size: 18, color: Color(0xFF0052CC)),
                const SizedBox(width: 8),
                const Text(
                  'Create',
                  style: TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        count,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}