import 'package:onoo/src/data/model/common/image_data.dart';
import 'package:onoo/src/data/model/common/user_data.dart';

class CommonPostModel {
  int id;
  int categoryId;
  int? subCategoryId;
  int? imageId;
  int userId;
  String title;
  String slug;
  String postType;
  String tags;
  String createdAt;
  String created;
  int commentsCount;
  CommonImageModel? image;
  CommonUserModel user;
  CommonCategory? category;

  CommonPostModel(
      {required this.id,
      required this.categoryId,
      this.subCategoryId,
      this.imageId,
      required this.userId,
      required this.title,
      required this.slug,
      required this.postType,
      required this.tags,
      required this.createdAt,
      required this.created,
      required this.commentsCount,
      this.image,
      required this.user,
      this.category});

  factory CommonPostModel.fromJson(Map<String, dynamic> json) {
    return CommonPostModel(
        id: json['id'],
        categoryId: json['category_id'],
        subCategoryId: json['sub_category_id'] ?? null,
        imageId: json['image_id'] ?? null,
        userId: json['user_id'],
        title: json['title'] ?? "",
        slug: json['slug'] ?? "",
        postType: json['post_type'] ?? "",
        tags: json['tags'] ?? "",
        createdAt: json['created_at'] ?? "",
        created: json['created'] ?? "",
        commentsCount: json['commentsCount'] ?? 0,
        image: json['image'] != null
            ? CommonImageModel.fromJson(json['image'])
            : null,
        user: CommonUserModel.fromJson(json['user']),
        category: json['category'] != null
            ? new CommonCategory.fromJson(json['category'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['image_id'] = this.imageId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['post_type'] = this.postType;
    data['tags'] = this.tags;
    data['created_at'] = this.createdAt;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['user'] = this.user.toJson();
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class CommonCategory {
  late int id;
  late String categoryName;
  late String slug;

  CommonCategory(
      {required this.id, required this.categoryName, required this.slug});

  CommonCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'] ?? "";
    slug = json['slug'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    return data;
  }
}
