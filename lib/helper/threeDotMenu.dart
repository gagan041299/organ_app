import 'package:flutter/material.dart';
import 'package:orgone_app/Screen/Forms/caseStatus.dart';
import 'package:orgone_app/Screen/Forms/images.dart';
import 'package:orgone_app/Screen/Forms/mmSheets.dart';
import 'package:orgone_app/Screen/Forms/ndma.dart';
import 'package:orgone_app/Screen/Forms/physicalInspectionOne.dart';
import 'package:orgone_app/Screen/Forms/physicalInspectionTwo.dart';
import 'package:orgone_app/Screen/Forms/tech_initiation.dart';
import 'package:orgone_app/helper/utils.dart';

class ThreeDotMenu extends StatelessWidget {
  final bool isHistoryPage;
  final String vkid;
  const ThreeDotMenu(
      {super.key, required this.vkid, this.isHistoryPage = false});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        // Handle menu item selection
        if (value == 'Tech Initiation') {
          pushNavigate(context,
              TechInitiationForm(vkid: vkid, isHistoryPage: isHistoryPage));
        } else if (value == 'Images') {
          pushNavigate(
              context, ImagesForm(vkid: vkid, isHistoryPage: isHistoryPage));
        } else if (value == 'MM Sheets') {
          pushNavigate(
              context, MMSheetsForm(vkid: vkid, isHistoryPage: isHistoryPage));
        } else if (value == 'Physical Inspection-1') {
          pushNavigate(
              context,
              PhysicalInpectionOneForm(
                  vkid: vkid, isHistoryPage: isHistoryPage));
        } else if (value == 'Physical Inspection-2') {
          pushNavigate(
              context,
              PhysicalInpectionTwoForm(
                  vkid: vkid, isHistoryPage: isHistoryPage));
        } else if (value == 'NDMA') {
          pushNavigate(
              context, NDMAForm(vkid: vkid, isHistoryPage: isHistoryPage));
        } else if (value == 'Case Status') {
          pushNavigate(context,
              CaseStatusForm(vkid: vkid, isHistoryPage: isHistoryPage));
        }
      },
      itemBuilder: (BuildContext context) => const <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Tech Initiation',
          child: Text('Tech Initiation'),
        ),
        PopupMenuItem<String>(
          value: 'Images',
          child: Text('Images'),
        ),
        PopupMenuItem<String>(
          value: 'MM Sheets',
          child: Text('MM Sheets'),
        ),
        PopupMenuItem<String>(
          value: 'Physical Inspection-1',
          child: Text('Physical Inspection-1'),
        ),
        PopupMenuItem<String>(
          value: 'Physical Inspection-2',
          child: Text('Physical Inspection-2'),
        ),
        PopupMenuItem<String>(
          value: 'NDMA',
          child: Text('NDMA'),
        ),
        PopupMenuItem<String>(
          value: 'Case Status',
          child: Text('Case Status'),
        ),
      ],
      icon: Icon(isHistoryPage ? Icons.edit : Icons.more_vert),
    );
  }
}
