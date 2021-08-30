import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onoo/src/data/model/auth/auth_model.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:async';
import '../repository.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthHelper {
  //google sign in helper
  Future<bool?> signInWithGoogle() async {
    User? user = await _signInWithGoogle();
    // printLog("user:$user");
    if (user != null) {
      printLog("user:${user.uid}");
      AuthModel? authModel = await Repository().firebaseAuth(uid: user.uid.toString(), email: user.email.toString());//send user data to server
      //save user login data to database
      if (authModel != null) {
        //sign in complete
        printLog("---------google auth: success");
        return true;
      } else {
        // sign in failed
        printLog("---------google auth: failed");
        return false;
      }
    } else {
      printLog("---------google auth: failed- credential null.");
      return false;
    }
  }
  //google sign in helper
  Future<bool?> signInWithApple() async {
    User? user = await _signInWithApple();
    // printLog("user:$user");
    if (user != null) {
      printLog("user:${user.uid}");
      AuthModel? authModel = await Repository().firebaseAuth(uid: user.uid.toString(), email: user.email.toString());//send user data to server
      //save user login data to database
      if (authModel != null) {
        //sign in complete
        printLog("---------google auth: success");
        return true;
      } else {
        // sign in failed
        printLog("---------google auth: failed");
        return false;
      }
    } else {
      printLog("---------google auth: failed- credential null.");
      return false;
    }
  }

  // ignore: missing_return
  Future<User?> _signInWithGoogle() async {
    printLog("Inside_signInWithGoogle");
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User? user = (await _auth.signInWithCredential(credential)).user;
    printLog("userEmail:${user!.email}");
    if (user.email != null && user.email != "") {
      assert(user.email != null);
    }
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    // ignore: unnecessary_null_comparison
    assert(await user.getIdToken() != null);

    final User? currentUser = _auth.currentUser;
    assert(user.uid == currentUser!.uid);
    if (user != null) return user;
  }

 //Facebook login
  Future<bool> signInWithFacebook() async {
    final AccessToken token;
    final existingToken = await FacebookAuth.instance.accessToken;
    if (existingToken != null) {
      //token already exist
      token = existingToken;
      return await _fbLogin(token);
    } else {
      //token null, try to new login
      final result = await FacebookAuth.instance.login(
        permissions: [
          'email',
          // 'public_profile',
          'first_name', 'image',
        ],
        loginBehavior: LoginBehavior.dialogOnly,
      );
      if (result.status == LoginStatus.success && result.accessToken != null) {
        token = result.accessToken!;
        return await _fbLogin(token);
      } else {
        return false;
      }
    }
  }

// ignore: missing_return
  Future<User?>  _signInWithApple() async{
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(appleCredential.authorizationCode);
    final OAuthProvider oAuthProvider= OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(idToken: appleCredential.identityToken,accessToken: appleCredential.authorizationCode);
    final User? user = (await _auth.signInWithCredential(credential)).user;
    //print(user.email);
    if(user!.email != null && user.email != ""){
      assert(user.email != null);
    }
    if(user.displayName != null && user.displayName != ""){
      assert(user.displayName != null);
    }
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User? currentUser = (await _auth.signInWithCredential(credential)).user;
    assert(user.uid == currentUser!.uid);
    if (user != null) return user;
  }




  //facebook_login_function
  Future<bool> _fbLogin(AccessToken token) async {
    printLog("----------facebook login success");
    final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData(fields: "email,name");
    //print("--------facebook login: ${userData["email"]}");
    //now create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(token.token);
    //once signed in, create the UseCredential
    UserCredential? credential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    // ignore: unnecessary_null_comparison
    if (credential != null) {
      User? user = credential.user;
      if (user != null) {
        printLog("----------facebook auth: UID: ${user.uid}");
        printLog("----------facebook auth: Name: ${user.displayName}");
        printLog("----------facebook auth: email: ${userData["email"]}");
        AuthModel? authModel = await Repository().firebaseAuth(uid: user.uid.toString(), email: userData["email"]);
        if (authModel != null) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
