const PRINT_LOG_TAG = "[ONNO-Flutter]";
//make print log enable to false to stop print printLog
const PRINT_LOG_ENABLE = true;

printLog(dynamic data) {
  if (PRINT_LOG_ENABLE) {
    print("$PRINT_LOG_TAG${data.toString()}");
  }
}
class Constants {
  //hive box names
  //don't change anything here
  static final String configDataBoxName = "configData";
  static final String userLoginStatusBoxName = "userLoginData";
  static final String userDataBoxName = "userDataBox";
  static final String themeModeConstant = "themeMode";
}
