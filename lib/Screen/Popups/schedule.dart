// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orgone_app/api.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/utils.dart';

class ScheduleDialoge extends StatefulWidget {
  final String vkid;

  const ScheduleDialoge({super.key, required this.vkid});
  @override
  State<ScheduleDialoge> createState() => _ScheduleDialogeState();
}

class _ScheduleDialogeState extends State<ScheduleDialoge> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  bool callMade = false;

  bool appointmentConfirmed = false;

  bool isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  reScheduleAppointment() async {
    setState(() {
      isLoading = true;
    });

    final data = {
      'eng_date': formatDateTimeMonth(selectedDate.toString()).toString(),
      'eng_time': selectedTime.format(context).toString(),
      'call_status': callMade ? 'Y' : 'N',
      'time_status': appointmentConfirmed ? 'Y' : 'N',
      'vkid': widget.vkid.toString()
    };
    var res = await getPostCall(rescheduleUrl, data);
    setState(() {
      isLoading = false;
    });
    print(res.body);
    var getData = json.decode(res.body);

    // Navigator.pop(context);
    getSnackbar(getData['message'], context);
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
                child:
                    getNormalText('Schedule Date and Time', Colors.white, 18)),
            content: Form(
              key: _formKey,
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              child: Image.asset('assets/images/calander.png')),
                          SizedBox(height: 8.0),
                          Text(
                            formatDateTimeMonth(selectedDate.toString()),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              height: 40,
                              width: 40,
                              child: Image.asset('assets/images/clock.png')),
                          SizedBox(height: 8.0),
                          Text(
                            selectedTime.format(context),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    CheckboxListTile(
                      title: Text('Call Made'),
                      value: callMade,
                      onChanged: (value) {
                        setState(() {
                          callMade = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Appointment Confirmed'),
                      value: appointmentConfirmed,
                      onChanged: (value) {
                        setState(() {
                          appointmentConfirmed = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              getSmallButton('UPDATE', MyColors.primaryColor, () {
                if (_formKey.currentState!.validate()) {
                  reScheduleAppointment();
                  // Form is valid, process the data
                  // Perform the necessary actions with the selectedDate, selectedTime, callMade, and appointmentConfirmed values
                }
              }, getTotalWidth(context) / 4),
              getSmallButton('CANCEL', Colors.red, () {
                Navigator.of(context).pop();
              }, getTotalWidth(context) / 4),
            ],
          );
  }
}
