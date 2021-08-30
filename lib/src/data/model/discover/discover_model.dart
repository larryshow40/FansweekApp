class DiscoverModel {
  late bool success;
  late String message;
  late Data data;

  DiscoverModel({required this.success, required this.message, required this.data});

  DiscoverModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late List<RecommendedCategories> recommendedCategories = [];
  late List<FeaturedCategories> featuredCategories = [];
  late List<DiscoverByCategories> discoverByCategories = [];

  Data(
      {required this.recommendedCategories,
      required this.featuredCategories,
      required this.discoverByCategories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['recommended_categories'] != null) {
      var jsonList = json['recommended_categories'] as List;
      jsonList
          .map((e) => RecommendedCategories.fromJson(e))
          .toList()
          .forEach((element) {
        recommendedCategories.add(element);
      });
    }
    if (json['featured_categories'] != null) {
      var jsonList = json['featured_categories'] as List;
      jsonList
          .map((e) => FeaturedCategories.fromJson(e))
          .toList()
          .forEach((element) {
        featuredCategories.add(element);
      });
    }
    if (json['discover_by_categories'] != null) {
      var jsonList = json['discover_by_categories'] as List;
      jsonList.map((e) => DiscoverByCategories.fromJson(e)).toList().forEach((element) {
        discoverByCategories.add(element);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recommended_categories'] =
        this.recommendedCategories.map((v) => v.toJson()).toList();
    data['featured_categories'] =
        this.featuredCategories.map((v) => v.toJson()).toList();
    data['discover_by_categories'] =
        this.discoverByCategories.map((v) => v.toJson()).toList();
    return data;
  }
}

class RecommendedCategories {
  late int id;
  late String categoryName;
  late String slug;
  late String image;

  RecommendedCategories(
      {required this.id,
      required this.categoryName,
      required this.slug,
      required this.image});

  RecommendedCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    slug = json['slug'];
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    data['image'] = this.image;
    return data;
  }
}

class FeaturedCategories {
  late int id;
  late String categoryName;
  late String slug;
  late String image;

  FeaturedCategories(
      {required this.id,
      required this.categoryName,
      required this.slug,
      required this.image});

  FeaturedCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    slug = json['slug'];
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    data['image'] = this.image;
    return data;
  }
}

class DiscoverByCategories {
  late int id;
  late String categoryName;
  late List<SubCategory> subCategory = [];

  DiscoverByCategories(
      {required this.id,
      required this.categoryName,
      required this.subCategory});

  DiscoverByCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['sub_category'] != null) {
      var jsonList = json['sub_category'] as List;
      jsonList.map((e) => SubCategory.fromJson(e)).toList().forEach((element) {
        subCategory.add(element);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['sub_category'] = this.subCategory.map((v) => v.toJson()).toList();
    return data;
  }
}

class SubCategory {
  late int id;
  late String subCategoryName;
  late int categoryId;

  SubCategory(
      {required this.id,
      required this.subCategoryName,
      required this.categoryId});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryName = json['sub_category_name'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_category_name'] = this.subCategoryName;
    data['category_id'] = this.categoryId;
    return data;
  }
}
