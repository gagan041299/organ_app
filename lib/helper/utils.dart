import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Screen/Forms/reimburstment.dart';
import 'package:orgone_app/Screen/LoginAndRegistration/login_screen.dart';
import 'package:orgone_app/Screen/LoginAndRegistration/updatePassword.dart';
import 'package:orgone_app/Screen/Popups/attendance.dart';
import 'package:orgone_app/Screen/Profile/profile_screen.dart';
import 'package:orgone_app/Screen/history_screen.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

getTotalWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

getTotalHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

// this is the app bar we used for the home screen

getOtherScreenAppBar(String title, BuildContext context) {
  return AppBar(
    elevation: 0,
    title:
        Text(title, style: GoogleFonts.openSans(fontWeight: FontWeight.w600)),
  );
}

getLoginScreenAppBar(String title, BuildContext context) {
  return AppBar(
    toolbarHeight: MediaQuery.of(context).size.height / 3,
    elevation: 0,
    title: Text(title),
    flexibleSpace: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: 400,
          color: MyColors.primaryColor,
          child: Image.asset('assets/images/logo.png'),
        ),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: 20,
        )
      ],
    ),
  );
}

getHomeScreenAppBar(BuildContext context) {
  return AppBar(
    // toolbarHeight: 80,
    elevation: 0,
    centerTitle: true,

    title: Text('Dashboard',
        style: GoogleFonts.openSans(fontWeight: FontWeight.w600)),
  );
}

getBoldText(String text, Color color, double size) {
  return Text(
    text,
    style: GoogleFonts.lato(
        textStyle: TextStyle(
            fontSize: size, fontWeight: FontWeight.bold, color: color)),
    textAlign: TextAlign.start,
  );
}

getNormalText(String text, Color color, double size) {
  return Text(
    text,
    style: GoogleFonts.lato(textStyle: TextStyle(fontSize: size, color: color)),
    textAlign: TextAlign.start,
  );
}

getNormalTextCenter(String text, Color color, double size) {
  return Text(
    text,
    style: GoogleFonts.lato(textStyle: TextStyle(fontSize: size, color: color)),
    textAlign: TextAlign.center,
  );
}

pushNavigate(BuildContext context, Widget widget) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}

pushAndRemoveUntilNavigate(BuildContext context, Widget widget) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: ((context) => widget)), (route) => false);
}

pushReplacementNavigate(BuildContext context, Widget widget) {
  return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

getButton(
    String text, Color color, Color color2, VoidCallback onTap, double width) {
  return InkWell(
    splashColor: Colors.white,
    onTap: onTap,
    child: Ink(
        // alignment: Alignment.center,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(color: Colors.grey, offset: Offset(0, 5), blurRadius: 2)
          // ],
          gradient: LinearGradient(colors: [
            color,
            color2,
          ]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: getBoldText(text, Colors.white, 16),
        )),
  );
}

getSmallButton(String text, Color color, VoidCallback onTap, double width) {
  return InkWell(
    splashColor: Colors.white,
    onTap: onTap,
    child: Ink(
        // alignment: Alignment.center,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(color: Colors.grey, offset: Offset(0, 5), blurRadius: 2)
          // ],
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: getBoldText(text, Colors.white, 10),
        )),
  );
}

Widget getLoading() {
  return Center(
    child: Container(
      width: 50,
      child: LoadingIndicator(
          indicatorType: Indicator.ballBeat,

          /// Required, The loading type of the widget
          colors: const [MyColors.primaryColor, MyColors.secondaryColor],

          /// Optional, The color collections
          strokeWidth: 2,

          /// Optional, The stroke of the line, only applicable to widget which contains line
          backgroundColor: Colors.transparent,

          /// Optional, Background of the widget
          pathBackgroundColor: Colors.black

          /// Optional, the stroke backgroundColor
          ),
    ),
  );
}

getSnackbar(String text, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 1),
      content: getNormalText(text, Colors.white, 14),
      showCloseIcon: true,
    ),
  );
}

String formatDateTimeMonth(String datetime) {
  return DateFormat('yyyy-MM-dd').format(DateTime.parse(datetime));
}

Text getNormalTextStart(String text, double fontSize, Color color) {
  return Text(
    text,
    style: TextStyle(
      overflow: TextOverflow.clip,
      fontSize: fontSize,
      color: color,
    ),
    textAlign: TextAlign.start,
    softWrap: true,
  );
}

getAlertDialog(
    BuildContext context, VoidCallback onAccept, String title, String content) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text("Yes"),
    onPressed: onAccept,
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

getDrawer(BuildContext context, String version) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20))),
              height: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: getNormalText(
                    'Hello, ${constUserModel!.userCode} ${constUserModel!.firstName} ${constUserModel!.lastName}',
                    Colors.white,
                    16),
              ),
            )),
        ListTile(
          leading: Icon(
            Icons.home,
            color: Colors.grey,
          ),
          title: getNormalText('Home', Colors.black, 16),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        // Divider(),
        ListTile(
          leading: Icon(
            Icons.history,
            color: Colors.grey,
          ),
          title: getNormalText('History', Colors.black, 16),
          onTap: () {
            pushNavigate(context, HistoryScreen());
          },
        ),
        ListTile(
          leading: Icon(
            Icons.history,
            color: Colors.grey,
          ),
          title: getNormalText('Attendace', Colors.black, 16),
          onTap: () {
            showDialog(
                context: context,
                builder: ((BuildContext context) {
                  return AttendanceDialog();
                }));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.money,
            color: Colors.grey,
          ),
          title: getNormalText('Reimburstment', Colors.black, 16),
          onTap: () {
            showDialog(
                context: context,
                builder: ((BuildContext context) {
                  return ReimburstmentForm();
                }));
          },
        ),
        // Divider(),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.grey,
          ),
          title: getNormalText('Profile', Colors.black, 16),
          onTap: () {
            pushNavigate(context, ProfileScreen());
          },
        ),
        // Divider(),
        ListTile(
          leading: Icon(
            Icons.format_align_center,
            color: Colors.grey,
          ),
          title: getNormalText('About us', Colors.black, 16),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        // Divider(),
        ListTile(
          leading: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
          title: getNormalText('Contact us', Colors.black, 16),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        // Divider(),
        ListTile(
          leading: Icon(
            Icons.policy,
            color: Colors.grey,
          ),
          title: getNormalText('Policy', Colors.black, 16),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.password,
            color: Colors.grey,
          ),
          title: getNormalText('Update Password', Colors.black, 16),
          onTap: () {
            pushNavigate(context, UpdatePassword());
          },
        ),
        // Divider(),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Colors.grey,
          ),
          title: getNormalText('Logout', Colors.black, 16),
          onTap: () {
            getAlertDialog(context, () async {
              Navigator.pop(context);
              var res = await getGetCall(logoutUrl);
              print(res.body);
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('USERTOKEN');
              // await prefs.remove('USERNAME');
              // await prefs.remove('PROFILESET');
              // await prefs.remove('USERADDRESS');
              // await prefs.remove('USERADDRESS');
              pushAndRemoveUntilNavigate(context, LoginScreen());
            }, 'Logout', 'Are you sure you want to logout?');
          },
        ),
        Divider(),
        Container(
          padding: EdgeInsets.all(20),
          child: getNormalText('Version: ${version}', Colors.grey, 14),
        )
      ],
    ),
  );
}

Color rgbToMaterialColor(int r, int g, int b) {
  return MaterialColor(
    0xFF000000 + (r << 16) + (g << 8) + b,
    <int, Color>{
      50: Color.fromRGBO(r, g, b, 0.1),
      100: Color.fromRGBO(r, g, b, 0.2),
      200: Color.fromRGBO(r, g, b, 0.3),
      300: Color.fromRGBO(r, g, b, 0.4),
      400: Color.fromRGBO(r, g, b, 0.5),
      500: Color.fromRGBO(r, g, b, 0.6),
      600: Color.fromRGBO(r, g, b, 0.7),
      700: Color.fromRGBO(r, g, b, 0.8),
      800: Color.fromRGBO(r, g, b, 0.9),
      900: Color.fromRGBO(r, g, b, 1),
    },
  );
}

String formatDateTimeWithTime(String datetime) {
  String a = '';
  return DateFormat('dd MMMM yyyy, KK:mm a').format(DateTime.parse(datetime));
}

class DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  DashedBorderPainter({required this.strokeWidth, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final dashWidth = 10;
    final dashSpace = 5;

    // Draw top line
    double distance = 0;
    while (distance < size.width) {
      canvas.drawLine(
        Offset(distance, 0),
        Offset(distance + dashWidth, 0),
        paint,
      );
      distance += dashWidth + dashSpace;
    }

    // Draw bottom line
    distance = 0;
    while (distance < size.width) {
      canvas.drawLine(
        Offset(distance, size.height),
        Offset(distance + dashWidth, size.height),
        paint,
      );
      distance += dashWidth + dashSpace;
    }

    // Draw left line
    distance = 0;
    while (distance < size.height) {
      canvas.drawLine(
        Offset(0, distance),
        Offset(0, distance + dashWidth),
        paint,
      );
      distance += dashWidth + dashSpace;
    }

    // Draw right line
    distance = 0;
    while (distance < size.height) {
      canvas.drawLine(
        Offset(size.width, distance),
        Offset(size.width, distance + dashWidth),
        paint,
      );
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

getLoadingNetworKImage(String url) {
  return Image.network(
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
    url,
  );
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
