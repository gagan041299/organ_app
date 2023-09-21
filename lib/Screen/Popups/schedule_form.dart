// import 'package:flutter/material.dart';

// class MyForm extends StatefulWidget {
//   @override
//   _MyFormState createState() => _MyFormState();
// }

// class _MyFormState extends State<MyForm> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   bool callMade = false;
//   bool appointmentConfirmed = false;

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//         selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (pickedTime != null && pickedTime != selectedTime) {
//       setState(() {
//         selectedTime = pickedTime;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IntrinsicHeight(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: IntrinsicHeight(
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => _selectDate(context),
//                     child: Text('Select Date'),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Selected Date: ${selectedDate ?? 'Not selected'}',
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: () => _selectTime(context),
//                     child: Text('Select Time'),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Selected Time: ${selectedTime?.format(context) ?? 'Not selected'}',
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                   SizedBox(height: 16.0),
//                   CheckboxListTile(
//                     title: Text('Call Made'),
//                     value: callMade,
//                     onChanged: (value) {
//                       setState(() {
//                         callMade = value ?? false;
//                       });
//                     },
//                     controlAffinity: ListTileControlAffinity.leading,
//                   ),
//                   CheckboxListTile(
//                     title: Text('Appointment Confirmed'),
//                     value: appointmentConfirmed,
//                     onChanged: (value) {
//                       setState(() {
//                         appointmentConfirmed = value ?? false;
//                       });
//                     },
//                     controlAffinity: ListTileControlAffinity.leading,
//                   ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {}
//                     },
//                     child: Text('Submit'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
