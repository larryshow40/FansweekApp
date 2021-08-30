class AuthorProfile {
  late bool success;
  late String message;
  late Data data;

  AuthorProfile(
      {required this.success, required this.message, required this.data});

  AuthorProfile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = new Data.fromJson(json['data']);
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
  late int id;
  late String name;
  late String profileImage;
  late int totalComments;
  late int totalVideo;

  Data(
      {required this.id,
      required this.name,
      required this.profileImage,
      required this.totalComments,
      required this.totalVideo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    profileImage = json['profile_image'] ?? "";
    totalComments = json['total_comments'] ?? 0;
    totalVideo = json['total_video'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['total_comments'] = this.totalComments;
    data['total_video'] = this.totalVideo;
    return data;
  }
}
