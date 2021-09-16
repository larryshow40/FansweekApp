import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onoo/src/presentation/video_screen.dart';

class APIService {
  // API key
  static const _api_key = "edmL7VpyK8msh29ZfiWpoBMyNAwAp1eM0RkjsnpfADSAsb6Tr5";

  // Base API url
  static const String _baseUrl = "football-prediction-api.p.rapidapi.com";

  // Base headers for Response url
  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-host": _baseUrl,
    "x-rapidapi-key": _api_key,
  };

  static Future<List<Map<String, dynamic>>> getPredictions(
      String date, String fed, String market) async {
    var dateTime = DateTime.now();
    String isoDate = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

    if (date != "") {
      isoDate = date;
    }
    Uri uri = Uri.parse(fed != "" && market != ""
        ? "https://football-prediction-api.p.rapidapi.com/api/v2/predictions?market=$market&iso_date=$isoDate&federation=$fed"
        : "https://football-prediction-api.p.rapidapi.com/api/v2/predictions?iso_date=$isoDate");
    final response = await http.get(uri, headers: _headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = List<Map<String, dynamic>>.from(jsonResponse['data']);
      return data;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }

  static Future<List<String>> federationsOptions() async {
    final Uri uri = Uri.parse(
        'https://football-prediction-api.p.rapidapi.com/api/v2/list-federations');
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("jsonResponse=${jsonResponse['data']}");
      return List<String>.from(jsonResponse['data']);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }

  static Future<List<String>> marketsOptions() async {
    final Uri uri = Uri.parse(
        'https://football-prediction-api.p.rapidapi.com/api/v2/list-markets');
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("jsonResponse=${jsonResponse['data']['all']}");
      return List<String>.from(jsonResponse['data']['all']);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }

  static Future<Map<String, dynamic>> awayTeamRecentMatches(String id) async {
    final Uri uri = Uri.parse(
        'https://football-prediction-api.p.rapidapi.com/api/v2/away-last-10/$id');
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = Map<String, dynamic>.from(jsonResponse['data']);
      return {
        "away_encounters": data["encounters"],
        "away_stats": data["stats"],
      };
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }

  static Future<Map<String, dynamic>> homeTeamRecentMatches(String id) async {
    try {
      final Uri uri = Uri.parse(
          'https://football-prediction-api.p.rapidapi.com/api/v2/home-last-10/$id');

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final data = Map<String, dynamic>.from(jsonResponse['data']);

        return {
          "home_encounters": data["encounters"],
          "home_stats": data["stats"],
        };
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load json data');
      }
    } catch (e) {
      throw (e);
    }
  }

  static Future<Map<String, dynamic>> headToHead(String id) async {
    try {
      final Uri uri = Uri.parse(
          'https://football-prediction-api.p.rapidapi.com/api/v2/head-to-head/$id');

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final data = Map<String, dynamic>.from(jsonResponse['data']);

        return {
          "head_encounters": data["encounters"],
        };
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load json data');
      }
    } catch (e) {
      throw (e);
    }
  }

  static Future<Map<String, dynamic>> getMoreDetail(String id) async {
    Uri uri = Uri.parse(
        "https://football-prediction-api.p.rapidapi.com/api/v2/predictions/$id");
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = List<Map<String, dynamic>>.from(jsonResponse['data']);
      final awayData = await awayTeamRecentMatches(id);
      final homeData = await homeTeamRecentMatches(id);
      final headData = await headToHead(id);
      final Map<String, dynamic> toData = {
        ...data.first,
        ...awayData,
        ...homeData,
        ...headData,
      };
      return toData;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }
}
