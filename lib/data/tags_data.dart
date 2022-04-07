import 'package:cloud_firestore/cloud_firestore.dart';

class TagWidgetInfos {
  final TagData data;
  bool isActive;
  Function()? onTap;

  TagWidgetInfos({required this.data, this.isActive = false, this.onTap});
}

class TagData {
  final String label;
  final String id;

  TagData({required this.id, required this.label});

  static Future<List<TagData>?> loadFromIds(List<String> ids) async {
    return (FirebaseFirestore.instance
            .collection('tags')
            .where(FieldPath.documentId, whereIn: ids)
            .limit(100)
            .get()
            .then((snapshot) => snapshot.docs
                .map((e) =>
                    TagData(id: e.id, label: e.data()["frenchName"] as String))
                .toList()) as Future<List<TagData>?>)
        .onError((error, stackTrace) => null);
  }
}

class TagSearch {
  List<TagWidgetInfos> tags = [];
  List<TagData> searchResult = [];

  Future<void> newSearch(String query, Function(Function()) setState) async {
    searchResult = await FirebaseFirestore.instance
        .collection('tags')
        .where("frenchQueries", arrayContains: query)
        .limit(100)
        .get()
        .then((snapshot) => snapshot.docs
            .map((e) =>
                TagData(id: e.id, label: e.data()["frenchName"] as String))
            .toList());
    tags.removeWhere((element) => !element.isActive);
    for (var i = 0; i < searchResult.length; i++) {
      if (!tags.any((element) => element.data.id == searchResult[i].id)) {
        tags.add(TagWidgetInfos(
            data: searchResult[i],
            onTap: () => setState(() => toggle(tags[i].data.id))));
      }
    }
  }

  setSelectedTags(List<TagData> newTags, Function(Function()) setState) {
    for (var i = 0; i < newTags.length; i++) {
      if (!tags.any((element) => element.data.id == newTags[i].id)) {
        tags.add(TagWidgetInfos(
            data: newTags[i],
            onTap: () => setState(() => toggle(newTags[i].id)),
            isActive: true));
      }
    }
  }

  toggle(String id) {
    print(tags);
    if (tags.firstWhere((tag) => tag.data.id == id).isActive) {
      deactivate(id);
    } else {
      activate(id);
    }
  }

  deactivate(String id) {
    tags.firstWhere((tag) => tag.data.id == id).isActive = false;
    if (!searchResult.any((t) => t.id == id)) {
      tags.removeWhere((element) => element.data.id == id);
    }
  }

  activate(String label) {
    tags.firstWhere((tag) => tag.data.id == label).isActive = true;
  }
}
