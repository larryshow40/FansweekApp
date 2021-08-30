class SignUp {
  late bool success;
  late String message;
  late Data data;

  SignUp({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SignUp.fromJson(Map<String, dynamic> json) => SignUp(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.phone,
    this.dob,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? phone;
  String? dob;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        phone: json["phone"],
        dob: json["dob"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "phone": phone,
        "dob": dob,
        "updated_at": updatedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "id": id,
      };
}
