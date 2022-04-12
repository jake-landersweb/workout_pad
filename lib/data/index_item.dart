class IndexItem {
  late String title;
  late String id;
  late List<String> categories;

  IndexItem({
    required this.title,
    required this.id,
    required this.categories,
  });

  IndexItem.fromJson(dynamic json) {
    title = json['title'];
    id = json['id'];
    categories = [for (var i in json['categories']) i];
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "id": id,
      "categories": categories,
    };
  }
}
