import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/bloc/firebase_auth/firebase_auth_bloc.dart';
import 'package:onoo/src/data/bloc/firebase_auth/firebase_auth_event.dart';
import 'package:onoo/src/data/bloc/firebase_auth/firebase_auth_state.dart';
import 'package:onoo/src/data/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:onoo/src/data/bloc/phone_auth/phone_auth_event.dart';
import 'package:onoo/src/data/bloc/phone_auth/phone_auth_state.dart';
import 'package:onoo/src/data/model/auth/auth_model.dart';
import 'package:onoo/src/data/phone_auth_repository.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/home_screen.dart';
import 'package:onoo/src/presentation/sign_up/phone_auth/phone_number_input.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PhoneAuthScreen extends StatelessWidget {
  static final String route = '/PhoneAuthScreen';
  late final PhoneAuthRepository repository;
  late Bloc firebaseAuthBloc;

  PhoneAuthScreen({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FirebaseAuthBloc, FirebaseAuthState>(
      listener: (context, state) {
        if (state is FirebaseAuthStateCompleted) {
          AuthModel authModel = state.getUser;
          // ignore: unnecessary_null_comparison
          if (authModel == null) {
            firebaseAuthBloc.add(FirebaseAuthFailed);
          } else {
            print('registration succeed');
            DatabaseConfig().saveUserData(authModel.data);
            DatabaseConfig().saveIsUserLoggedIn(true);
          }
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.route, (route) => false);
        }
      },
      child: BlocProvider<PhoneAuthBloc>(
        create: (context) => PhoneAuthBloc(repository: repository),
        child: Scaffold(
            appBar: AppBar(),
          body: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  PhoneAuthBloc? _phoneAuthBloc;
  bool isDark = false;
  FirebaseAuthBloc? firebaseAuthBloc;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.grey.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  void initState() {
    _phoneAuthBloc = BlocProvider.of<PhoneAuthBloc>(context);
    firebaseAuthBloc = BlocProvider.of<FirebaseAuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    String message = '';

    return BlocListener<PhoneAuthBloc, PhoneAuthState>(
        bloc: _phoneAuthBloc,
        listener: (context, loginState) {
          if (loginState is ExceptionState || loginState is OtpExceptionState) {
            if (loginState is ExceptionState) {
              message = loginState.message;
            } else if (loginState is OtpExceptionState) {
              message = loginState.message;
            }
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ));
          }
        },
        child: BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: isDark
                    ? AppThemeData.darkBackgroundColor
                    : AppThemeData.lightBackgroundColor,
                body: getViewsAsPerState(state),
              ),
            );
          },
        ));
  }

  //render views as per state
  getViewsAsPerState(PhoneAuthState state) {
    print("inside_getViewsAsPerState");
    print(state);
    if (state is OtpSentState || state is OtpExceptionState) {
      return _renderOTPStateUI();
    } else if (state is LoadingState) {
      return Center(child: LoadingIndicator());
    } else if (state is LoginCompleteState) {
      User firebaseUser = state.getUser();
      firebaseAuthBloc!.add(FirebaseAuthStarted());
      firebaseAuthBloc!.add(FirebaseAuthCompleting(
        uid: firebaseUser.uid,
        phone: firebaseUser.phoneNumber,
      ));
      print("---------user: " + firebaseUser.phoneNumber!);
      return Center(child: LoadingIndicator());
    } else {
      return PhoneNumberInput();
    }
  }

  Widget _renderOTPStateUI() {
    String inputPin = '';
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppThemeData.wholeScreenPadding * 3,
          vertical: AppThemeData.wholeScreenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppThemeData.wholeScreenPadding * 2),
            child: Center(
              child: isDark
                  ? Image.asset('assets/images/logo_dark.png', scale: 2,)
                  : Image.asset('assets/images/logo_light.png', scale: 2,),
            ),
          ),
          SizedBox(height: AppThemeData.wholeScreenPadding * 3),
          Text(
            helper.getTranslated(context, AppTags.verifyYourNumber),
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: AppThemeData.wholeScreenPadding),
          RichText(
            text: TextSpan(
              style: TextStyle(),
              children: <TextSpan>[
                TextSpan(
                  text: helper.getTranslated(context, AppTags.with6DigitsCode),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: isDark
                        ? AppThemeData.textColorDark
                        : AppThemeData.textColorLight,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.8,
                  ),
                ),
                TextSpan(
                  text: "+8801521200319",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                )
              ],
            ),
          ),
          SizedBox(height: AppThemeData.wholeScreenPadding * 2),
          Container(
            color: Utils.getBackgroundColor(isDark: isDark),
            margin: const EdgeInsets.all(AppThemeData.wholeScreenPadding),
            padding: const EdgeInsets.all(AppThemeData.wholeScreenPadding),
            child: PinPut(
              fieldsCount: 6,
              onSubmit: (value) {
                print("----------OnSubmit pin: $value");
                inputPin = value;
              },
              controller: _pinPutController,
              focusNode: _pinPutFocusNode,
              submittedFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3))
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 150, height: 45),
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<PhoneAuthBloc>(context, listen: false)
                        .add(VerifyOtpEvent(otp: inputPin));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff161A25), Color(0xff63666D)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Center(
                        child: Text(
                            helper.getTranslated(context, AppTags.verify))),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
