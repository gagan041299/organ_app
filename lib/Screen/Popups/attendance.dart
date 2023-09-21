import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceDialog extends StatefulWidget {
  @override
  State<AttendanceDialog> createState() => _AttendanceDialogState();
}

class _AttendanceDialogState extends State<AttendanceDialog> {
  LocationData? _locationData;
  bool _isLocation = false;
  bool isLoading = false;
  String? att;

  saveAttendance(String type) async {
    print(_locationData);
    final prefs = await SharedPreferences.getInstance();

    if (_isLocation) {
      setState(() {
        isLoading = true;
      });
      _locationData = await Location.instance.getLocation();
      var res = await getPostCall(attendaceUrl, {
        'lat': _locationData!.latitude.toString(),
        'long': _locationData!.longitude.toString(),
        'user_code': constUserModel!.userCode.toString(),
        'type': type
      });
      setState(() {
        isLoading = false;
      });
      var getData = json.decode(res.body);
      if (getData['status'] == 'success') {
        if (type == 'Login') {
          await prefs.setString('ATTENDANCE', 'checkin');
        } else {
          await prefs.remove('ATTENDANCE');
        }
      }
      getSnackbar(getData['message'], context);
      Navigator.pop(context);
      pushAndRemoveUntilNavigate(context, HomeScreen());
      print(getData);
    } else {
      await getPermission();
    }
  }

  getPermission() async {
    await Location.instance.hasPermission().then((value) async {
      print(value);
      if (value == PermissionStatus.granted ||
          value == PermissionStatus.grantedLimited) {
        await Location.instance.serviceEnabled().then((element) async {
          print(element);
          if (element == true) {
            setState(() {
              _isLocation = true;
            });
            _locationData = await Location.instance.getLocation();
          } else {
            await Location.instance.requestService();
          }
        });
      } else {
        await Location.instance.requestPermission().then((value) {
          getPermission();
        });
      }
    });
  }

  setAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    att = prefs.getString('ATTENDANCE');
  }

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? getLoading()
        : AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.all(10),
            buttonPadding: EdgeInsets.all(20),
            title: Container(
                padding: EdgeInsets.all(10),
                width: getTotalWidth(context),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: MyColors.primaryColor,
                ),
                child: getNormalText('Attendance', Colors.white, 18)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                ),
                getButton(
                    'CHECK IN',
                    constShowLogin == true ? Colors.green : Colors.grey,
                    constShowLogin == true ? Colors.green : Colors.grey, () {
                  constShowLogin == true ? saveAttendance('Login') : null;
                }, getTotalWidth(context) / 1.25),
                SizedBox(
                  height: 20,
                ),
                getButton(
                    'CHECK OUT',
                    constShowLogin == true ? Colors.grey : Colors.deepOrange,
                    constShowLogin == true ? Colors.grey : Colors.deepOrange,
                    () {
                  constShowLogin == true ? null : saveAttendance('Logout');
                }, getTotalWidth(context) / 1.25),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            actions: [
              // getSmallButton('UPDATE', MyColors.primaryColor, () {
              //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              //     builder: (context) {
              //       return HomeScreen(
              //         intialPage: 0,
              //       );
              //     },
              //   ), (route) => false);
              // }, getTotalWidth(context) / 4),
              getSmallButton('CANCEL', Colors.red, () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return HomeScreen();
                  },
                ), (route) => false);
              }, getTotalWidth(context) / 4),
            ],
          );
  }
}
