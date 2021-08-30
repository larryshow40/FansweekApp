import 'package:hive/hive.dart';
part 'onno_user.g.dart';

@HiveType(typeId: 9)
class OnnoUser extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? firstName;
  @HiveField(2)
  String? lastName;
  @HiveField(3)
  String? image;
  @HiveField(4)
  var passwordAvailable;
  @HiveField(5)
  String? joinDate;
  @HiveField(6)
  String? lastLogin;
  @HiveField(7)
  String? about;
  @HiveField(8)
  var socials;
  @HiveField(9)
  String? gender;
  @HiveField(10)
  String? phone;
  @HiveField(11)
  String? email;
  @HiveField(12)
  String? dob;
  @HiveField(13)
  String? token;

  OnnoUser(
      {this.id,
      this.firstName,
      this.lastName,
      this.image,
      this.passwordAvailable,
      this.joinDate,
      this.lastLogin,
      this.about,
      this.socials,
      this.gender,
      this.phone,
      this.email,
      this.dob,
      this.token});

  OnnoUser.fromJson(Map<String, dynamic> json) {
    id = json["id"] == null ? null : json["id"];
    firstName = json["first_name"] != null ? json["first_name"] : "";
    lastName = json["last_name"] != null ? json["last_name"] : "";
    image = json["image"] == null ? null : json["image"];
    passwordAvailable =
        json["password_available"] == null ? null : json["password_available"];
    joinDate = json["join_data"] != null ? json["join_data"] : null;
    lastLogin = json["last_login"] != null ? json["last_login"] : null;
    about = json["about"] != null ? json['about'] : null;
    socials = json["socials"] != null ? json["socials"] : null;
    gender = json["gender"] == null ? null : json["gender"];
    phone = json["phone"] == null ? null : json["phone"];
    email = json["email"] == null ? null : json["email"];
    dob = json["dob"] == null ? null : json["dob"];
    token = json["token"] != null ? json["token"] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    data['password_available'] = this.passwordAvailable;
    data['join_date'] = this.joinDate;
    data['last_login'] = this.lastLogin;
    data['about'] = this.about;
    data['socials'] = this.socials;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data["token"] = this.token;
    return data;
  }
}
