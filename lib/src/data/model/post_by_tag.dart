import 'package:onoo/src/data/model/common/common_post.dart';

class PostByTag {
  late bool success;
  late String message;
  late List<CommonPostModel> data = [];

  PostByTag({required this.success, required this.message, required this.data});

  PostByTag.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      var jsonList = json['data'] as List;
      jsonList
          .map((e) => CommonPostModel.fromJson(e))
          .toList()
          .forEach((element) {
        data.add(element);
      });
    }
  }
}
