class ReplyModel {
  late bool success;
  late String message;
  List<Reply> data = [];

  ReplyModel(
      {required this.success, required this.message, required this.data});

  ReplyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      var jsonList = json['data'] as List;
      jsonList.map((e) => Reply.fromJson(e)).toList().forEach((element) {
        data.add(element);
      });
    }
  }
}

class Reply {
  late int id;
  late int postId;
  late int userId;
  late int commentId;
  late String comment;
  late int status;
  late String date;
  late User user;

  Reply(
      {required this.id,
      required this.postId,
      required this.userId,
      required this.commentId,
      required this.comment,
      required this.status,
      required this.date,
      required this.user});

  Reply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    commentId = json['comment_id'];
    comment = json['comment'] ?? "";
    status = json['status'];
    date = json['date'] ?? "";
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['comment_id'] = this.commentId;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['user'] = this.user.toJson();
    return data;
  }
}

class User {
  late int id;
  late String firstName;
  late String lastName;
  late String profileImage;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    profileImage = json['profile_image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
