import 'dart:convert';

import 'package:arbenn/data/api.dart';
import 'package:arbenn/themes/arbenn_colors.dart';

class TagWidgetInfos {
  final TagData data;
  bool isActive;
  Function()? onTap;

  TagWidgetInfos({required this.data, this.isActive = false, this.onTap});
}

class TagData {
  final String label;
  final int id;
  final Nuances nuances;

  TagData({required this.id, required this.label, required this.nuances});
}

class TagSearch {
  List<TagWidgetInfos> tags = [];
  List<TagData> searchResult = [];

  Future<void> newSearch(String query, Function() onTap) async {
    String? infos = await Api.unsafeGet("/t/search/$query%");
    if (infos == null) {
      return;
    }
    List<dynamic> l = jsonDecode(infos);
    List<TagData> searchResult = l
        .map((r) => TagData(
            id: r['tagid'],
            label: r['label'],
            nuances: Nuances.get(r['color'])))
        .toList();
    tags.removeWhere((element) => !element.isActive);
    for (var i = 0; i < searchResult.length; i++) {
      if (!tags.any((element) => element.data.id == searchResult[i].id)) {
        tags.add(
          TagWidgetInfos(
              data: searchResult[i],
              onTap: () {
                toggle(searchResult[i].id);
                onTap();
              }),
        );
      }
    }
  }

  setSelectedTags(List<TagData> newTags, Function() onTap) {
    for (var i = 0; i < newTags.length; i++) {
      if (!tags.any((element) => element.data.id == newTags[i].id)) {
        tags.add(TagWidgetInfos(
            data: newTags[i],
            onTap: () {
              toggle(newTags[i].id);
              onTap();
            },
            isActive: true));
      }
    }
  }

  List<TagData> getSelecteTags() {
    return tags.where((t) => t.isActive).map((t) => t.data).toList();
  }

  toggle(int id) {
    if (tags.firstWhere((tag) => tag.data.id == id).isActive) {
      deactivate(id);
    } else {
      activate(id);
    }
  }

  deactivate(int id) {
    tags.firstWhere((tag) => tag.data.id == id).isActive = false;
    if (!searchResult.any((t) => t.id == id)) {
      tags.removeWhere((element) => element.data.id == id);
    }
  }

  activate(int label) {
    tags.firstWhere((tag) => tag.data.id == label).isActive = true;
  }
}
