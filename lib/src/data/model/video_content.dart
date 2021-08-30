class VideoContent {
  bool? success;
  String? message;
  List<Data>? data = [];

  VideoContent({this.success, this.message, this.data});

  VideoContent.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      var jsonList = json['data'] as List;
      jsonList.map((e) => Data.fromJson(e)).toList().forEach((element) {
        data!.add(element);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? catType;
  String? catTitle;
  List<Post>? sliders = [];
  List<Post>? articles = [];
  List<Post>? trendingPosts = [];
  List<String>? tags = [];

  Data(
      {this.catType,
      this.sliders,
      this.articles,
      this.trendingPosts,
      this.tags});

  Data.fromJson(Map<String, dynamic> json) {
    catType = json['cat_type'];
    catTitle = json['cat_title'];

    if (json['sliders'] != null) {
      var jsonList = json['sliders'] as List;
      jsonList.map((e) => Post.fromJson(e)).toList().forEach((element) {
        sliders!.add(element);
      });
    } else {
      sliders = null;
    }
    if (json['articles'] != null) {
      var jsonList = json['articles'] as List;
      jsonList.map((e) => Post.fromJson(e)).toList().forEach((element) {
        articles!.add(element);
      });
    } else {
      articles = null;
    }

    if (json['trending_posts'] != null) {
      var jsonList = json['trending_posts'] as List;
      jsonList.map((e) => Post.fromJson(e)).toList().forEach((element) {
        trendingPosts!.add(element);
      });
    } else {
      trendingPosts = null;
    }
    if (json['tags'] != null) {
      var list = json['tags'];
      list.forEach((item) {
        if (item != "") {
          tags!.add(item);
        }
      });
    } else {
      tags = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_type'] = this.catType;
    data['cat_title'] = this.catTitle;
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    if (this.articles != null) {
      data['articles'] = this.articles!.map((v) => v.toJson()).toList();
    }

    if (this.trendingPosts != null) {
      data['trending_posts'] =
          this.trendingPosts!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags;
    }
    return data;
  }
}

class Post {
  int? id;
  int? categoryId;
  int? imageId;
  int? userId;
  String? title;
  String? slug;
  String? postType;
  String? tags;
  String? createdAt;
  String? created;
  int? commentsCount;
  HomeContentImage? image;
  Category? category;
  UserData? user;

  Post(
      {this.id,
      this.categoryId,
      this.imageId,
      this.userId,
      this.title,
      this.slug,
      this.postType,
      this.tags,
      this.createdAt,
      this.created,
      this.commentsCount,
      this.image,
      this.category,
      this.user});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    imageId = json['image_id'];
    userId = json['user_id'];
    title = json['title'];
    slug = json['slug'];
    postType = json['post_type'];
    tags = json['tags'];
    createdAt = json['created_at'];
    created = json['created'];
    commentsCount = json['commentsCount'];
    image = json['image'] != null ? new HomeContentImage.fromJson(json['image']) : null;
    category = json['category'] != null ? new Category.fromJson(json['category']) : null;
    user = json['user'] != null ? new UserData.fromJson(json['user']) : null;
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
    data['created'] = this.created;
    data['commentsCount'] = this.commentsCount;
    if (this.image != null) {data['image'] = this.image!.toJson();
    }
    if (this.category != null) {data['category'] = this.category!.toJson();
    }
    if (this.user != null) {data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class HomeContentImage {
  String? originalImage;
  String? ogImage;
  String? thumbnail;
  String? bigImage;
  String? bigImageTwo;
  String? mediumImage;
  String? mediumImageTwo;
  String? mediumImageThree;
  String? smallImage;

  HomeContentImage(
      {this.originalImage,
      this.ogImage,
      this.thumbnail,
      this.bigImage,
      this.bigImageTwo,
      this.mediumImage,
      this.mediumImageTwo,
      this.mediumImageThree,
      this.smallImage});

  HomeContentImage.fromJson(Map<String, dynamic> json) {
    originalImage = json['original_image'];
    ogImage = json['og_image'];
    thumbnail = json['thumbnail'];
    bigImage = json['big_image'];
    bigImageTwo = json['big_image_two'];
    mediumImage = json['medium_image'];
    mediumImageTwo = json['medium_image_two'];
    mediumImageThree = json['medium_image_three'];
    smallImage = json['small_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original_image'] = this.originalImage;
    data['og_image'] = this.ogImage;
    data['thumbnail'] = this.thumbnail;
    data['big_image'] = this.bigImage;
    data['big_image_two'] = this.bigImageTwo;
    data['medium_image'] = this.mediumImage;
    data['medium_image_two'] = this.mediumImageTwo;
    data['medium_image_three'] = this.mediumImageThree;
    data['small_image'] = this.smallImage;
    return data;
  }
}

class Category {
  int? id;
  String? categoryName;
  String? slug;

  Category({this.id, this.categoryName, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    return data;
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? socialMedia;
  String? image;

  UserData({this.id, this.firstName, this.lastName});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'] != null ? json['email'] : null;
    socialMedia = json["social_media"] != null ? json["social_media"] : null;

    image = json['image'] != null ? json['image'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['social_media'] = this.socialMedia;
    data['image'] = this.image;
    return data;
  }
}
