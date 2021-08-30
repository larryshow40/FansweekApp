import 'package:onoo/src/data/model/common/common_post.dart';

class TrendingModel {
  late bool success;
  late String message;
  late List<CommonPostModel> data = [];

  TrendingModel(
      {required this.success, required this.message, required this.data});

  TrendingModel.fromJson(Map<String, dynamic> json) {
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
