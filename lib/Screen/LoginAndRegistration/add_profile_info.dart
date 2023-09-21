import 'dart:convert';

import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/helper/const.dart';

import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/shared_pref.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';
import 'package:orgone_app/Screen/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class AddProfileInfo extends StatefulWidget {
  const AddProfileInfo({super.key});

  @override
  State<AddProfileInfo> createState() => _AddProfileInfoState();
}

class _AddProfileInfoState extends State<AddProfileInfo> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  addProfileInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var res = await getPostCall(dashboardUrl,
          {'name': t1.text, 'email_id': t2.text, 'address': t3.text});
      setState(() {
        isLoading = false;
      });
      var getData = json.decode(res.body);
      if (getData['status'] == 200) {
        await SharedPreferenceHelper().saveProfileSet('1');
        await SharedPreferenceHelper().saveUserName(t1.text);

        await SharedPreferenceHelper().saveUserAddress(t3.text);
        await SharedPreferenceHelper()
            .saveUserMobile(getData['data']['contact_no'].toString());
        constUserName = t1.text;
        constUserMobile = getData['data']['contact_no'].toString();
        pushAndRemoveUntilNavigate(context, HomeScreen());
      } else {
        getSnackbar(getData['message'], context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Profile Information', context),
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        controller: t1,
                        decoration: InputDecoration(
                            hintText: 'Name*',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (!EmailValidator.validate(value!)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        controller: t2,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: t3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Address*',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      getButton('Submit to Orgone', MyColors.primaryColor,
                          MyColors.secondaryColor, () {
                        addProfileInfo();
                      }, MediaQuery.of(context).size.width),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: [
                          getNormalText('By Login/Sign up in, you agree to our',
                              Colors.black, 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: getBoldText('Terms of service',
                                    MyColors.primaryColor, 14),
                              ),
                              getNormalText(' and ', Colors.black, 14),
                              GestureDetector(
                                onTap: () {},
                                child: getBoldText('Privacy Policy',
                                    MyColors.primaryColor, 14),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
