import 'package:flutter/material.dart';


class NavigationService {
   GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName, String postId,imageUrl) {
    print("Inside_navigate_TO");
    return navigatorKey.currentState!.pushNamed(routeName,arguments: {
      "postId" : int.parse(postId),
      "image" : imageUrl,
    });
  }
}