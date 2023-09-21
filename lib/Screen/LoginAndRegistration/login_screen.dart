import 'dart:convert';

import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Models/user_model.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/shared_pref.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:orgone_app/Screen/home_page.dart';
import 'package:orgone_app/Screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var response = await http.post(Uri.parse(loginUrl), body: {
        'user_code': t1.text,
        'password': t2.text,
      });
      setState(() {
        isLoading = false;
      });
      print(response.body);
      var getData = json.decode(response.body);

      if (getData['status'] == 'success') {
        constToken = getData['token'];
        await SharedPreferenceHelper().saveUserToken(constToken!);
        var responsee = await getGetCall(userDetailsUrl);
        var getDataa = json.decode(responsee.body);
        if (getDataa['status'] == 'success') {
          constUserModel = UserModel.fromJson(getDataa['data']);
        }
        pushAndRemoveUntilNavigate(context, HomeScreen());
      } else {
        getSnackbar(getData['message'], context);
      }
    }
  }

  bool isLoading = false;

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      // appBar: getLoginScreenAppBar('Login', context),
      body: isLoading
          ? getLoading()
          : Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          MyColors.primaryColor, // Starting gradient color
                          MyColors.secondaryColor, // Ending gradient color
                        ],
                      )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.height / 6,
                              height: MediaQuery.of(context).size.height / 7,
                              child: Image.asset('assets/images/logo.png')),
                          SizedBox(
                            height: 10,
                          ),
                          getBoldText('Login', Colors.white, 20)
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      height: 20,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              controller: t1,
                              validator: (value) {
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: 'User ID',
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(10)
                                //     )
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              obscureText: _passwordVisible,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              controller: t2,
                              validator: (value) {
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                hintText: 'Password',
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(10))
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      getButton('LOGIN', MyColors.primaryColor,
                          MyColors.secondaryColor, () {
                        login();
                      }, MediaQuery.of(context).size.width / 1.5),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
