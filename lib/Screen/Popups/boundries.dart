import 'package:flutter/material.dart';

import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/dropdown_button.dart';
import 'package:orgone_app/helper/utils.dart';

class AddBoundries extends StatefulWidget {
  final TextEditingController eastBoundriesAsPerSiteController;
  final TextEditingController eastBoundriesAsPerDeedController;
  final TextEditingController eastDimensionAsPerSiteController;
  final TextEditingController eastDimensionAsPerDeedController;
  final TextEditingController eastMOSAsPerSiteController;
  final TextEditingController eastMOSAsPerDeedController;
  final TextEditingController westBoundriesAsPerSiteController;
  final TextEditingController westBoundriesAsPerDeedController;
  final TextEditingController westDimensionAsPerSiteController;
  final TextEditingController westDimensionAsPerDeedController;
  final TextEditingController westMOSAsPerSiteController;
  final TextEditingController westMOSAsPerDeedController;
  final TextEditingController northBoundriesAsPerSiteController;
  final TextEditingController northBoundriesAsPerDeedController;
  final TextEditingController northDimensionAsPerSiteController;
  final TextEditingController northDimensionAsPerDeedController;
  final TextEditingController northMOSAsPerSiteController;
  final TextEditingController northMOSAsPerDeedController;
  final TextEditingController southBoundriesAsPerSiteController;
  final TextEditingController southBoundriesAsPerDeedController;
  final TextEditingController southDimensionAsPerSiteController;
  final TextEditingController southDimensionAsPerDeedController;
  final TextEditingController southMOSAsPerSiteController;
  final TextEditingController southMOSAsPerDeedController;

  const AddBoundries({
    Key? key,
    required this.eastBoundriesAsPerSiteController,
    required this.eastBoundriesAsPerDeedController,
    required this.eastDimensionAsPerSiteController,
    required this.eastDimensionAsPerDeedController,
    required this.eastMOSAsPerSiteController,
    required this.eastMOSAsPerDeedController,
    required this.westBoundriesAsPerSiteController,
    required this.westBoundriesAsPerDeedController,
    required this.westDimensionAsPerSiteController,
    required this.westDimensionAsPerDeedController,
    required this.westMOSAsPerSiteController,
    required this.westMOSAsPerDeedController,
    required this.northBoundriesAsPerSiteController,
    required this.northBoundriesAsPerDeedController,
    required this.northDimensionAsPerSiteController,
    required this.northDimensionAsPerDeedController,
    required this.northMOSAsPerSiteController,
    required this.northMOSAsPerDeedController,
    required this.southBoundriesAsPerSiteController,
    required this.southBoundriesAsPerDeedController,
    required this.southDimensionAsPerSiteController,
    required this.southDimensionAsPerDeedController,
    required this.southMOSAsPerSiteController,
    required this.southMOSAsPerDeedController,
  }) : super(key: key);

  @override
  State<AddBoundries> createState() => _AddBoundriesState();
}

class _AddBoundriesState extends State<AddBoundries> {
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          child: getNormalText('ADD FIELD', Colors.white, 18)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getBoldText('EAST', Colors.black, 16),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.eastBoundriesAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'Boundries(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.eastBoundriesAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'Boundries(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.eastDimensionAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'Dimension(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.eastDimensionAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'Dimension(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.eastMOSAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'MOS(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.eastMOSAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'MOS(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // west
              getBoldText('WEST', Colors.black, 16),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.westBoundriesAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'Boundries(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.westBoundriesAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'Boundries(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.westDimensionAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'Dimension(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.westDimensionAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'Dimension(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.westMOSAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'MOS(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.westMOSAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'MOS(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //
              getBoldText('NORTH', Colors.black, 16),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.northBoundriesAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'Boundries(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.northBoundriesAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'Boundries(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.northDimensionAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'Dimension(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.northDimensionAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'Dimension(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.northMOSAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'MOS(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.northMOSAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'MOS(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //
              getBoldText('SOUTH', Colors.black, 16),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.southBoundriesAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'Boundries(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.southBoundriesAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'Boundries(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.southDimensionAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'Dimension(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.southDimensionAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'Dimension(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.southMOSAsPerSiteController,
                decoration: InputDecoration(
                  hintText: 'MOS(As per site)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: widget.southMOSAsPerDeedController,
                decoration: InputDecoration(
                  hintText: 'MOS(As per deed)',
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      actions: [
        getSmallButton('ADD', MyColors.primaryColor, () {
          // if (_formKey.currentState!.validate()) {
          Navigator.of(context).pop();
          // }
        }, getTotalWidth(context) / 4),
      ],
    );
  }
}
