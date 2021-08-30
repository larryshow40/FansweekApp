import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PhoneAuthState extends Equatable {}

class InitialLoginState extends PhoneAuthState {
  @override
  List<Object?> get props => [];
}

class OtpSentState extends PhoneAuthState {
  @override
  List<Object> get props => [];
}

class LoadingState extends PhoneAuthState {
  @override
  List<Object?> get props => [];
}

class OtpVerificationState extends PhoneAuthState {
  @override
  List<Object?> get props => [];
}

class LoginCompleteState extends PhoneAuthState {
  final User firebaseUser;
  LoginCompleteState({required this.firebaseUser});

  User getUser() {
    return firebaseUser;
  }

  @override
  List<Object?> get props => [firebaseUser];
}

class ExceptionState extends PhoneAuthState {
  final String message;
  ExceptionState({required this.message});
  @override
  List<Object?> get props => [message];
}

class OtpExceptionState extends PhoneAuthState {
  final String message;
  OtpExceptionState({required this.message});
  @override
  List<Object?> get props => [message];
}
