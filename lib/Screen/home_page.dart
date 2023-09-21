// import 'dart:async';
// import 'package:orgone_app/Screen/Forms/reimburstment.dart';
// import 'package:orgone_app/Screen/Popups/attendance.dart';
// import 'package:orgone_app/Screen/Profile/profile_screen.dart';
// import 'package:orgone_app/helper/colors.dart';
// import 'package:flutter/material.dart';

// import 'home_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HomeScreen extends StatefulWidget {
//   final int intialPage;
//   const HomeScreen({Key? key, required this.intialPage}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomeScreen> {
//   int _page = 0;
//   onPageChanged(int page) {
//     setState(() {
//       _page = page;
//     });
//   }

//   List<Widget> pages = [
//     HomeScreen(),
//     AttendanceDialog(),
//     ReimburstmentForm(),
//     HomeScreen()
//   ];

//   // @override
//   // void initState() {
//   //   final newVersion = NewVersionPlus(
//   //     androidId: 'com.angc.app',
//   //   );
//   //   print(newVersion);
//   //   Timer(Duration(milliseconds: 800), () {
//   //     checkNewVersion(newVersion);
//   //   });
//   //   setState(() {
//   //     _page = widget.intialPage;
//   //   });

//   //   super.initState();
//   // }

//   // void checkNewVersion(NewVersionPlus newVersion) async {
//   //   final status = await newVersion.getVersionStatus();

//   //   if (status != null) {
//   //     if (status.canUpdate) {
//   //       newVersion.showUpdateDialog(
//   //         allowDismissal: false,
//   //         dismissAction: () {},
//   //         dismissButtonText: '',
//   //         context: context,
//   //         versionStatus: status,
//   //         dialogTitle: 'Update Available',
//   //         dialogText:
//   //             'A new version is available in play store. Update now to avail new features!',
//   //       );
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[_page],
//       bottomNavigationBar: BottomNavigationBar(
//         selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
//         selectedIconTheme:
//             IconThemeData(color: MyColors.primaryColor, size: 30),
//         backgroundColor: Colors.white,
//         selectedItemColor: MyColors.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: onPageChanged,
//         currentIndex: _page,
//         type: BottomNavigationBarType.fixed,
//         unselectedFontSize: 12,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.dashboard,
//             ),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.list_alt,
//             ),
//             label: 'Attendance',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.currency_rupee,
//             ),
//             label: 'Reimbustment',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.settings,
//             ),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
