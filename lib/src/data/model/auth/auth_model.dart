import 'package:onoo/src/data/model/auth/onno_user.dart';

class AuthModel {
  late var success;
  late String message;
  late OnnoUser data;

  AuthModel({required this.success, required this.message, required this.data});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = OnnoUser.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data.toJson();
    return data;
  }
}
