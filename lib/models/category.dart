class Category {
  final int id;
  final String name;
  final int? parent;
  final List<Category> subcategories;

  Category({
    required this.id,
    required this.name,
    this.parent,
    this.subcategories = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      parent: json['parent'],
      subcategories: [],
    );
  }

  static List<Category> fromJsonList(List<dynamic> jsonList) {
    final categories = jsonList.map((data) => Category.fromJson(data)).toList();

    // Organize categories into a hierarchy
    final Map<int, Category> categoryMap = {
      for (var category in categories) category.id: category
    };

    for (var category in categories) {
      if (category.parent != null && categoryMap.containsKey(category.parent!)) {
        categoryMap[category.parent!]!.subcategories.add(category);
      }
    }

    return categories.where((category) => category.parent == null).toList();
  }
}
