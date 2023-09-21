import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Screen/LoginAndRegistration/login_screen.dart';
import 'package:orgone_app/Models/user_model.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/shared_pref.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Future<void> _firebaseMessagingBGHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBGHandler);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor primarySwatchColor = const MaterialColor(
      0xFF1383C3,
      <int, Color>{
        50: MyColors.primaryColor,
        100: MyColors.primaryColor,
        200: MyColors.primaryColor,
        300: MyColors.primaryColor,
        400: MyColors.primaryColor,
        500: MyColors.primaryColor,
        600: MyColors.primaryColor,
        700: MyColors.primaryColor,
        800: MyColors.primaryColor,
        900: MyColors.primaryColor,
      },
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: primarySwatchColor,
          appBarTheme: AppBarTheme(color: MyColors.primaryColor),
          dividerColor: MyColors.primaryColor),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  callApi() async {
    String? isProfileComplete;
    // pushAndRemoveUntilNavigate(context, LoginScreen());
    constToken = await SharedPreferenceHelper().getUserToken();

    if (constToken != null) {
      var response = await getGetCall(userDetailsUrl);
      log(response.body);
      var getData = json.decode(response.body);

      if (getData['status'] == 'success') {
        constperKmPrice = getData['data']['per_km_price'] == null
            ? 0
            : double.parse(getData['data']['per_km_price'].toString());
        constUserModel = UserModel.fromJson(getData['data']);
      } else {
        Future.delayed(Duration(seconds: 2)).then((value) {
          pushAndRemoveUntilNavigate(context, LoginScreen());
        });
      }
      Future.delayed(Duration(seconds: 2)).then((value) {
        pushAndRemoveUntilNavigate(context, HomeScreen());
      });
    } else {
      Future.delayed(Duration(seconds: 2)).then((value) {
        pushAndRemoveUntilNavigate(context, LoginScreen());
      });
    }
  }

  @override
  void initState() {
    callApi();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Image.asset('assets/images/logo.png'),
          )
        ],
      ),
    );
  }
}
