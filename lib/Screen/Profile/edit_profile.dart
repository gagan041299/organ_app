import 'dart:convert';

import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/shared_pref.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class EditProfile extends StatefulWidget {
  final String name, email, address;
  const EditProfile(
      {super.key,
      required this.name,
      required this.address,
      required this.email});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
      print(getData);
      if (getData['status'] == 200) {
        await SharedPreferenceHelper().saveUserName(t1.text);

        await SharedPreferenceHelper().saveUserAddress(t3.text);
        await SharedPreferenceHelper()
            .saveUserMobile(getData['data']['contact_no'].toString());
        constUserName = t1.text;
        constUserMobile = getData['data']['contact_no'].toString();
        getSnackbar('Profile updated successfully', context);
        pushAndRemoveUntilNavigate(context, HomeScreen());
      } else {
        getSnackbar(getData['message'], context);
      }
    }
  }

  @override
  void initState() {
    t1.text = widget.name;
    t2.text = widget.email;
    t3.text = widget.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Edit Profile Information', context),
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
                          if (value!.isNotEmpty) {
                            if (!EmailValidator.validate(value)) {
                              return 'Enter a valid email address';
                            }
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
