import 'package:cloud_firestore/cloud_firestore.dart';

class TagInfos {
  final String label;
  bool isActive;
  Function()? onTap;

  TagInfos({required this.label, this.isActive = false, this.onTap});
}

class TagSearch {
  List<TagInfos> tags = [];
  List<String> searchResult = [];

  Future<void> newSearch(String query, Function(String) onTap) async {
    List<String> searchResult = await FirebaseFirestore.instance
        .collection('tags')
        .where("searchQueries", arrayContains: query)
        .limit(100)
        .get()
        .then((snapshot) => snapshot.docs.map((e) => e.id).toList());
    tags.removeWhere((element) => !element.isActive);
    for (var i = 0; i < searchResult.length; i++) {
      if (!tags.any((element) => element.label == searchResult[i])) {
        tags.add(
            TagInfos(label: searchResult[i], onTap: onTap(searchResult[i])));
      }
    }
  }

  setSelectedTags(List<String> newTags, Function(String) onTap) {
    for (var i = 0; i < newTags.length; i++) {
      if (!tags.any((element) => element.label == newTags[i])) {
        tags.add(TagInfos(
            label: newTags[i], onTap: onTap(newTags[i]), isActive: true));
      }
    }
  }

  toggle(String label) {
    if (tags.firstWhere((tag) => tag.label == label).isActive) {
      deactivate(label);
    } else {
      activate(label);
    }
  }

  deactivate(String label) {
    tags.firstWhere((tag) => tag.label == label).isActive = false;
    if (!searchResult.contains(label)) {
      tags.removeWhere((element) => element.label == label);
    }
  }

  activate(String label) {
    tags.firstWhere((tag) => tag.label == label).isActive = true;
  }
}
