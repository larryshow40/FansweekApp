import 'package:onoo/src/data/model/all_tags.dart';
import 'package:onoo/src/data/model/auth/auth_model.dart';
import 'package:onoo/src/data/model/author/author_post_model.dart';
import 'package:onoo/src/data/model/author/author_profile.dart';
import 'package:onoo/src/data/model/comment/all_comments.dart';
import 'package:onoo/src/data/model/comment/reply_model.dart';
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/data/model/discover/discover_model.dart';
import 'package:onoo/src/data/model/discover/discover_posts_by_cat.dart';
import 'package:onoo/src/data/model/home_content/home_content.dart';
import 'package:onoo/src/data/model/post_by_tag.dart';
import 'package:onoo/src/data/model/post_details.dart';
import 'package:onoo/src/data/model/sign_up_model.dart';
import 'package:onoo/src/data/model/sub_cat_posts_model.dart';
import 'package:onoo/src/data/model/trending_model.dart';
import 'package:onoo/src/data/model/video_content.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:http/http.dart' as http;
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:path/path.dart';
import 'package:onoo/config.dart';
import 'model/config/config_model.dart';
import 'dart:convert';
import 'dart:io';

class Repository {
  late String selectedLanguageCode = DatabaseConfig().getSelectedLanguageCode();
  // late String selectedLanguageCode = 'bn';

  //signUp
  Future<SignUp?> signUp(
      {required String firstName,
      required String lastName,
      required String email,
      var password}) async {
    var url = Uri.parse("${Config.API_SERVER_URL}/v10/registers");
    var headers = {"apiKey": Config.API_KEY};
    var body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      'password': password,
      'password_confirmation': password,
      'gender': 'null'
    };

    try {
      var response = await http.post(url, headers: headers, body: body);
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        SignUp signUp = SignUp.fromJson(jsonResponse);
        return signUp;
      }
      return null;
    } catch (e) {
      print('------login error: ' + e.toString());
      return null;
    }
  }

  //login
  Future<AuthModel?> login(
      {required String email, required String password}) async {
    var url = Uri.parse("${Config.API_SERVER_URL}/v10/login");
    var headers = {
      "apiKey": Config.API_KEY,
    };
    var body = {
      "email": email,
      "password": password,
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        AuthModel authModel = AuthModel.fromJson(jsonResponse);
        //save login data to database
        DatabaseConfig().saveUserData(authModel.data);
        DatabaseConfig().saveIsUserLoggedIn(true);
        return authModel;
      }
      return null;
    } catch (e) {
      print('------login error: ' + e.toString());
      return null;
    }
  }

  //config_data
  Future<ConfigData?> getConfigData() async {
    var url =
        Uri.parse("${Config.API_SERVER_URL}/v10/config?lang=$selectedLanguageCode");
    var headers = {"apiKey": Config.API_KEY};
    try {
      var response = await http.get(url, headers: headers);
      // print("-----------" + response.toString());
      ConfigData? configData = ConfigData.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        //save config data to database
        await DatabaseConfig().saveConfigData(configData);
        return configData;
      } else {
        print('-----------getConfig response error');
        //throw Exception();
        return null;
      }
    } catch (e) {
      print('GetConfigData failed: ' + e.toString());
      return null;
    }
  }

  //get_home_content
  Future<HomeContent?> getHomeContent() async {
    var url = Uri.parse(
        "${Config.API_SERVER_URL}/v10/home-contents?lang=$selectedLanguageCode");
    var headers = {"apiKey": Config.API_KEY};
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      HomeContent? homeContentData =
          HomeContent.fromJson(json.decode(response.body));

      if (response.statusCode == 200 && homeContentData.data != null) {
        return homeContentData;
      } else {
        print('-----------getHomeContent response error');
        return null;
      }
    } catch (e) {
      print('---------GetHomeContent failed: ' + e.toString());
      return null;
    }
  }

  //video posts
  Future<VideoContent?> getVideoContent() async {
    var headers = {"apiKey": Config.API_KEY};
    try {
      var url = Uri.parse(
          "${Config.API_SERVER_URL}/v10/video-posts-page?lang=$selectedLanguageCode");
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        VideoContent? videoContent =
            VideoContent.fromJson(json.decode(response.body));
        // ignore: unnecessary_null_comparison
        if (videoContent != null) {
          return videoContent;
        }
        return null;
      }
      return null;
    } catch (e) {
      print("-----------Video content error: ${e.toString()}");
      return null;
    }
  }

  //firebase auth
  Future<AuthModel?> firebaseAuth({
    required String uid,
    String? email,
  }) async {
    var url = Uri.parse("${Config.API_SERVER_URL}/v10/firebase-auth");
    var headers = {"apiKey": Config.API_KEY};

    print("uid:$uid");
    print("email:$email");

    Map<String, dynamic> data = {
      "uid": uid,
      // "email": email,
    };
    try {
      final response = await http.post(url,
          headers: headers, body: data, encoding: Encoding.getByName("utf-8"));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          AuthModel authModel = AuthModel.fromJson(jsonData);
          print("---------FirebaseAuth: id: ${authModel.data.id.toString()}");
          print(authModel.data.email);
          print(authModel.data.toJson().toString());
          //save to database
          DatabaseConfig().saveUserData(authModel.data);
          DatabaseConfig().saveIsUserLoggedIn(true);
          return authModel;
        } else {
          print("---------firebase auth: error");
          return null;
        }
      } else {
        print("---------firebase auth: response code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("---------Firebase auth error: $e");
      return null;
    }
  }

  //firebase auth
  Future<AuthModel?> firebaseAuthPhone(
      {required String uid, String? phoneNumber}) async {
    var url = Uri.parse("${Config.API_SERVER_URL}/v10/firebase-auth");
    var headers = {
      "apiKey": Config.API_KEY,
    };
    Map<String, dynamic> data = {"uid": uid, "phone": phoneNumber ?? null};
    try {
      final response = await http.post(url,
          headers: headers, body: data, encoding: Encoding.getByName("utf-8"));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          AuthModel authModel = AuthModel.fromJson(jsonData);
          print("---------FirebaseAuth: id: ${authModel.data.id.toString()}");
          //save to database
          DatabaseConfig().saveUserData(authModel.data);
          DatabaseConfig().saveIsUserLoggedIn(true);
          return authModel;
        } else {
          print("---------firebase auth: error");
          return null;
        }
      } else {
        print("---------firebase auth: response code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("---------Firebase auth error: $e");
      return null;
    }
  }

  //post details
  Future<PostDetails?> getPostDetails({required int id}) async {
    print("postID:$id");
    var url = Uri.parse("${Config.API_SERVER_URL}/v10/detail/$id?lang=$selectedLanguageCode");
    var headers = {"apiKey": Config.API_KEY};
    try {
      final response = await http.get(url, headers: headers);
      PostDetails postDetails = PostDetails.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        return postDetails;
      } else {
        return null;
      }
    } catch (e) {
      print("-------Post details data failed: ${e.toString()}");
      return null;
    }
  }

  //all tags
  Future<AllTags?> getAllTags() async {
    //String token = DatabaseConfig().getOnooUser()!.token!;
    var url = Uri.parse(
        "${Config.API_SERVER_URL}/v10/all-tags?lang=$selectedLanguageCode");
    var headers = {"apiKey": Config.API_KEY};
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        AllTags allTags = AllTags.fromJson(json.decode(response.body));
        return allTags;
      } else {
        return null;
      }
    } catch (e) {
      print('--------All Tags data get failed: $e');
      return null;
    }
  }

  //post by tag
  Future<PostByTag> getPostByTag({required String tag}) async {
    var url = Uri.parse(
        "${Config.API_SERVER_URL}/v10/post-by-tag/$tag?lang=$selectedLanguageCode");
    var headers = {"apiKey": Config.API_KEY};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      PostByTag posts = PostByTag.fromJson(jsonDecode(response.body));
      return posts;
    } else {
      throw Exception("Failed to load tag posts.");
    }
  }

  // Discover api
  Future<DiscoverModel> getDiscoverData() async {
    var url = Uri.parse("${Config.API_SERVER_URL}/v10/discover?lang=$selectedLanguageCode");
    var headers = {"apiKey": Config.API_KEY};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true) {
        DiscoverModel discover = DiscoverModel.fromJson(jsonDecode(response.body));
        return discover;
      }
      throw Exception("Failed to load discover data.");
    } else {
      throw Exception("Failed to load discover data.");
    }
  }

  // All posts related to discover category
  Future<DiscoverPostsByCat> getDiscoverPostByCategory({required String catType, required int catId, required int pageNumber}) async {
    var url = Uri.parse("${Config.API_SERVER_URL}/v10/discover-$catType-posts?page=1&category=$catId&lang=$selectedLanguageCode");
    var headers = {"apiKey": Config.API_KEY};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        DiscoverPostsByCat data = DiscoverPostsByCat.fromJson(jsonDecode(response.body));
        return data;
      } else {
        throw Exception("Discover post of $catType failed to load.");
      }
    } else {
      throw Exception("Discover post of $catType failed to load.");
    }
  }

  //get posts by subCat
  Future<SubCatPostsModel> getPostBySubCategory({required int subCatId}) async {
    var url = Uri.parse(
        "${Config.API_SERVER_URL}/v10/post-by-sub-category/$subCatId?lang=$selectedLanguageCode");
    var headers = {"apiKey": Config.API_KEY};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        SubCatPostsModel data =
            SubCatPostsModel.fromJson(jsonDecode(response.body));
        return data;
      } else {
        throw Exception("SubCat posts failed to load.");
      }
    } else {
      throw Exception("SubCat posts failed to load.");
    }
  }

  //get all trending posts
  Future<List<CommonPostModel>> getTrendingPosts(
      {required int pageNumber}) async {
    var url = Uri.parse(
        "${Config.API_SERVER_URL}/v10/trending-posts?page=$pageNumber&lang=$selectedLanguageCode");
    var headers = {"apiKey": Config.API_KEY};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        TrendingModel trendingPosts = TrendingModel.fromJson(jsonData);
        return trendingPosts.data;
      } else {
        throw Exception("Trending posts failed to load.");
      }
    } else {
      throw Exception("Trending posts failed to load.");
    }
  }

  //get_auth_profile
  Future<AuthorProfile> getAuthorProfile({required int authorId}) async {
    try {
      var url = Uri.parse(
          "${Config.API_SERVER_URL}/v10/author-profile?author_id=$authorId&lang=$selectedLanguageCode");
      var headers = {"apiKey": Config.API_KEY};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          AuthorProfile profile = AuthorProfile.fromJson(jsonData);
          print("-----------author data loaded.");
          return profile;
        } else {
          throw Exception("Author profile data fetch error.");
        }
      } else {
        print("-----------author data loaded.");
        throw Exception("Author profile data fetch error.");
      }
    } catch (e) {
      print("-----author profile error: $e");
      throw Exception("Author profile data fetch error.");
    }
  }

  //get all post data by author id
  Future<AuthorPostModel> getPostDataByAuthorId(
      {required int authorId, required int pageNumber}) async {
    try {
      var url = Uri.parse(
          "${Config.API_SERVER_URL}/v10/author-post?author_id=$authorId&page=$pageNumber&lang=$selectedLanguageCode");
      var headers = {"apiKey": Config.API_KEY};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          AuthorPostModel postModel = AuthorPostModel.fromJson(jsonData);
          return postModel;
        } else {
          throw Exception("Author post data fetch error.");
        }
      } else {
        throw Exception("Author post data fetch error.");
      }
    } catch (e) {
      print("-----author post data error: $e");
      throw Exception("Author post data fetch error.");
    }
  }

  // all comments
  Future<AllComments> getAllComments({required int postId}) async {
    try {
      var url = Uri.parse(
          "${Config.API_SERVER_URL}/v10/comments/$postId?lang=$selectedLanguageCode");
      var headers = {"apiKey": Config.API_KEY};
      final response = await http.get(url, headers: headers);
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        AllComments allComments = AllComments.fromJson(jsonResponse);
        return allComments;
      } else {
        throw Exception("----All comment data fetching error");
      }
    } catch (e) {
      print("----All comment data fetching error: $e");
      throw Exception("----All comment data fetching error: $e");
    }
  }

  // post_to_comment
  Future<String> postComment(
      {required int postId, required String comment}) async {
    print("postID:$postId");
    print("comment:$comment");
    try {
      String token = DatabaseConfig().getOnooUser()!.token!;
      var url = Uri.parse(
          "${Config.API_SERVER_URL}/v10/save-comment?token=$token&lang=$selectedLanguageCode");
      Map<String, String> headers = {
        "apiKey": Config.API_KEY,
      };
      var body = {
        "post_id": postId.toString(),
        "comment": comment,
      };
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["message"];
      }
      return "Failed";
    } catch (e) {
      print("----Add comment data fetching error: $e");
      throw Exception("----Add comment data fetching error: $e");
    }
  }

  //all reply of a comment
  Future<ReplyModel> getAllReplies({required int commentId}) async {
    try {
      var url = Uri.parse(
          "${Config.API_SERVER_URL}/v10/replies/$commentId?lang=$selectedLanguageCode");
      var headers = {"apiKey": Config.API_KEY};
      var response = await http.get(url, headers: headers);
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["success"]) {
        ReplyModel replyModel = ReplyModel.fromJson(jsonResponse);
        return replyModel;
      } else {
        throw Exception("----All replies data fetching error");
      }
    } catch (e) {
      throw Exception("----All replies data fetching error: $e");
    }
  }

  //post reply
  Future<bool> postReply(
      {required int postId,
      required int commentId,
      required String reply,
      required String token}) async {
    try {
      var url =
          Uri.parse("${Config.API_SERVER_URL}/v10/save-comment-reply?token=$token");
      var headers = {"apiKey": Config.API_KEY};
      var body = {
        "post_id": postId.toString(),
        "comment_id": commentId.toString(),
        "comment": reply,
      };
      final response = await http.post(url, headers: headers, body: body);
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        return true;
      }
      return false;
    } catch (e) {
      print("----Add comment data fetching error: $e");
      throw Exception("----Add comment data fetching error: $e");
    }
  }

  //update_profile
  Future<bool> updateProfile(
      {required int id,
      required String firstName,
      required String lastName,
      required String phoneNumber,
      required String emailAddress,
      required File image,
      required int gender,
      required String dob,
      required String about}) async {
    try {
      String token = DatabaseConfig().getOnooUser()!.token!;
      // printLog("id:$id");

      var url = Uri.parse(
          "${Config.API_SERVER_URL}/v10/user/update-profile?token=$token");
      var requestBody = http.MultipartRequest('POST', url);
      requestBody.headers['apiKey'] = Config.API_KEY;
      requestBody.fields['id'] = id.toString();
      requestBody.fields['first_name'] = firstName;
      requestBody.fields['last_name'] = lastName;
      requestBody.fields['email'] = emailAddress;
      requestBody.fields['phone'] = phoneNumber;
      requestBody.fields['gender'] = gender.toString();
      requestBody.fields['dob'] = dob;
      // requestBody.fields['about'] = about;
      var stream = http.ByteStream(image.openRead())..cast();
      var length = await image.length();
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: basename(image.path));
      requestBody.files.add(multipartFile);
      final response = await requestBody.send();
      final result = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(result.body);

      if (jsonResponse['success']) {
        OnnoUser user = OnnoUser.fromJson(jsonResponse['data']);
        DatabaseConfig().saveUserData(user);
        return jsonResponse['success'];
      }
      return false;
    } catch (e) {
      print("----Update profile data fetching error: $e");
      throw Exception("----Update profile data fetching error: $e");
    }
  }

  //get_myPost
  Future<List<CommonPostModel>> getMyPosts({required int id}) async {
    try {
      var url = Uri.parse("${Config.API_SERVER_URL}/v10/post-by-author/$id");
      var headers = {"apiKey": Config.API_KEY};
      var response = await http.get(url, headers: headers);
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["success"] && jsonResponse['data'] != null) {
        List<CommonPostModel> data = [];
        var jsonList = jsonResponse['data'] as List;
        jsonList
            .map((e) => CommonPostModel.fromJson(e))
            .toList()
            .forEach((element) {
          data.add(element);
        });
        return data;
      } else {
        throw Exception("----My post data fetching error");
      }
    } catch (e) {
      throw Exception("----My post data fetching error: $e");
    }
  }

  //search
  Future<List<CommonPostModel>> getSearchResults(
      {required String query}) async {
    try {
      var url = Uri.parse("${Config.API_SERVER_URL}/v10/search?search=$query");
      var headers = {"apiKey": Config.API_KEY};
      var response = await http.get(url, headers: headers);
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["success"] && jsonResponse['data'] != null) {
        List<CommonPostModel> data = [];
        var jsonList = jsonResponse['data'] as List;
        jsonList
            .map((e) => CommonPostModel.fromJson(e))
            .toList()
            .forEach((element) {
          data.add(element);
        });
        return data;
      } else {
        throw Exception("----Search data fetching error");
      }
    } catch (e) {
      throw Exception("----Search data fetching error: $e");
    }
  }

  Future<http.Response> forgotPassword({required String email}) async {
    try {
      var url = Uri.parse("${Config.API_SERVER_URL}/v10/forgot-password");
      var headers = {"apiKey": Config.API_KEY};
      var body = {
        "email": email,
      };
      http.Response response =
          await http.post(url, body: body, headers: headers);
      return response;
    } catch (e) {
      throw Exception("-------Forgot password api error");
    }
  }
}
