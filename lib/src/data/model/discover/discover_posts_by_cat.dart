import 'package:onoo/src/data/model/common/common_post.dart';

class DiscoverPostsByCat {
  late bool success;
  late String message;
  late List<CommonPostModel> data = [];

  DiscoverPostsByCat(
      {required this.success, required this.message, required this.data});

  DiscoverPostsByCat.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}
