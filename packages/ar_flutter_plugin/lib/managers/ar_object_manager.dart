import '../models/ar_anchor.dart';
import '../models/ar_node.dart';

class ARObjectManager {
  final List<ARNode> nodes = <ARNode>[];
  final Map<ARNode, ARPlaneAnchor?> nodeAnchors = <ARNode, ARPlaneAnchor?>{};

  Future<void> onInitialize() async {}

  Future<bool> addNode(ARNode node, {ARPlaneAnchor? planeAnchor}) async {
    nodes.add(node);
    nodeAnchors[node] = planeAnchor;
    return true;
  }

  Future<bool> removeNode(ARNode node) async {
    nodes.remove(node);
    nodeAnchors.remove(node);
    return true;
  }
}
