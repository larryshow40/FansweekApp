import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onoo/config.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:onoo/src/data/bloc/phone_auth/phone_auth_event.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/widgets/custom_edit_text.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PhoneNumberInput extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _phoneTextController = TextEditingController();
  String _selectedCountryCode = Config.selectedCountryCode;
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppThemeData.wholeScreenPadding * 3,
          vertical: AppThemeData.wholeScreenPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppThemeData.wholeScreenPadding * 2),
              child: Center(
                child: isDark
                    ? Image.asset('assets/images/logo_dark.png',scale: 2,)
                    : Image.asset('assets/images/logo_light.png',scale: 2,),
              ),
            ),
            SizedBox(height: AppThemeData.wholeScreenPadding * 3),
            Text(
              helper.getTranslated(context, AppTags.signInLowerCase),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              helper.getTranslated(context, AppTags.signInWithPhoneNumber),
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Utils.getTextColor().withOpacity(0.7)),
            ),
            SizedBox(height: 50),

            Form(
              key: _formKey,
              child: CustomEditText().getCustomEditText(
                  isDark: isDark,
                  hintText: helper.getTranslated(context, AppTags.phoneNumber),
                  controller: _phoneTextController,
                  keyboardType: TextInputType.phone,
                  height: 55.0,
                  prefixWidget: _countryCode(context)),
            ),

            SizedBox(height: AppThemeData.wholeScreenPadding * 2),
            //Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: InkWell(
                  onTap: (){
                    if (_formKey.currentState!.validate()) {
                      print("---------selectedCountryCode: $_selectedCountryCode${_phoneTextController.text}");
                      BlocProvider.of<PhoneAuthBloc>(context).add(SendOtpEvent(phoneNumber: _selectedCountryCode + _phoneTextController.value.text));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff161A25), Color(0xff63666D)],
                            begin:Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 150, height: 45),
                      child: Center(child: Text(helper.getTranslated(context, AppTags.signUpLowerCase),style: TextStyle(color:  isDark ? AppThemeData.textColorDark : Colors.white),),),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _countryCode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CountryCodePicker(
        textStyle: Theme.of(context).textTheme.headline2,
        onChanged: (value) {
          _selectedCountryCode = value.dialCode!;
        },
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: Config.initialCountrySelection,
        favorite: Config.favouriteCountryCode,
        // optional. Shows only country name and flag
        showCountryOnly: false,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        alignLeft: false,
      ),
    );
  }
}
