import 'package:flutter/material.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/dropdown_button.dart';
import 'package:orgone_app/helper/utils.dart';

class AddMMSheetDialog extends StatefulWidget {
  final String type;
  final Function(Map<String, dynamic>) function;
  const AddMMSheetDialog(
      {super.key, required this.function, required this.type});

  @override
  State<AddMMSheetDialog> createState() => _AddMMSheetDialogState();
}

class _AddMMSheetDialogState extends State<AddMMSheetDialog> {
  var _formKey = GlobalKey<FormState>();
  var residential = {
    "Carpet Area": [
      "Dining area",
      "Cupboard",
      "Bedroom",
      "Hall",
      "Kitchen",
      "Passage",
      "Toilet",
      "Bathroom",
      "W.C.",
      "Temple Room",
      "Study Room",
      "Store",
      "Servent Room",
      "Servent Toilet",
      "Internal Stairs",
      "Lobby",
      "Foyer Area"
    ],
    "Balcony": [
      "Balcony",
      "Pkt. Terrace < 50 sqft",
      "Enc. Balcony",
      "Flower Bed",
      "Dry Balcony",
      "Verandah",
      "Back Yard"
    ],
    "Other Area": [
      "Parking/Stilt Area",
      "Op Area Considered For Valuation (A)en Area",
      "Garden",
      "Niche",
      "Service Slab",
      "Ele. Projection",
      "Common Area",
      "Loft",
      "Mezzanine",
      "Shed",
      "RCC Shed",
      "Tin Shed",
      "Duct"
    ],
    "Refuge Area": ["Refuge Area"],
    "Terrace Area": ["Terrace Area"]
  };

  var commercial = {
    "Carpet Area": [
      "Dining area",
      "Workstation Hall",
      "Working Area",
      "Pantry",
      "Office Area",
      "Cabin",
      "Confrence",
      "Reception",
      "Lobby",
      "Foyer Area",
      "Internal Stairs",
      "Server Room",
      "Toilet",
      "Store",
      "Passage"
    ],
    "Balcony": [
      "Pkt. Terrace < 50 sqft",
      "Mezanine",
      "Otla",
      "A.C Room",
      "Balcony",
      "Enc. Balcony"
    ],
    "Other Area": [
      "Open Area",
      "Garden",
      "Niche",
      "Service Slab",
      "Ele. Projection",
      "Common Area",
      "Fire passage",
      "AHU Area",
      "Loft",
      "Dry Balcony",
      "Shed",
      "RCC Shed",
      "Tin Shed",
      "Basement"
    ],
    "Refuge Area": ["Refuge Area"],
    "Terrace Area": ["Terrace Area"]
  };
  var residential_commercial = {
    "Carpet Area": [
      "Dining area",
      "Cupboard",
      "Bedroom",
      "Hall",
      "Kitchen",
      "Passage",
      "Toilet",
      "Bathroom",
      "W.C.",
      "Temple Room",
      "Study Room",
      "Store",
      "Servent Room",
      "Servent Toilet",
      "Internal Stairs",
      "Living Room",
      "Lobby",
      "Dining Area",
      "Foyer Area",
      "Workstation Hall",
      "Working Area",
      "Pantry",
      "Office Area",
      "Cabin",
      "Confrence",
      "Reception",
      "Server Room",
      "Store"
    ],
    "Balcony": [
      "Balcony",
      "Enc. Balcony",
      "Flower Bed",
      "Dry Balcony",
      "Verandah",
      "Back Yard",
      "Pkt. Terrace < 50 sqft",
      "Mezanine",
      "Otla",
      "A.C Room"
    ],
    "Other Area": [
      "Parking/Stilt Area",
      "Op Area Considered For Valuation (A)en Area",
      "Mezzanine",
      "Shed",
      "RCC Shed",
      "Tin Shed",
      "Open Area",
      "Garden",
      "Niche",
      "Service Slab",
      "Ele. Projection",
      "Common Area",
      "Fire passage",
      "AHU Area",
      "Loft",
      "Dry Balcony",
      "Shed",
      "RCC Shed",
      "Tin Shed",
      "Duct",
      "Basement"
    ],
    "Refuge Area": ["Refuge Area"],
    "Terrace Area": ["Terrace Area"]
  };
  Map<String, List<String>> localList = {};
  late List<String> nameList = [];
  TextEditingController groupHeadController = TextEditingController();
  TextEditingController sequenceController = TextEditingController();

  TextEditingController lengthController = TextEditingController();

  TextEditingController widthController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  String? selectedName;

  @override
  void initState() {
    setList();

    super.initState();
  }

  setList() {
    setState(() {
      widget.type == 'Residential'
          ? localList.addAll(residential)
          : widget.type == 'Commercial'
              ? localList.addAll(commercial)
              : localList.addAll(residential_commercial);
      localList.values.forEach((valueList) {
        print(valueList);
        nameList.addAll(valueList);
      });
    });
    print(nameList);
  }

  checkGroupHead(String t) {
    localList.forEach((key, value) {
      if (value.contains(t)) {
        setState(() {
          groupHeadController.text = key;
        });
      }
    });
  }

  calculateArea() {
    if (lengthController.text.isNotEmpty && widthController.text.isNotEmpty) {
      areaController.text = (double.parse(lengthController.text) *
              double.parse(widthController.text))
          .toString();
    }
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
              CustomDropdownButton(
                  hint: 'Select Area',
                  value: selectedName,
                  itemList: nameList,
                  onChanged: ((val) {
                    selectedName = val;
                    checkGroupHead(val!);
                  })),
              TextField(
                readOnly: true,
                controller: groupHeadController,
                decoration: InputDecoration(
                  hintText: 'Group Head',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'this field is required';
                  }
                },
                keyboardType: TextInputType.number,
                controller: sequenceController,
                decoration: InputDecoration(
                  hintText: 'Sequence',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'this field is required';
                  }
                },
                keyboardType: TextInputType.number,
                controller: lengthController,
                decoration: InputDecoration(
                  hintText: 'Length',
                ),
                onChanged: (value) {
                  calculateArea();
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'this field is required';
                  }
                },
                keyboardType: TextInputType.number,
                controller: widthController,
                decoration: InputDecoration(
                  hintText: 'Width',
                ),
                onChanged: (value) {
                  calculateArea();
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                readOnly: true,
                controller: areaController,
                decoration: InputDecoration(
                  hintText: 'Area',
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
          if (_formKey.currentState!.validate()) {
            if (selectedName == null) {
              getSnackbar('Name is requires', context);
            }
            widget.function({
              'group_head': groupHeadController.text,
              'name': selectedName,
              'sequence': sequenceController.text,
              'length': lengthController.text,
              'width': widthController.text,
              'area': areaController.text,
            });
            Navigator.of(context).pop();
          }
        }, getTotalWidth(context) / 4),
      ],
    );
  }
}
