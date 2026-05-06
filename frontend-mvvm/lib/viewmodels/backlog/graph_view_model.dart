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

    // Map to quickly look up node data by ID
    Map<String, Map<String, dynamic>> nodeIdToNode = {};
    for (var node in nodes) {
      String id = node['id']?.toString() ?? '';
      if (id.isNotEmpty) {
        nodeIdToNode[id] = node as Map<String, dynamic>;
      }
    }

    // Find all PERFORM edges (Subject -> Verb)
    var performEdges = edges.where((e) => e['type'] == 'PERFORM');

    for (var performEdge in performEdges) {
      String subjectId = performEdge['from']?.toString() ?? '';
      String verbId = performEdge['to']?.toString() ?? '';

      if (subjectId.isEmpty || verbId.isEmpty) continue;

      String subjectLabel = nodeIdToNode[subjectId]?['label']?.toString() ?? subjectId;
      String verbLabel = nodeIdToNode[verbId]?['label']?.toString() ?? verbId;
      
      double? subjectPriority = (nodeIdToNode[subjectId]?['priority'] as num?)?.toDouble();
      double? verbPriority = (nodeIdToNode[verbId]?['priority'] as num?)?.toDouble();
      
      double? performScore = (performEdge['score'] as num?)?.toDouble();
      double? performConfidence = (performEdge['confidence'] as num?)?.toDouble();

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
          subjectPriority: subjectPriority,
          verbPriority: verbPriority,
          performScore: performScore,
          performConfidence: performConfidence,
        ));
      } else {
        for (var targetEdge in targetEdges) {
          String objectId = targetEdge['to']?.toString() ?? '';
          if (objectId.isEmpty) continue;
          
          String objectLabel = nodeIdToNode[objectId]?['label']?.toString() ?? objectId;
          double? objectPriority = (nodeIdToNode[objectId]?['priority'] as num?)?.toDouble();
          
          double? targetScore = (targetEdge['score'] as num?)?.toDouble();
          double? targetConfidence = (targetEdge['confidence'] as num?)?.toDouble();

          fetchedStories.add(AnalyzedStory(
            id: "${subjectId}_${verbId}_${objectId}",
            rawText: "$subjectLabel $verbLabel $objectLabel",
            subject: subjectLabel,
            verb: verbLabel,
            object: objectLabel,
            status: USStatus.todo,
            subjectPriority: subjectPriority,
            verbPriority: verbPriority,
            objectPriority: objectPriority,
            performScore: performScore,
            performConfidence: performConfidence,
            targetScore: targetScore,
            targetConfidence: targetConfidence,
          ));
        }
      }
    }

    stories = fetchedStories;
  }
}