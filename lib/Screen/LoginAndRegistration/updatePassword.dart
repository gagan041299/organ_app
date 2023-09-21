import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/customFormField.dart';
import 'package:orgone_app/helper/utils.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPassword2Controller = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        'current_password': oldPasswordController.text,
        'new_password': newPasswordController.text,
        'new_confirm_password': newPassword2Controller.text,
      };
      print(data);

      var res = await getPostCall(updatePassUrl, data);
      print(res.body);

      setState(() {
        isLoading = false;
      });
      print(res.body);
      var getData = json.decode(res.body);
      print(getData);
      getSnackbar(getData['message'], context);
      if (getData['status'] == 'success') {
        oldPasswordController.clear();
        newPasswordController.clear();
        oldPasswordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getButton('Update', MyColors.primaryColor, MyColors.secondaryColor,
                () {
              saveForm();
            }, getTotalWidth(context))
          ],
        ),
      ),
      appBar: AppBar(
        title: getBoldText('Update Password', Colors.white, 16),
      ),
      body: isLoading
          ? getLoading()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomFormFiled(
                        setter: (p0) {
                          setState(() {});
                        },
                        title: 'Current Password',
                        t: oldPasswordController),
                    CustomFormFiled(
                        setter: (p0) {
                          setState(() {});
                        },
                        title: ' New Password',
                        t: newPasswordController),
                    CustomFormFiled(
                        setter: (p0) {
                          setState(() {});
                        },
                        title: 'Re-Enter New Password',
                        t: newPassword2Controller),
                  ],
                ),
              ),
            ),
    );
  }
}
