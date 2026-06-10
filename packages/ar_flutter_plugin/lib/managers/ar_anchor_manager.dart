import '../models/ar_anchor.dart';

class ARAnchorManager {
  final List<ARAnchor> anchors = <ARAnchor>[];

  Future<bool> addAnchor(ARAnchor anchor) async {
    anchors.add(anchor);
    return true;
  }

  Future<bool> removeAnchor(ARAnchor anchor) async {
    anchors.remove(anchor);
    return true;
  }
}
