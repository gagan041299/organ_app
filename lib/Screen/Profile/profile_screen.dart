import 'dart:convert';

import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Screen/LoginAndRegistration/login_screen.dart';
import 'package:orgone_app/Screen/Profile/edit_profile.dart';
import 'package:orgone_app/Screen/app_content_page.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name, emailId, contactNo, address;
  bool isLoading = false;
  getProfileInfo() async {
    setState(() {
      isLoading = true;
    });
    var res = await getGetCall(dashboardUrl);
    var getData = json.decode(res.body);
    var ress = await getGetCall(dashboardUrl);
    var getDataa = json.decode(ress.body);
    print(ress.body);
    name = getData['data']['name'];
    emailId = getData['data']['email_id'];
    contactNo = getData['data']['contact_no'].toString();
    address = getData['data']['address'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Profile', context),
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: Image.asset(
                                      'assets/images/collection.png')),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                  // width: MediaQuery.of(context).size.width / 4,
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getBoldText(
                                      'Today\'s Collection', Colors.black, 14),
                                  getNormalText('₹ 80', Colors.black, 20)
                                ],
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white30,
                                  ),
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: MediaQuery.of(context).size.width / 4,
                                  // child: Icon(
                                  //   Icons.person,
                                  //   size: 70,
                                  //   color: Colors.red,
                                  // ),
                                  child: Image.asset('assets/images/logo.png'),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                IntrinsicHeight(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: [
                                      //     GestureDetector(
                                      //       onTap: () {
                                      //         pushNavigate(
                                      //             context,
                                      //             EditProfile(
                                      //                 name: name!,
                                      //                 address: address!,
                                      //                 email: emailId!));
                                      //       },
                                      //       child: Icon(
                                      //         Icons.edit,
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      getBoldText(name!, Colors.black, 18),
                                      getNormalText(
                                          contactNo!, Colors.black, 12),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     getBoldText('NAME', MyColors.primaryColor, 14),
                                      //     getNormalText(name!, Colors.black, 15)
                                      //   ],
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     getBoldText('PHOME', MyColors.primaryColor, 14),
                                      //     getNormalText(contactNo!, Colors.black, 15)
                                      //   ],
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     getBoldText(
                                      //         'ADDRESS', MyColors.primaryColor, 14),
                                      //     getNormalText(address!, Colors.black, 15)
                                      //   ],
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     getBoldText('EMAIL', MyColors.primaryColor, 14),
                                      //     getNormalText(emailId ?? '', Colors.black, 15)
                                      //   ],
                                      // ),
                                      Divider(),
                                      // getButton('LOGOUT', Colors.blue, () {},
                                      //     MediaQuery.of(context).size.width / 2)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                pushNavigate(
                                    context,
                                    EditProfile(
                                        name: name!,
                                        address: address!,
                                        email: emailId!));
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.home,
                              color: MyColors.primaryColor,
                            ),
                            title: getNormalText('Home', Colors.black, 16),
                            onTap: () {
                              pushAndRemoveUntilNavigate(context, HomeScreen());
                            },
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.format_align_center,
                              color: MyColors.primaryColor,
                            ),
                            title: getNormalText('About us', Colors.black, 16),
                            onTap: () {
                              pushNavigate(context,
                                  AppContentPage(num: '4', title: 'About Us'));
                            },
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.phone,
                              color: MyColors.primaryColor,
                            ),
                            title:
                                getNormalText('Contact us', Colors.black, 16),
                            onTap: () {
                              pushNavigate(
                                  context,
                                  AppContentPage(
                                      num: '3', title: 'Contact Us'));
                            },
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.copy,
                              color: MyColors.primaryColor,
                            ),
                            title: getNormalText(
                                'Terms & Conditions', Colors.black, 16),
                            onTap: () {
                              pushNavigate(
                                  context,
                                  AppContentPage(
                                      num: '2', title: 'Terms & Conditions'));
                            },
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.policy,
                              color: MyColors.primaryColor,
                            ),
                            title: getNormalText('Policy', Colors.black, 16),
                            onTap: () {
                              pushNavigate(context,
                                  AppContentPage(num: '1', title: 'Policy'));
                            },
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.logout,
                              color: MyColors.primaryColor,
                            ),
                            title: getNormalText('Logout', Colors.black, 16),
                            onTap: () {
                              getAlertDialog(context, () async {
                                Navigator.pop(context);
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('USERTOKEN');
                                await prefs.remove('USERNAME');
                                await prefs.remove('PROFILESET');
                                await prefs.remove('USERADDRESS');
                                await prefs.remove('USERADDRESS');
                                pushAndRemoveUntilNavigate(
                                    context, LoginScreen());
                              }, 'Logout', 'Are you sure you want to logout?');
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
