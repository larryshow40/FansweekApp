import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:onoo/src/data/phone_auth_repository.dart';
import 'phone_auth_event.dart';
import 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final PhoneAuthRepository repository;
  // ignore: cancel_subscriptions
  StreamSubscription? subscription;
  String verId = "";

  PhoneAuthBloc({@required required PhoneAuthRepository repository})
      : repository = repository,
        super(InitialLoginState());

  PhoneAuthState get initialState => InitialLoginState();

  @override
  Stream<PhoneAuthState> mapEventToState(
    PhoneAuthEvent event,
  ) async* {
    if (event is SendOtpEvent) {
      yield LoadingState();
      subscription = sendOtp(event.phoneNumber).listen((event) {
        add(event);
      });
    } else if (event is OtpSendEvent) {
      yield OtpSentState();
    } else if (event is LoginCompleteEvent) {
      yield LoginCompleteState(firebaseUser: event.firebaseUser);
    } else if (event is LoginExceptionEvent) {
      yield ExceptionState(message: event.message);
    } else if (event is VerifyOtpEvent) {
      yield LoadingState();
      try {
        UserCredential credential = await repository.verifyAndLogin(
            verificationId: verId, smsCode: event.otp);
        if (credential.user != null) {
          yield LoginCompleteState(firebaseUser: credential.user!);
        } else {
          yield OtpExceptionState(message: "Invalid OTP");
        }
      } catch (e) {
        yield OtpExceptionState(message: "Invalid OTP");
      }
    }
  }

  @override
  void onEvent(PhoneAuthEvent event) {
    super.onEvent(event);
    print(event);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(stacktrace);
  }

  Future<void> close() async {
    //print("Bloc closed");
    super.close();
  }

  Stream<PhoneAuthEvent> sendOtp(String phoneNumber) async* {
    StreamController<PhoneAuthEvent> eventStream = StreamController();
    final phoneVerificationCompleted = (AuthCredential authCredential) {
      repository.getUser();
      User? user = repository.getUser();
      if (user != null) {
        eventStream.add(LoginCompleteEvent(firebaseUser: user));
        eventStream.close();
      } else {
        print("------------phone auth error");
      }
    };

    final phoneVerificationFailed = (FirebaseAuthException authException) {
      print(authException.message);
      eventStream.add(LoginExceptionEvent(message: onError.toString()));
      eventStream.close();
    };

    final phoneCodeSent = (String verificationId, [int? forceRecent]) {
      this.verId = verificationId;
      eventStream.add(OtpSendEvent());
    };

    final phoneCodeAutoRetrievalTimeout = (String verId) {
      this.verId = verId;
      eventStream.close();
    };

    print("----------otp function: $phoneNumber");

    await repository.sendOtp(
        phoneNumber: phoneNumber,
        timeOut: Duration(seconds: 1),
        phoneVerificationFailed: phoneVerificationFailed,
        phoneVerificationCompleted: phoneVerificationCompleted,
        phoneCodeSent: phoneCodeSent,
        autoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);

    yield* eventStream.stream;
  }
}
