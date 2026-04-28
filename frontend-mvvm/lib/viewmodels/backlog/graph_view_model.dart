// lib/viewmodels/backlog/graph_view_model.dart
import 'package:flutter/material.dart';
import '../../models/backlog/graph_model.dart';
import '../../services/backlog/backlog_graph_service.dart';

class GraphViewModel extends ChangeNotifier {
  final GraphService _service = GraphService();

  bool isLoading = true;
  String? errorMessage;
  List<AnalyzedStory> stories = [];

  Future<void> fetchGraphData(String workspaceId, String backlogId, {String source = 'REALTIME'}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _service.getBacklogGraph(workspaceId, backlogId, source: source);
      if (data != null) {
        _parseGraphToStories(data);
      } else {
        errorMessage = "Failed to load graph data.";
      }
    } catch (e) {
      errorMessage = "Error connecting to server: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _parseGraphToStories(Map<String, dynamic> data) {
    final nodes = data['nodes'] as List<dynamic>? ?? [];
    final edges = data['edges'] as List<dynamic>? ?? [];

    List<AnalyzedStory> fetchedStories = [];

    // Map to quickly look up node labels by ID
    Map<String, String> nodeIdToLabel = {};
    for (var node in nodes) {
      String id = node['id']?.toString() ?? '';
      String label = node['label']?.toString() ?? '';
      if (id.isNotEmpty) {
        nodeIdToLabel[id] = label.isNotEmpty ? label : id;
      }
    }

    // Find all PERFORM edges (Subject -> Verb)
    var performEdges = edges.where((e) => e['type'] == 'PERFORM');

    for (var performEdge in performEdges) {
      String subjectId = performEdge['from']?.toString() ?? '';
      String verbId = performEdge['to']?.toString() ?? '';

      if (subjectId.isEmpty || verbId.isEmpty) continue;

      String subjectLabel = nodeIdToLabel[subjectId] ?? subjectId;
      String verbLabel = nodeIdToLabel[verbId] ?? verbId;

      // Find all TARGET edges starting from this verb (Verb -> Object)
      var targetEdges = edges.where((e) => e['type'] == 'TARGET' && e['from']?.toString() == verbId);

      if (targetEdges.isEmpty) {
        fetchedStories.add(AnalyzedStory(
          id: "${subjectId}_${verbId}",
          rawText: "$subjectLabel $verbLabel",
          subject: subjectLabel,
          verb: verbLabel,
          object: "Unknown",
          status: USStatus.todo,
        ));
      } else {
        for (var targetEdge in targetEdges) {
          String objectId = targetEdge['to']?.toString() ?? '';
          if (objectId.isEmpty) continue;
          
          String objectLabel = nodeIdToLabel[objectId] ?? objectId;

          fetchedStories.add(AnalyzedStory(
            id: "${subjectId}_${verbId}_${objectId}",
            rawText: "$subjectLabel $verbLabel $objectLabel",
            subject: subjectLabel,
            verb: verbLabel,
            object: objectLabel,
            status: USStatus.todo,
          ));
        }
      }
    }

    stories = fetchedStories;
  }
}