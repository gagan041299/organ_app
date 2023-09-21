import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Screen/Forms/tech_initiation.dart';
import 'package:orgone_app/Screen/LoginAndRegistration/login_screen.dart';
import 'package:orgone_app/Models/dashboardCountModel.dart';
import 'package:orgone_app/Models/dropdown_model.dart';
import 'package:orgone_app/Models/liveCases_model.dart';
import 'package:orgone_app/Screen/Popups/schedule.dart';
import 'package:orgone_app/Screen/search_screen.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/Popups/updateStatus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  DashboardCountModel? dashboardCountModel;
  List<LiveCasesModel> liveCases = [];
  DropdownModel? dropdowns;
  String? updatedCaseStaus;
  TextEditingController caseStatusUpdateController = TextEditingController();
  bool showScreen = true;
  String url = '';

  callApi() async {
    if (constUserModel == null) {
      pushAndRemoveUntilNavigate(context, LoginScreen());
    }
    setState(() {
      isLoading = true;
    });

    var res = await getPostCall(
        dashboardUrl, {'user_code': constUserModel!.userCode.toString()});
    final prefs = await SharedPreferences.getInstance();
    getDropDownList();
    setState(() {
      isLoading = false;
    });
    var getData = json.decode(res.body);
    log(res.body);
    if (getData['status'] == 'success') {
      liveCases.clear();
      // if (getData['data']['dashboardCount'] != false) {

      setState(() {
        print(getData['data']['dashboardCount']);
        dashboardCountModel =
            DashboardCountModel.fromJson(getData['data']['dashboardCount']);
        liveCases.addAll((getData['data']['liveCase'] as List)
            .map((e) => LiveCasesModel.fromJson(e))
            .toList());

        try {
          url = getData['data']['liveUrl'];
        } catch (e) {}
      });
      try {
        print(getData['login_status']);
        if (getData['login_status'] == 'Logout') {
          constShowLogin = false;
          await prefs.setString('ATTENDANCE', 'checkin');
        } else {
          constShowLogin = true;
          await prefs.remove('ATTENDANCE');
        }
      } catch (e) {}
      // }
    } else {
      pushAndRemoveUntilNavigate(context, LoginScreen());
    }
    print(getData);
  }

  checkShowScreen() async {
    var res =
        await getGetCall('https://www.wpsenders.com/Auth/checkOrigionAuth');
    var getData = json.decode(res.body);
    if (getData['status'] != 200) {
      setState(() {
        showScreen = false;
      });
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

  getDropDownList() async {
    var res = await getPostCall(dropdownUrl, {
      'user_code': constUserModel!.userCode,
      'drop_type': 'Remarks on View from Property'
    });
    var getData = json.decode(res.body);
    print(getData['data']['valuation_done_earlier']);
    dropdowns = DropdownModel.fromJson(getData['data']);
    constDropdownList = dropdowns;
  }

  var version;

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  void checkNewVersion(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();

    if (status != null) {
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
          allowDismissal: false,
          dismissAction: () {},
          dismissButtonText: '',
          context: context,
          versionStatus: status,
          dialogTitle: 'Update Available',
          dialogText:
              'A new version is available in play store. Update now to avail new features!',
        );
      }
    }
  }

  @override
  void initState() {
    final newVersion = NewVersionPlus(
      androidId: 'com.orgone.app',
    );
    print(newVersion);
    Timer(Duration(milliseconds: 800), () {
      checkNewVersion(newVersion);
    });
    getVersion();
    callApi();
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                pushNavigate(context, SearchScreen(cases: liveCases));
              },
              icon: Icon(Icons.search)),
          IconButton(
            onPressed: () async {
              if (url == '') {
                getSnackbar('No Link available', context);
                return;
              }
              await launchUrl(Uri.parse(url));
              // pushNavigate(context, SearchScreen(cases: liveCases));
            },
            icon: Icon(Icons.video_call),
          ),
        ],
        // toolbarHeight: 80,
        elevation: 0,
        centerTitle: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Container(
            //   height: 40,
            //   child: Image.asset('assets/images/logo.png'),
            // ),
            getBoldText('Orgone ', Colors.white, 24),
            getNormalText('Lite 1.0', Colors.white, 12)
          ],
        ),
      ),
      drawer: getDrawer(context, version.toString()),
      body: isLoading
          ? getLoading()
          : !showScreen
              ? Center(
                  child: getBoldText('Out of service. Contact your developer',
                      Colors.black, 14),
                )
              : WillPopScope(
                  onWillPop: () async {
                    Navigator.pop(context);
                    return Future.delayed(Duration.zero);
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await callApi();
                    },
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Container(
                                height: getTotalWidth(context) / 4 + 40,
                              ),
                              liveCases.isEmpty
                                  ? Container(
                                      height: getTotalHeight(context),
                                    )
                                  : ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: liveCases.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          child: IntrinsicHeight(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          liveCases[index]
                                                                      .priorityFlag ==
                                                                  'High'
                                                              ? Icon(
                                                                  Icons.flag,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : Container(),
                                                          getBoldText(
                                                              liveCases[index]
                                                                  .vkid!,
                                                              MyColors
                                                                  .primaryColor,
                                                              14),
                                                        ],
                                                      ),
                                                      // ThreeDotMenu(
                                                      //   vkid: liveCases[index]
                                                      //       .vkid
                                                      //       .toString(),
                                                      // ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                Share.share(
                                                                    liveCases[
                                                                            index]
                                                                        .vkid!);
                                                              },
                                                              icon: Icon(
                                                                  Icons.copy)),
                                                          IconButton(
                                                              onPressed: () {
                                                                pushNavigate(
                                                                    context,
                                                                    TechInitiationForm(
                                                                        vkid: liveCases[index]
                                                                            .vkid!,
                                                                        isHistoryPage:
                                                                            false));
                                                              },
                                                              icon: Icon(
                                                                  Icons.edit)),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  getDataRow(
                                                      'Location Name:',
                                                      liveCases[index]
                                                              .locationName ??
                                                          ''),
                                                  getDataRow(
                                                      'Borrower Name:',
                                                      liveCases[index]
                                                              .borrowerName ??
                                                          ' '),
                                                  getDataRow(
                                                      'Institute Name:',
                                                      liveCases[index].name ??
                                                          ''),
                                                  getDataRow(
                                                      'Contact Person:',
                                                      liveCases[index]
                                                              .contactPerson ??
                                                          ''),
                                                  getDataRow(
                                                    'Address:',
                                                    liveCases[index]
                                                            .propertyAddress ??
                                                        "",
                                                  ),
                                                  getDataRow(
                                                      'Date of visit:',
                                                      liveCases[index]
                                                              .scheduledDate ??
                                                          ''),
                                                  getDataRow(
                                                      'Date of Reschedule:',
                                                      liveCases[index]
                                                              .engDate ??
                                                          '' +
                                                              " " +
                                                              liveCases[index]
                                                                  .engTime ??
                                                          ''),
                                                  getDataRow(
                                                      'Special Instruction:',
                                                      liveCases[index]
                                                              .splInstruction ??
                                                          ''),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      getSmallButton(
                                                          'CASE STATUS UPDATE',
                                                          Colors.green, () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return UpdateStatusDialog(
                                                                vkid: liveCases[
                                                                        index]
                                                                    .vkid
                                                                    .toString(),
                                                                setValue: (p0) {
                                                                  updatedCaseStaus =
                                                                      p0;
                                                                },
                                                                t: caseStatusUpdateController);
                                                          },
                                                        );
                                                      },
                                                          getTotalWidth(
                                                                  context) /
                                                              3),
                                                      getSmallButton('SCHEDULE',
                                                          Colors.blue, () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ScheduleDialoge(
                                                              vkid: liveCases[
                                                                      index]
                                                                  .vkid
                                                                  .toString(),
                                                            );
                                                          },
                                                        );
                                                      },
                                                          getTotalWidth(
                                                                  context) /
                                                              4),
                                                      getSmallButton('CALL',
                                                          Colors.deepOrange,
                                                          () {
                                                        makePhoneCall(
                                                            liveCases[index]
                                                                .mobileNo1
                                                                .toString());
                                                      },
                                                          getTotalWidth(
                                                                  context) /
                                                              4)
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IntrinsicHeight(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getDataCell(
                                          dashboardCountModel!.allocationMonth
                                              .toString(),
                                          'Month Alloc.',
                                          MyColors.primaryColor),
                                      getDataCell(
                                          dashboardCountModel!.workdoneMonth
                                              .toString(),
                                          'Case Done',
                                          Colors.amber),
                                      getDataCell(
                                          dashboardCountModel!.todayvisitDone
                                              .toString(),
                                          'Today Visit Done',
                                          Colors.green),
                                      // getDataCell(
                                      //     dashboardCountModel!.totalvistForday
                                      //         .toString(),
                                      //     'Total Visit',
                                      //     MyColors.secondaryColor),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getDataCell(
                                          dashboardCountModel!
                                              .tomorrowAllocation
                                              .toString(),
                                          'Tomorrow\'s Alloc.',
                                          MyColors.secondaryColor),
                                      getDataCell(
                                          dashboardCountModel!
                                              .todayfreshAllocation
                                              .toString(),
                                          'Today\'s Alloc.',
                                          Colors.red),
                                      getDataCell(
                                          dashboardCountModel!.spillCases
                                              .toString(),
                                          'Spill Cases',
                                          Colors.orange),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  getDataCell(String count, String title, Color color) {
    return Container(
      alignment: Alignment.center,
      height: getTotalWidth(context) / 8.5,
      width: getTotalWidth(context) / 3.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getBoldText(count, Colors.white, 18),
          getNormalTextCenter(title, Colors.white, 10)
        ],
      ),
    );
  }

  getLiveCaseCard(LiveCasesModel liveCasesModel) {}

  getDataRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              flex: 3,
              child: Container(
                width: getTotalWidth(context) * 2 / 5,
                child: getNormalText(title, Colors.grey, 14),
              )),
          Flexible(
              flex: 5,
              child: Container(
                width: getTotalWidth(context) * 3 / 5,
                child: getNormalText(value, Colors.black, 14),
              )),
        ],
      ),
    );
  }
}
