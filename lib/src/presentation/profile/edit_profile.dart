import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/home_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:onoo/src/widgets/custom_edit_text.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;

class EditProfile extends StatefulWidget {
  static final String route = '/EditProfile';
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  OnnoUser? user = DatabaseConfig().getOnooUser();
  bool isDark = false, isUserLoggedIn = false;
  late TextEditingController _firstNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _lastNameController;
  bool _isLoading = false;
  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  // late OnnoUser user;

  Future _pickImage() async {
    var image = await _imagePicker.getImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  int _genderValue = 0;
  //date
  late String selectedDay ;
  late String selectedMonth = "January";
  late String selectedYear ;


  List<DropdownMenuItem<String>> dayList = [];
  void _createDayList() {
    dayList = [];
    for (int i = 1; i <= 31; i++) {
      dayList.add(DropdownMenuItem(
        child: Text(
          i.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
        value: i.toString(),
      ));
    }
  }

//month
  var months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  List<DropdownMenuItem<String>> monthList = [];
  void _createMonthList() {
    monthList = [];
    for (int i = 0; i < 12; i++) {
      monthList.add(DropdownMenuItem(
        child: Text(
          months[i].toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
        value: months[i].toString(),
      ));
    }
  }

//year
  List<DropdownMenuItem<String>> yearList = [];
  void _createYearList() {
    yearList = [];
    for (int i = 1940; i <= 2100; i++) {
      yearList.add(DropdownMenuItem(
        child: Text(
          i.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
        value: i.toString(),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = new TextEditingController(text: user!.email);
    _phoneController = new TextEditingController(text: user!.phone);
    _firstNameController = new TextEditingController(text: user!.firstName);
    _lastNameController = new TextEditingController(text: user!.lastName);
    printLog("dob:${user!.dob}");

    buildUserDOB(user!.dob);

  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  buildUserDOB(String? dob){
    print(dob);
    DateTime userDob = dob == "0000-00-00"? DateTime.now(): DateTime.parse(dob!); //by_pass_default_date
    selectedDay = userDob.day.toString();
    selectedYear = userDob.year.toString();

    Future.delayed(Duration.zero, () {
      _getCurrentMonthName(userDob.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    printLog("_EditProfileState");
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    _createDayList();
    _createMonthList();
    _createYearList();

    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: isDark
              ? AppThemeData.darkBackgroundColor
              : AppThemeData.lightBackgroundColor,
          appBar: AppBar(
              title: Text(helper.getTranslated(context, AppTags.updateProfile), style: Theme.of(context).textTheme.headline3,
          )),
          body: Stack(
            children: [
              _buildUI(),
              Visibility(
                  visible: _isLoading,
                  child: Center(
                    child: LoadingIndicator(),
                  )),
            ],
          )),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isDark
                              ? Colors.white
                              : AppThemeData.textColorDark,
                          width: 4.0,
                          style: BorderStyle.solid),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _imageFile == null
                            ? AssetImage("assets/images/logo_round.png")
                            : FileImage(_imageFile!) as ImageProvider,
                      )),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: -8,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            _pickImage();
                          },
                          child: SvgPicture.asset(
                            isDark
                                ? "assets/images/icons/edit_round_dark.svg"
                                : "assets/images/icons/edit_round.svg",
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //user name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    user!.firstName! + " " + user!.lastName!,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),

                // name filed
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomEditText().getCustomEditText(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      isDark: isDark,
                      hintText:
                          helper.getTranslated(context, AppTags.firstName),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(letterSpacing: 0.78),
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(letterSpacing: 0.78),
                      controller: _firstNameController,
                      keyboardType: TextInputType.name,
                      suffixWidget: Image.asset(
                        "assets/images/login_screen/user_name.png",
                        scale: 2.0,
                      ),
                    ),
                    //last name
                    CustomEditText().getCustomEditText(
                      isDark: isDark,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      hintText: helper.getTranslated(context, AppTags.lastName),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(letterSpacing: 0.78),
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(letterSpacing: 0.78),
                      controller: _lastNameController,
                      keyboardType: TextInputType.name,
                      suffixWidget: Image.asset(
                        "assets/images/login_screen/user_name.png",
                        scale: 2.0,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 12,
                ),
                //phone input
                CustomEditText().getCustomEditText(
                  isDark: isDark,
                  hintText: helper.getTranslated(context, AppTags.phoneNumber),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(letterSpacing: 0.78),
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(letterSpacing: 0.78),
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  suffixWidget: Image.asset(
                    "assets/images/icons/phone_light.png",
                    scale: 2.0,
                  ),
                ),

                SizedBox(
                  height: 12,
                ),

                //email
                CustomEditText().getCustomEditText(
                  isDark: isDark,
                  hintText: helper.getTranslated(context, AppTags.emailAddress),
                  controller: _emailController,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(letterSpacing: 0.78),
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(letterSpacing: 0.78),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  suffixWidget: Image.asset(
                    "assets/images/icons/email.png",
                    scale: 1.5,
                  ),
                ),
                //Gender section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        unselectedWidgetColor:
                            isDark ? Colors.white : Colors.black),
                    child: Row(
                      children: [
                        Text(
                          helper.getTranslated(context, AppTags.gender),
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Spacer(),
                        Radio(
                          value: 0,
                          groupValue: _genderValue,
                          onChanged: _handleRadioValueChanged,
                          activeColor: isDark
                              ? AppThemeData.textColorDark
                              : AppThemeData.textColorLight,
                        ),
                        Text(
                          helper.getTranslated(context, AppTags.male),
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.8,
                                  ),
                        ),
                        Radio(
                          value: 1,
                          groupValue: _genderValue,
                          onChanged: _handleRadioValueChanged,
                          activeColor: isDark
                              ? AppThemeData.textColorDark
                              : AppThemeData.textColorLight,
                        ),
                        Text(
                          helper.getTranslated(context, AppTags.female),
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.8,
                                  ),
                        )
                      ],
                    ),
                  ),
                ),

                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppThemeData.darkBackgroundColor
                                  .withOpacity(0.8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppThemeData.shadowColor,
                              blurRadius: 5.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Container(
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: selectedDay,
                                  items: dayList,
                                  hint: Text(
                                    selectedDay,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDay = value.toString();
                                      print(selectedDay);
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 15,
                    ),
                    // month picker
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppThemeData.darkBackgroundColor
                                  .withOpacity(0.8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppThemeData.shadowColor,
                              blurRadius: 5.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: selectedMonth,
                                  items: monthList,
                                  hint: Text(
                                    selectedMonth,
                                    style: Theme.of(context).textTheme.headline2,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMonth = value.toString();
                                      print(selectedMonth);
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 15,
                    ),
                    //year picker
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppThemeData.darkBackgroundColor
                                  .withOpacity(0.8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppThemeData.shadowColor,
                              blurRadius: 5.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: selectedYear,
                                  items: yearList,
                                  hint: Text(
                                    selectedYear,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedYear = value.toString();
                                      print(selectedYear);
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                //save button
                SizedBox(
                  height: 30,
                ),
                //save button
                CustomButtonGradient(
                    isDark: isDark,
                    text: helper.getTranslated(context, AppTags.save),
                    onPressed: () {
                      _updateProfile();
                    }),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _updateProfile() async {
    FocusScope.of(context).unfocus();
    if (_firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _imageFile != null) {
      String dob = selectedYear +
          "-" +
          _getMonthNumber(selectedMonth).toString() +
          "-" +
          selectedDay;
      setState(() {
        _isLoading = true;
      });
      bool result = await Repository().updateProfile(
          id: user!.id!,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneController.text,
          emailAddress: _emailController.text,
          image: _imageFile!,
          gender: _genderValue,
          dob: dob,
          about: "");
      if (result) {
        Utils.showSnackBar(
            context: context, isSuccess: true, message: "Profile updated.");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        setState(() {
          Utils.showSnackBar(
              context: context,
              isSuccess: true,
              message:
                  helper.getTranslated(context, AppTags.somethingWentWrong));
        });
      }
    } else {
      Utils.showSnackBar(
          context: context, message: "Fields must not be empty.");
    }
  }

  void _handleRadioValueChanged(int? value) {
    setState(() {
      FocusScope.of(context).unfocus();
      _genderValue = value!;

      switch (_genderValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }

  void _getCurrentMonthName(int month) {
    String name = "";

    switch (month) {
      case 1:
        name = months[0];
        break;
      case 2:
        name = months[1];
        break;
      case 3:
        name = months[2];
        break;
      case 4:
        name = months[3];
        break;
      case 5:
        name = months[4];
        break;
      case 6:
        name = months[5];
        break;
      case 7:
        name = months[6];
        break;
      case 8:
        name = months[7];
        break;
      case 9:
        name = months[8];
        break;
      case 10:
        name = months[9];
        break;
      case 11:
        name = months[10];
        break;
      case 12:
        name = months[11];
        break;
    }
    setState(() {
      FocusScope.of(context).unfocus();
      selectedMonth = name;
    });
  }

  int _getMonthNumber(String monthName) {
    switch (monthName) {
      case "January":
        return 01;
      case "February":
        return 02;
      case "March":
        return 03;
      case "April":
        return 04;
      case "May":
        return 05;
      case "June":
        return 06;
      case "July":
        return 07;
      case "August":
        return 08;
      case "September":
        return 09;
      case "October":
        return 10;
      case "November":
        return 11;
      case "December":
        return 12;
      default:
        return 01;
    }
  }
}
