import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthRepository {
  final FirebaseAuth _firebaseAuth;

  PhoneAuthRepository(FirebaseAuth? firebaseAuth) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> sendOtp(
      {required String phoneNumber,
      required Duration timeOut,
      required PhoneVerificationFailed phoneVerificationFailed,
      required PhoneVerificationCompleted phoneVerificationCompleted,
      required PhoneCodeSent phoneCodeSent,
      required PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout}) async {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeOut,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  Future<UserCredential> verifyAndLogin({
    required String verificationId,
    required String smsCode,
  }) async {
    AuthCredential authCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    return _firebaseAuth.signInWithCredential(authCredential);
  }

  User? getUser() {
    var user = _firebaseAuth.currentUser;
    return user;
  }
}
