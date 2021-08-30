import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class PhoneAuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends PhoneAuthEvent {
  final String phoneNumber;
  SendOtpEvent({required this.phoneNumber});
}

class AppStartEvent extends PhoneAuthEvent {}

class VerifyOtpEvent extends PhoneAuthEvent {
  final String otp;
  VerifyOtpEvent({required this.otp});
}

class LogoutEvent extends PhoneAuthEvent {}

class OtpSendEvent extends PhoneAuthEvent {}

class LoginCompleteEvent extends PhoneAuthEvent {
  final User firebaseUser;
  LoginCompleteEvent({required this.firebaseUser});
}

class LoginExceptionEvent extends PhoneAuthEvent {
  final String message;
  LoginExceptionEvent({required this.message});
}
