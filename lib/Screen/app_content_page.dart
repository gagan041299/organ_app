import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:orgone_app/api.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/utils.dart';

class AppContentPage extends StatefulWidget {
  final String num;
  final String title;
  const AppContentPage({super.key, required this.num, required this.title});

  @override
  State<AppContentPage> createState() => _AppContentPageState();
}

class _AppContentPageState extends State<AppContentPage> {
  bool isLoading = false;
  String? description;
  getProfileInfo() async {
    setState(() {
      isLoading = true;
    });

    var ress = await getGetCall(appContentUrl + '/${widget.num}');
    setState(() {
      isLoading = false;
    });
    var getData = json.decode(ress.body);

    description = getData['data']['description'];
  }

  @override
  void initState() {
    getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar(widget.title, context),
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              child: Html(
                data: description,
              ),
            ),
    );
  }
}
