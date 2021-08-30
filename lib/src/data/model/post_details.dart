import 'package:onoo/src/data/model/common/common_post.dart';
import 'common/image_data.dart';
import 'common/user_data.dart';

class PostDetails {
  late int id;
  late int categoryId;
  late String language;
  late int userId;
  int? imageId;
  late String postType;
  int? videoId;
  String? videoUrlType;
  String? videoUrl;
  int? videoThumbnailId;
  late String title;
  late String slug;
  late String content;
  late List<String> tags = [];
  late String createdAt;
  late String url;
  late String created;
  late int commentsCount;
  late List<CommonPostModel> relatedPosts = [];
  late List<RelatedTopic> relatedTopic = [];
  CommonImageModel? image;
  Video? video;
  late CommonCategory category;
  late CommonUserModel user;

  PostDetails({
    required this.id,
    required this.categoryId,
    required this.language,
    required this.userId,
    this.imageId,
    required this.postType,
    this.videoId,
    this.videoUrlType,
    this.videoUrl,
    this.videoThumbnailId,
    required this.title,
    required this.slug,
    required this.content,
    required this.tags,
    required this.createdAt,
    required this.created,
    required this.commentsCount,
    required this.relatedPosts,
    required this.relatedTopic,
    required this.url,
    this.image,
    this.video,
    required this.category,
    required this.user,
  });

  PostDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    language = json['language'];
    userId = json['user_id'];
    imageId = json['image_id'];
    postType = json['post_type'] ?? "article";
    videoId = json['video_id'];
    videoUrlType = json['video_url_type'];
    videoUrl = json['video_url'];
    videoThumbnailId = json['video_thumbnail_id'];
    title = json['title'];
    url = json['url'] ?? "";
    slug = json['slug'];
    content = json['content'];
    if (json['tags'] != null) {
      var list = json['tags'];
      list.forEach((item) {
        if (item != "") {
          tags.add(item);
        }
      });
    }
    createdAt = json['created_at'];
    created = json['created'];
    commentsCount = json['commentsCount'];
    if (json['related_posts'] != null) {
      var jsonList = json['related_posts'] as List;
      jsonList
          .map((e) => CommonPostModel.fromJson(e))
          .toList()
          .forEach((element) {
        relatedPosts.add(element);
      });
    }
    if (json['related_topic'] != null) {
      var jsonList = json['related_topic'] as List;
      jsonList.map((e) => RelatedTopic.fromJson(e)).toList().forEach((element) {
        relatedTopic.add(element);
      });
    }
    image = json['image'] != null
        ? new CommonImageModel.fromJson(json['image'])
        : null;
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
    category = CommonCategory.fromJson(json['category']);
    user = CommonUserModel.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['language'] = this.language;
    data['user_id'] = this.userId;
    data['image_id'] = this.imageId;
    data['post_type'] = this.postType;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['content'] = this.content;
    data['tags'] = this.tags;
    data['created_at'] = this.createdAt;
    data['created'] = this.created;
    data['url'] = this.url;
    data['commentsCount'] = this.commentsCount;
    data['related_posts'] = this.relatedPosts.map((e) => e.toJson());
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    data['category'] = this.category.toJson();
    data['user'] = this.user.toJson();
    return data;
  }
}

class Video {
  int? id;
  String? videoThumbnail;
  String? original;
  String? v144p;
  String? v240p;
  String? v360p;
  String? v480p;
  String? v720p;
  String? v1080p;
  String? videoType;

  Video(
      {  this.id,
         this.videoThumbnail,
         this.original,
         this.v144p,
         this.v240p,
         this.v360p,
         this.v480p,
         this.v720p,
         this.v1080p,
        required this.videoType});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoThumbnail = json['video_thumbnail'];
    original = json['original'];
    v144p = json['v_144p'];
    v240p = json['v_240p'];
    v360p = json['v_360p'];
    v480p = json['v_480p'];
    v720p = json['v_720p'];
    v1080p = json['v_1080p'];
    videoType = json['video_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video_thumbnail'] = this.videoThumbnail;
    data['original'] = this.original;
    data['v_144p'] = this.v144p;
    data['v_240p'] = this.v240p;
    data['v_360p'] = this.v360p;
    data['v_480p'] = this.v480p;
    data['v_720p'] = this.v720p;
    data['v_1080p'] = this.v1080p;
    data['video_type'] = this.videoType;
    return data;
  }
}

class RelatedTopic {
  late int id;
  late String categoryName;
  late String slug;

  RelatedTopic(
      {required this.id, required this.categoryName, required this.slug});

  RelatedTopic.fromJson(Map<String, dynamic> json) {
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
