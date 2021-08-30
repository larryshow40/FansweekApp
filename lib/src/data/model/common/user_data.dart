class CommonUserModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? socialMedia;
  String? image;

  CommonUserModel({this.id, this.firstName, this.lastName});

  CommonUserModel.fromJson(Map<String, dynamic> json) {
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
