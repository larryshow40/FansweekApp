class DataModel {
  bool status;
  String message;
  String name;
  String code;
  String endDate;
  List<Data> data;

  DataModel(
      {required this.status,
      required this.message,
      required this.data,
      required this.name,
      required this.code,
      required this.endDate});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
        status: json['status'],
        message: json['message'],
        name: json['name'],
        code: json['code'],
        endDate: json['end_date'],
        data: []);
    // if (json['data'] != null) {
    //   data = new List<Data>();
    //   json['data'].forEach((v) {
    //     data.add(new Data.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String  id;
  String name;
  String code;
  String createdAt;
  //String updatedAt;
  String user;
  String endDate;
  bool liked;
  String likesCount;
  String disLikesCount;



  Data(
      {required this.id,
      required this.name,
      required this.code,
      required this.liked,
      required this.createdAt,
      required this.likesCount,
      required this.disLikesCount,
      required this.user,
      required this.endDate});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'].toString(),
        name: json['name']??" ",
        code: json['code']?? " ",
        liked: json['liked']?? false,
        createdAt: json['created_at']?? " ",
        likesCount: json['likes_count'].toString(),
        disLikesCount: json['dislikes_count'].toString(),
        user: json['user']?? " ",
        endDate: json['end_date']?? " ");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['liked']=this.liked;
    data["created_at"]=this.createdAt;
    data['likes_count'] = this.likesCount;
    data['dislikes_count'] = this.disLikesCount;
    data['user'] = this.user;
    data['end_date'] = this.endDate;
    return data;
  }
}


// class DataModel {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;

//   DataModel(
//       {required this.userId,
//       required this.id,
//       required this.title,
//       required this.body});

//   factory DataModel.fromJson(Map<String, dynamic> json) {
//     return DataModel(
//         userId: json['userId'],
//         id: json['id'],
//         title: json['title'],
//         body: json['body']);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['userId'] = this.userId;
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['body'] = this.body;
//     return data;
//   }
// }



