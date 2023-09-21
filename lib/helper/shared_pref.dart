import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userTokenKey = "USERTOKEN";
  static String profileSet = "PROFILESET";
  static String userName = 'USERNAME';
  static String role = 'ROLE';
  static String attendanceStatus = 'ATTENDANCE';
  static String userAddress = 'USERADDRESS';
  static String userMobileNumber = 'USERADDRESS';

  //save data
  Future<bool> saveUserToken(String getUserToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userTokenKey, getUserToken);
  }

  Future<bool> saveProfileSet(String getProfileSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(profileSet, getProfileSet);
  }

  Future<bool> saveRole(String getRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(role, getRole);
  }

  Future<bool> saveUserName(String getUSerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userName, getUSerName);
  }

  Future<bool> saveUserAddress(String getUserAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userAddress, getUserAddress);
  }

  Future<bool> saveUserMobile(String getUserMobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userMobileNumber, getUserMobile);
  }

  Future<bool> saveAttendance(String getAttendance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(attendanceStatus, getAttendance);
  }

  // get data
  Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userTokenKey);
  }

  Future<String?> getProfileSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profileSet);
  }

  Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(role);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userName);
  }

  Future<String?> getUserAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userAddress);
  }

  Future<String?> getUserMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userMobileNumber);
  }

  Future<String?> getAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(attendanceStatus);
  }
}
