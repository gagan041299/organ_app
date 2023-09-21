import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Screen/Forms/mmSheets.dart';
import 'package:orgone_app/Screen/Forms/tech_initiation.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class ImagesForm extends StatefulWidget {
  final bool isHistoryPage;
  final String vkid;
  const ImagesForm(
      {super.key, required this.vkid, required this.isHistoryPage});

  @override
  State<ImagesForm> createState() => _ImagesFormState();
}

class _ImagesFormState extends State<ImagesForm> {
  XFile? drawingfile, elevationFile, photographFile;
  final ImagePicker _picker = ImagePicker();
  LocationData? _locationData;
  // LatLng? markerPosition;
  bool _isLocation = false;
  // LatLng? latlng;
  bool isLoading = false;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<Map<String, dynamic>> photographsImagesList = [];
  List<TextEditingController> textEditingComntrollers = [];
  List<GlobalKey<FormState>> _formKeys = [];
  CameraPosition? _kGooglePlex;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  LatLng? _markerPosition;
  GlobalKey _mapKey = GlobalKey();

  Uint8List? _imageFile;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  String? serverDrawingImage;
  String? serverUploadImage;
  List<dynamic> serverPhotographs = [];
  DateTime? elevationImageDateTime;
  int loaderIndex = 0;
  int totalImageFileLength = 0;
  bool showCompressionLoader = false;

  //Create an instance of ScreenshotController
  // ScreenshotController screenshotController = ScreenshotController();

  Future selectImageGalleryDrawing() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    final XFile compressedPic = await compressImage(photo!);
    setState(() {
      drawingfile = XFile(compressedPic.path);
    });
  }

  Future selectImageCameraDrawing() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    final XFile compressedPic = await compressImage(photo!);
    setState(() {
      drawingfile = XFile(compressedPic.path);
    });
  }

  Future selectImageGalleryElevation() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    final XFile compressedPic = await compressImage(photo!);

    setState(() {
      elevationFile = XFile(compressedPic.path);
    });
  }

  Future selectImageCameraElevation() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    final XFile compressedPic = await compressImage(photo!);

    setState(() {
      elevationFile = XFile(compressedPic.path);
      elevationImageDateTime = DateTime.now();
    });
  }

  Future selectImageGalleryPhotograph() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    final XFile compressedPic = await compressImage(photo!);

    setState(() {
      photographFile = XFile(compressedPic.path);
    });
  }

  Future selectImageCameraPhotograph() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    final XFile compressedPic = await compressImage(photo!);

    setState(() {
      photographFile = XFile(compressedPic.path);
    });
  }

  void selectImages() async {
    loaderIndex = 0;
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        totalImageFileLength = selectedImages.length;
        isLoading = true;
        showCompressionLoader = true;
      });
      try {
        for (var element in selectedImages) {
          // imageFileList.add(element);

          final XFile compressedPic = await compressImage(element);
          imageFileList.add(compressedPic);
          setState(() {
            loaderIndex++;
          });
        }
      } catch (e) {
        print('unable to load image: ${e}');
      }
      setState(() {
        loaderIndex = 0;
        showCompressionLoader = false;
        isLoading = false;
      });
    }
    selectedImages.forEach(
      (element) async {
        print('hello');
        photographsImagesList.add({'image': element});
        textEditingComntrollers.add(TextEditingController());

        _formKeys.add(GlobalKey<FormState>());
      },
    );
    print("Image List Length:" + imageFileList.length.toString());
    setState(() {});
  }

  getInitialData() async {
    // setState(() {
    //   isLoading = true;
    // });
    var res = await getPostCall(caseDetailUrl, {'vkid': widget.vkid});
    // setState(() {
    //   isLoading = false;
    // });
    var getData = json.decode(res.body);
    serverDrawingImage = getData['drawingImage'] == null
        ? null
        : getData['drawingImage']['IMAGE_PATH'];
    serverUploadImage = getData['imagesElevation'] == null
        ? null
        : getData['imagesElevation']['IMAGE_PATH'];
    serverPhotographs = getData['multipleImage'];

    // if (getData['multipleImage'] != null ||
    //     getData['multipleImage'].isNotEmpty) {}
  }

  @override
  void initState() {
    // _getLocalImages();
    getImgData();
    getInitialData();
    callApi();

    super.initState();
  }

  getImgData() async {
    // var path = await getExternalStorageDirectories();
    // print(path);
    var path = await getExternalStorageDirectory();
    List<XFile> imgs =
        await getImagesFromFolder('${path!.path}/orgone/${widget.vkid}');
    print('this are images');
    print(imgs);

    if (imgs.isNotEmpty) {
      imageFileList.addAll(imgs);
      imgs.forEach((element) {
        _formKeys.add(GlobalKey<FormState>());
        textEditingComntrollers.add(TextEditingController());
      });
    }
  }

  Future<List<XFile>> getImagesFromFolder(String folderPath) async {
    print('running');
    Directory folder = Directory(folderPath);
    print(folder.path);
    if (!folder.existsSync()) {
      print('this');
      return [];
    }

    List<XFile> images = [];
    List<FileSystemEntity> entities =
        folder.listSync(recursive: true, followLinks: false);

    print(entities);
    for (FileSystemEntity entity in entities) {
      print('my my');
      if (entity is File &&
          (entity.path.toLowerCase().endsWith('.png') ||
              entity.path.toLowerCase().endsWith('.jpg') ||
              entity.path.toLowerCase().endsWith('.jpeg'))) {
        images.add(XFile(entity.path));
      }
    }

    return images;
  }

  callApi() async {
    setState(() {
      isLoading = true;
    });
    await getPermission();

    // if (_isLocation) {
    //   _kGooglePlex = CameraPosition(
    //     target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
    //     zoom: 18,
    //   );

    //   // latlng = LatLng(_locationData!.latitude!, _locationData!.longitude!);
    //   _markerPosition =
    //       LatLng(_locationData!.latitude!, _locationData!.longitude!);
    //   _markers.add(Marker(
    //     markerId: MarkerId('marker_id'),
    //     position: _markerPosition!,
    //     draggable: true,
    //     onDragEnd: (newPosition) {
    //       setState(() {
    //         _markerPosition = newPosition;
    //       });
    //     },
    //   ));
    //   setState(() {});
    // }
    setState(() {
      isLoading = false;
    });
  }

  getPermission() async {
    await Location.instance.hasPermission().then((value) async {
      print(value);
      if (value == PermissionStatus.granted ||
          value == PermissionStatus.grantedLimited) {
        await Location.instance.serviceEnabled().then((element) async {
          print(element);
          if (element == true) {
            setState(() {
              _isLocation = true;
            });
            _locationData = await Location.instance.getLocation();
          } else {
            await Location.instance.requestService();
          }
          _kGooglePlex = CameraPosition(
            target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
            zoom: 18,
          );

          // latlng = LatLng(_locationData!.latitude!, _locationData!.longitude!);
          _markerPosition =
              LatLng(_locationData!.latitude!, _locationData!.longitude!);
          _markers.add(Marker(
            markerId: MarkerId('marker_id'),
            position: _markerPosition!,
            draggable: true,
            onDragEnd: (newPosition) {
              setState(() {
                _markerPosition = newPosition;
              });
            },
          ));
          setState(() {});
        });
      } else {
        await Location.instance.requestPermission().then((value) {
          getPermission();
        });
      }
    });
  }

  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  saveForm() async {
    if (elevationFile == null && serverUploadImage == null) {
      getSnackbar('Elevation Image is required', context);
    }

    bool goToNextPage = true;
    // await getPermission();

    int index = 0;
    var uri = Uri.parse(multipleImageUploadUrl);
    var request = http.MultipartRequest(
      'POST',
      uri,
    );
    var singleImgUri = Uri.parse(singleImageUploadUrl);
    var singleImgReq1 = http.MultipartRequest(
      'POST',
      singleImgUri,
    );
    var singleImgReq2 = http.MultipartRequest(
      'POST',
      singleImgUri,
    );
    Map<String, String> headers = {'Authorization': 'Bearer ${constToken!}'};
    request.headers.addAll(headers);
    singleImgReq1.headers.addAll(headers);
    singleImgReq2.headers.addAll(headers);

    // for (var element in _formKeys) {
    //   if (element.currentState!.validate()) {
    //     continue;
    //   } else {
    //     return;
    //   }
    // }

    if (_isLocation) {
      if (drawingfile != null) {
        setState(() {
          isLoading = true;
        });
        var drawingImg =
            await http.MultipartFile.fromPath('image_file', drawingfile!.path);
        singleImgReq1.fields['cvid'] = widget.vkid;
        singleImgReq1.fields['user_code'] = constUserModel!.userCode!;
        singleImgReq1.fields['image_type'] = 'drawing';

        singleImgReq1.files.add(drawingImg);

        var singleImgRes = await singleImgReq1.send();

        setState(() {
          isLoading = false;
        });

        singleImgRes.stream.transform(utf8.decoder).listen((value) async {
          debugPrint(value);

          Map<String, dynamic> map = json.decode(value);

          if (map['status'] == 'success') {
            // Navigator.pop(context);
            // pushNavigate(
            //     context,
            //     ImagesForm(
            //         vkid: widget.vkid, isHistoryPage: widget.isHistoryPage));
            // getSnackbar(map['message'], context);
          } else {
            goToNextPage = false;
            getSnackbar('Something went wrong. Try again later', context);
          }
        });
      }

      // if (elevationFile != null) {
      //   setState(() {
      //     isLoading = true;
      //   });
      //   var elevationImg = await http.MultipartFile.fromPath(
      //       'image_file', elevationFile!.path);
      //   singleImgReq2.fields['cvid'] = widget.vkid;
      //   singleImgReq2.fields['user_code'] = constUserModel!.userCode!;
      //   singleImgReq2.fields['image_type'] = 'elevation';

      //   singleImgReq2.files.add(elevationImg);

      //   var singleImgRes2 = await singleImgReq2.send();

      //   setState(() {
      //     isLoading = false;
      //   });

      //   singleImgRes2.stream.transform(utf8.decoder).listen((value) async {
      //     debugPrint(value);

      //     Map<String, dynamic> map = json.decode(value);

      //     if (map['status'] == 'success') {
      //       // getSnackbar(map['message'], context);
      //     } else {
      //       goToNextPage = false;
      //       getSnackbar('Something went wrong. Try again later', context);
      //     }
      //   });
      // }

      if (imageFileList.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        int totalByte = 0;

        for (var element in imageFileList) {
          totalByte += await element.length();
          print(totalByte);
          int i = imageFileList.indexOf(element);
          request.fields['image_name_new[$index]'] =
              textEditingComntrollers[index].text;
          var drawingImg = await http.MultipartFile.fromPath(
              'image_path[$index]', imageFileList[i].path);
          // request.fields['sequence[$index]'] =
          //     textEditingComntrollers[index * 2 + 1].text;
          request.fields['latitude[$index]'] =
              _locationData!.latitude.toString();
          request.fields['longitude[$index]'] =
              _locationData!.longitude.toString();
          request.fields['cvid'] = widget.vkid;

          request.files.add(drawingImg);
          index++;
        }
        print(totalByte);
        var res = await request.send();
        setState(() {
          isLoading = false;
        });
        res.stream.transform(utf8.decoder).listen((value) async {
          debugPrint(value);

          Map<String, dynamic> map = json.decode(value);

          if (map['status'] == 'success') {
            imageFileList.forEach((element) async {
              try {
                File file = File(element.path);
                try {
                  if (await file.exists()) {
                    await file.delete();
                  }
                } catch (e) {
                  // Error in getting access to the file.
                }
                // await folder.delete();
              } catch (e) {
                print(e);
              }
            });
            // Navigator.pop(context);
            // pushNavigate(
            //     context,
            //     ImagesForm(
            //         vkid: widget.vkid, isHistoryPage: widget.isHistoryPage));
            getSnackbar(map['message'], context);
          } else {
            goToNextPage = false;
            getSnackbar('Something went wrong. Try again later', context);
          }
        });
      }
      if (goToNextPage) {
        pushNavigate(
            context,
            MMSheetsForm(
              vkid: widget.vkid,
              isHistoryPage: false,
            ));
      }
    }
  }

  saveElevationImage() async {
    if (elevationFile != null) {
      setState(() {
        isLoading = true;
      });
      var singleImgUri = Uri.parse(singleImageUploadUrl);
      var singleImgReq2 = http.MultipartRequest(
        'POST',
        singleImgUri,
      );
      Map<String, String> headers = {'Authorization': 'Bearer ${constToken!}'};

      singleImgReq2.headers.addAll(headers);
      var elevationImg =
          await http.MultipartFile.fromPath('image_file', elevationFile!.path);
      singleImgReq2.fields['cvid'] = widget.vkid;
      singleImgReq2.fields['user_code'] = constUserModel!.userCode!;
      singleImgReq2.fields['image_type'] = 'elevation';

      singleImgReq2.files.add(elevationImg);

      var singleImgRes2 = await singleImgReq2.send();

      setState(() {
        isLoading = false;
      });

      singleImgRes2.stream.transform(utf8.decoder).listen((value) async {
        debugPrint(value);

        Map<String, dynamic> map = json.decode(value);

        if (map['status'] == 'success') {
          getSnackbar(map['message'], context);
        } else {
          getSnackbar('Something went wrong. Try again later', context);
        }
      });
    }
  }

  uploadMap() async {
    var url = isHybrid
        ? 'https://maps.googleapis.com/maps/api/staticmap?center=${_markerPosition!.latitude},${_markerPosition!.longitude}&zoom=18&size=640x350&maptype=hybrid&scale=1&key=AIzaSyATU-azg9UpokrIggfQT0AETzVFLSBaq9c&markers=color:red|label:C|${_markerPosition!.latitude},${_markerPosition!.longitude}'
        : 'https://maps.googleapis.com/maps/api/staticmap?center=${_markerPosition!.latitude},${_markerPosition!.longitude}&zoom=18&size=640x350&maptype=normal&scale=1&key=AIzaSyATU-azg9UpokrIggfQT0AETzVFLSBaq9c&markers=color:red|label:C|${_markerPosition!.latitude},${_markerPosition!.longitude}';
    print(url);
    var data = {
      'latitude': _markerPosition!.latitude.toString(),
      'longitude': _markerPosition!.longitude.toString(),
      'lat': _markerPosition!.latitude.toString(),
      'lon': _markerPosition!.longitude.toString(),
      'img_src': url,
      'cvid': widget.vkid,
      'user_code': constUserModel!.userCode,
      'image_type': "google_map"
    };
    print(data);
    var res = await getPostCall(singleImageUploadUrl, {
      'latitude': _markerPosition!.latitude.toString(),
      'longitude': _markerPosition!.longitude.toString(),
      'lat': _markerPosition!.latitude.toString(),
      'lon': _markerPosition!.longitude.toString(),
      'img_src': url,
      'cvid': widget.vkid,
      'user_code': constUserModel!.userCode,
      'image_type': "google_map"
    });

    print(res.body);
    getSnackbar('Uploaded successfully', context);

    // var getData = json.decode(res.body);
  }

  bool isHybrid = true;

  Future<XFile> compressImage(XFile pickedFile) async {
    final file = File(pickedFile.path);
    final sizeInBytes = await file.length();
    int maxSize = 4 * 1024 * 1024;
    int quality = 60;

    if (sizeInBytes > maxSize) {
      quality = 50;
    }
    try {
      final targetPath = pickedFile.path.replaceAll('.jpg', '_compressed.jpg');
      final result = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
        quality: quality,
        // rotate: 90
      ).onError((error, stackTrace) {
        print(error);
      });
      print(result);

      if (result != null) {
        final s = await result.length();
        print(s);

        return XFile(result.path);
      } else {
        return pickedFile;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Compression Error"),
            content: Text("Error: $e"),
            actions: const [],
          );
        },
      );
      return pickedFile;
    }
  }

  Future<XFile> rotateImage(XFile pickedFile, int degree) async {
    final file = File(pickedFile.path);

    final targetPath = pickedFile.path.replaceAll('.jpg', '_rotated.jpg');
    final result = await FlutterImageCompress.compressAndGetFile(
            pickedFile.path, targetPath,
            quality: 100, rotate: degree)
        .onError((error, stackTrace) {
      print(error);
    });
    print(result);

    if (result != null) {
      return XFile(result.path);
    } else {
      return pickedFile;
    }
  }

  saveImageLocally() async {
    if (Platform.isAndroid) {
      var status = await ph.Permission.storage.status;
      if (status != ph.PermissionStatus.granted) {
        status = await ph.Permission.storage.request();
      }
      if (status.isGranted) {
        try {
          String vkid = widget.vkid;
          var path = await getExternalStorageDirectory();
          // var downloadsFolderPath = '/storage/emulated/0/Download/orgon/';

          try {
            Directory dir = await Directory(path!.path + '/orgone').create();
            print(dir.path);

            dir = await Directory(dir.path + '/$vkid').create();

            print(dir.path);
            imageFileList.forEach((element) {
              XFile? imgFile;
              imgFile = XFile('${dir.path}/${element.name}');
              element.saveTo(imgFile.path);
            });
          } catch (e) {
            print(e);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Saved '),
              duration: Duration(seconds: 3),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Download failed'),
              duration: Duration(seconds: 2),
            ),
          );
          print(e);
        }
      }
    }
  }

  Future<void> saveFilesToFolder(List<XFile> files, String folderName) async {
    Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir != null) {
      // Create the main folder
      String mainFolderPath = '${externalDir.path}/Downloads/orgone';
      Directory mainFolder = Directory(mainFolderPath);
      if (!mainFolder.existsSync()) {
        mainFolder.createSync(recursive: true);
      }

      // Create the subfolder using the widget.vkid
      String subFolderPath = '$mainFolderPath/${widget.vkid}';
      Directory subFolder = Directory(subFolderPath);
      if (!subFolder.existsSync()) {
        subFolder.createSync();
      }

      // Save each file in the subfolder
      for (XFile file in files) {
        String fileName = file.path.split('/').last;
        String filePath = '$subFolderPath/$fileName';
        File newFile = File(filePath);
        newFile.writeAsBytesSync(File(file.path).readAsBytesSync());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getBoldText('Images', Colors.white, 16),
        actions: [
          IconButton(
              onPressed: () {
                pushAndRemoveUntilNavigate(context, HomeScreen());
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
              )),
          ThreeDotMenu(
            isHistoryPage: widget.isHistoryPage,
            vkid: widget.vkid,
          ),
        ],
      ),
      bottomSheet: Container(
        height: 40,
        child: widget.isHistoryPage || showCompressionLoader
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getButton('Submit to Orgone', MyColors.primaryColor,
                      MyColors.secondaryColor, () {
                    saveForm();
                  }, getTotalWidth(context))
                ],
              ),
      ),
      body: isLoading
          ? showCompressionLoader
              ? getCompressionLoader()
              : getLoading()
          : WillPopScope(
              onWillPop: () async {
                pushReplacementNavigate(
                    context,
                    TechInitiationForm(
                        vkid: widget.vkid,
                        isHistoryPage: widget.isHistoryPage));
                return Future.delayed(Duration.zero);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          // color: Colors.red,
                          height: getTotalHeight(context) / 2,
                          child: _isLocation
                              ? GestureDetector(
                                  onPanUpdate: (details) {},
                                  child: GoogleMap(
                                      scrollGesturesEnabled: true,
                                      markers: _markers,
                                      mapType: isHybrid
                                          ? MapType.hybrid
                                          : MapType.normal,
                                      initialCameraPosition: _kGooglePlex!,
                                      onMapCreated: (GoogleMapController
                                          controller) async {
                                        _controller.complete(controller);
                                        // final uin8list = await controller
                                        //     .takeSnapshot(); // its our screenshot

                                        // // For examle, we can convert this uin8list to base64 and send
                                        // // to photohosting imgbb.com and get url on this image
                                        // final base64image = base64Encode(uin8list!);
                                      },
                                      onTap: (position) {
                                        setState(() {
                                          _markerPosition = position;
                                          _markers = {
                                            Marker(
                                              markerId: MarkerId('marker_id'),
                                              position: _markerPosition!,
                                              draggable: true,
                                              onDragEnd: (newPosition) {
                                                setState(() {
                                                  _markerPosition = newPosition;
                                                });
                                              },
                                            ),
                                          };
                                        });
                                      }),
                                )
                              : Center(
                                  child: getButton('Enable Location',
                                      Colors.blue, Colors.blue, () {
                                    getPermission();
                                  }, getTotalWidth(context) / 3),
                                )),

                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            // getNormalText(
                            //     _markerPosition == null
                            //         ? ''
                            //         : 'Latitude: ${_markerPosition!.latitude.toString()}',
                            //     Colors.black,
                            //     16),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // getNormalText(
                            //     _markerPosition == null
                            //         ? ''
                            //         : 'Longitude: ${_markerPosition!.longitude.toString()}',
                            //     Colors.black,
                            //     16),
                            _markerPosition == null
                                ? Container()
                                : Table(
                                    border: TableBorder.all(),
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: getBoldText(
                                              'Latitude', Colors.black, 16),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: getNormalText(
                                              '${_markerPosition!.latitude.toString()}',
                                              Colors.black,
                                              16),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: getBoldText(
                                              'Longitude', Colors.black, 16),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: getNormalText(
                                              '${_markerPosition!.longitude.toString()}',
                                              Colors.black,
                                              16),
                                        )
                                      ])
                                    ],
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                getSmallButton(
                                    'Capture Satellite View', Colors.green,
                                    () async {
                                  setState(() {
                                    isHybrid = true;
                                  });
                                  uploadMap();
                                  // RenderRepaintBoundary boundary =
                                  //     _mapKey.currentContext!.findRenderObject()
                                  //         as RenderRepaintBoundary;
                                  // ui.Image img = await boundary.toImage();
                                  // debugPrint(img.toString());
                                  // ByteData? byte = await img.toByteData(
                                  //     format: ui.ImageByteFormat.png);
                                  // debugPrint(byte.toString());
                                  // setState(() {
                                  //   _imageFile = byte!.buffer.asUint8List();
                                  // });
                                }, 120),
                                getSmallButton(
                                    'Capture Normal View', Colors.green,
                                    () async {
                                  setState(() {
                                    isHybrid = false;
                                  });
                                  uploadMap();
                                  // RenderRepaintBoundary boundary =
                                  //     _mapKey.currentContext!.findRenderObject()
                                  //         as RenderRepaintBoundary;
                                  // ui.Image img = await boundary.toImage();
                                  // debugPrint(img.toString());
                                  // ByteData? byte = await img.toByteData(
                                  //     format: ui.ImageByteFormat.png);
                                  // debugPrint(byte.toString());
                                  // setState(() {
                                  //   _imageFile = byte!.buffer.asUint8List();
                                  // });
                                }, 120)
                              ],
                            )
                          ],
                        ),
                      ),
                      _imageFile == null
                          ? Container()
                          : Container(
                              height: getTotalHeight(context) / 2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_imageFile!)),
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      // Container(
                      //   height: getTotalHeight(context) / 2,
                      //   child: FlutterMap(
                      //     mapController: _mapController,
                      //     options: MapOptions(
                      //       onTap: (tapPosition, point) async {
                      //         var poin = point;

                      //         setState(() {
                      //           markerPosition =
                      //               LatLng(poin.latitude, poin.longitude);
                      //           print(markerPosition!.latitude);
                      //         });
                      //       },
                      //       center: latlng,
                      //       zoom: 16,
                      //     ),
                      //     nonRotatedChildren: [
                      //       RichAttributionWidget(
                      //         attributions: [
                      //           TextSourceAttribution(
                      //             'OpenStreetMap contributors',
                      //             onTap: () => launchUrl(Uri.parse(
                      //                 'https://openstreetmap.org/copyright')),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //     children: [
                      //       TileLayer(
                      //         urlTemplate:
                      //             'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      //         userAgentPackageName: 'com.orgone.app',
                      //       ),
                      //       MarkerLayer(
                      //         markers: [
                      //           Marker(
                      //             point: markerPosition!,
                      //             width: 80,
                      //             height: 80,
                      //             builder: (context) => const Icon(
                      //               Icons.location_pin,
                      //               color: Colors.red,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getBoldText('Upload Drawing Image', Colors.black, 16),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.25, // Sets the height to 1/4 of the screen height
                            width: double
                                .infinity, // Sets the width to the full available width
                            child: CustomPaint(
                                painter: DashedBorderPainter(
                                  strokeWidth: 1,
                                  color: Colors.black,
                                ),
                                child: drawingfile == null
                                    ? serverDrawingImage == null
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              splashColor: Colors.white,
                                              onTap: () {
                                                showBottomSheeet(1);
                                              },
                                              child: Ink(
                                                  // alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  height: 40,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(0, 1),
                                                          blurRadius: 2)
                                                    ],
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: getBoldText(
                                                        'Choose Image',
                                                        Colors.white,
                                                        14),
                                                  )),
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25,
                                                  child: Image.network(
                                                      'https://api.orgone.solutions/orgon_api/api/uploads/drawing/${serverDrawingImage!}'
                                                      // fit: BoxFit.fill,
                                                      ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    splashColor: Colors.white,
                                                    onTap: () {
                                                      showBottomSheeet(1);
                                                    },
                                                    child: Ink(
                                                        // alignment: Alignment.center,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        height: 40,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                offset: Offset(
                                                                    0, 1),
                                                                blurRadius: 2)
                                                          ],
                                                          color: MyColors
                                                              .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        child: Center(
                                                          child: getBoldText(
                                                              'Replace',
                                                              Colors.white,
                                                              14),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                    : Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    XFile newImage =
                                                        await rotateImage(
                                                            drawingfile!, 90);
                                                    setState(() {
                                                      drawingfile = newImage;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.rotate_90_degrees_cw,
                                                    color:
                                                        MyColors.primaryColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.25,
                                                    child: Image.file(
                                                      File(drawingfile!.path),
                                                      // fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    XFile newImage =
                                                        await rotateImage(
                                                            drawingfile!, -90);
                                                    setState(() {
                                                      drawingfile = newImage;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.rotate_90_degrees_ccw,
                                                    color:
                                                        MyColors.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                splashColor: Colors.white,
                                                onTap: () {
                                                  showBottomSheeet(1);
                                                },
                                                child: Ink(
                                                    // alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 2)
                                                      ],
                                                      color:
                                                          MyColors.primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Center(
                                                      child: getBoldText(
                                                          'Replace',
                                                          Colors.white,
                                                          14),
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                splashColor: Colors.white,
                                                onTap: () {
                                                  setState(() {
                                                    drawingfile = null;
                                                  });
                                                },
                                                child: Ink(
                                                    // alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 2)
                                                      ],
                                                      color:
                                                          Colors.red.shade700,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Center(
                                                      child: getBoldText(
                                                          'Delete',
                                                          Colors.white,
                                                          14),
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      getBoldText('Upload Elevation Image*', Colors.black, 16),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height *
                            0.25, // Sets the height to 1/4 of the screen height
                        width: double
                            .infinity, // Sets the width to the full available width
                        child: CustomPaint(
                            painter: DashedBorderPainter(
                              strokeWidth: 1,
                              color: Colors.black,
                            ),
                            child: elevationFile == null
                                ? serverUploadImage == null
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            showBottomSheeet(2);
                                          },
                                          child: Ink(
                                              // alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              height: 40,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(0, 1),
                                                      blurRadius: 2)
                                                ],
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: getBoldText(
                                                    'Choose Image',
                                                    Colors.white,
                                                    14),
                                              )),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              child: Image.network(
                                                  'https://api.orgone.solutions/orgon_api/api/uploads/elevation/${serverUploadImage!}'
                                                  // fit: BoxFit.fill,
                                                  ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                splashColor: Colors.white,
                                                onTap: () {
                                                  showBottomSheeet(2);
                                                },
                                                child: Ink(
                                                    // alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 2)
                                                      ],
                                                      color:
                                                          MyColors.primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Center(
                                                      child: getBoldText(
                                                          'Replace',
                                                          Colors.white,
                                                          14),
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                : Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    XFile newImage =
                                                        await rotateImage(
                                                            elevationFile!, 90);
                                                    setState(() {
                                                      elevationFile = newImage;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.rotate_90_degrees_cw,
                                                    color:
                                                        MyColors.primaryColor,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.25,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.25 -
                                                      35,
                                                  child: Image.file(
                                                    File(elevationFile!.path),
                                                    // fit: BoxFit.fill,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    XFile newImage =
                                                        await rotateImage(
                                                            elevationFile!,
                                                            -90);
                                                    setState(() {
                                                      elevationFile = newImage;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.rotate_90_degrees_ccw,
                                                    color:
                                                        MyColors.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            getNormalText(
                                                formatDateTimeWithTime(
                                                    elevationImageDateTime
                                                        .toString()),
                                                Colors.black,
                                                12)
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.white,
                                            onTap: () {
                                              showBottomSheeet(2);
                                            },
                                            child: Ink(
                                                // alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                height: 40,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        offset: Offset(0, 1),
                                                        blurRadius: 2)
                                                  ],
                                                  color: MyColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Center(
                                                  child: getBoldText('Replace',
                                                      Colors.white, 14),
                                                )),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            splashColor: Colors.white,
                                            onTap: () {
                                              setState(() {
                                                elevationFile = null;
                                              });
                                            },
                                            child: Ink(
                                                // alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                height: 40,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        offset: Offset(0, 1),
                                                        blurRadius: 2)
                                                  ],
                                                  color: Colors.red.shade700,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Center(
                                                  child: getBoldText('Delete',
                                                      Colors.white, 14),
                                                )),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      elevationFile != null
                          ? Center(
                              child: getButton(
                                  'Save elevation image',
                                  MyColors.primaryColor,
                                  MyColors.secondaryColor, () {
                                saveElevationImage();
                              }, getTotalWidth(context) / 2),
                            )
                          : Container(),
                      SizedBox(
                        height: 15,
                      ),
                      getBoldText('Upload Photographs (Choose Multiple Image)',
                          Colors.black, 16),
                      SizedBox(
                        height: 15,
                      ),
                      serverPhotographs.isEmpty
                          ? Container()
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: serverPhotographs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: Image.network(
                                              'https://api.orgone.solutions/orgon_api/api/uploads/${widget.vkid}/${serverPhotographs[index]['IMAGE_PATH']}')),
                                      Flexible(
                                          flex: 1,
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                serverPhotographs[index][
                                                            'IMAGE_NAME_NEW'] ==
                                                        ''
                                                    ? Container()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          getBoldText('Name: ',
                                                              Colors.black, 16),
                                                          getNormalText(
                                                              '${serverPhotographs[index]['IMAGE_NAME_NEW']}',
                                                              Colors.black,
                                                              16),
                                                        ],
                                                      ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.center,
                                                //   children: [
                                                //     getBoldText('Sequence: ',
                                                //         Colors.black, 16),
                                                //     getNormalText(
                                                //         '${serverPhotographs[index]['SEQUENCE_IMG']}',
                                                //         Colors.black,
                                                //         16),
                                                //   ],
                                                // )
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                );
                              },
                            ),
                      imageFileList.isEmpty
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: imageFileList.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Image.file(
                                                      File(imageFileList[index]
                                                          .path),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        XFile newImage =
                                                            await rotateImage(
                                                                imageFileList[
                                                                    index],
                                                                -90);
                                                        setState(() {
                                                          imageFileList[index] =
                                                              newImage;
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .rotate_90_degrees_ccw,
                                                        color: MyColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  print(index);
                                                  try {
                                                    File file = File(
                                                        imageFileList[index]
                                                            .path);
                                                    try {
                                                      if (await file.exists()) {
                                                        await file.delete();
                                                      }
                                                    } catch (e) {
                                                      // Error in getting access to the file.
                                                    }
                                                    // await folder.delete();
                                                  } catch (e) {
                                                    print(e);
                                                  }

                                                  setState(() {
                                                    imageFileList
                                                        .removeAt(index);

                                                    // photographsImagesList
                                                    //     .removeAt(index);
                                                  });
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: Colors.red,
                                                  ),
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Form(
                                            key: _formKeys[index],
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'This Field is Required';
                                                    }
                                                  },
                                                  controller:
                                                      textEditingComntrollers[
                                                          (index)],
                                                  decoration: InputDecoration(
                                                      labelText: 'Name'),
                                                ),
                                                // TextFormField(
                                                //   validator: (value) {
                                                //     if (value!.isEmpty) {
                                                //       return 'This Field is Required';
                                                //     }
                                                //   },
                                                //   controller:
                                                //       textEditingComntrollers[
                                                //           (2 * index + 1)],
                                                //   keyboardType:
                                                //       TextInputType.number,
                                                //   decoration: InputDecoration(
                                                //       labelText: 'Sequence'),
                                                // )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                      Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            selectImages();
                            // showBottomSheeet(3);
                          },
                          child: Ink(
                              // alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 2,
                              height: 40,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 1),
                                      blurRadius: 2)
                                ],
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: getBoldText(
                                    'Choose Images (${imageFileList.length} selected)',
                                    Colors.white,
                                    14),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // imageFileList.isEmpty
                      //     ? Container()
                      //     :
                      Center(
                        child: getButton('Save Offline', MyColors.primaryColor,
                            MyColors.secondaryColor, () async {
                          saveImageLocally();
                          // await saveFilesToFolder(
                          // imageFileList, 'oregon/${widget.vkid}');
                        }, getTotalWidth(context) / 3),
                      ),

                      SizedBox(
                        height: 60,
                      ),
                      // Container(
                      //   decoration: BoxDecoration(border: Border.all()),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(15.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         GestureDetector(
                      //           onTap: () {
                      //             pushReplacementNavigate(
                      //                 context,
                      //                 TechInitiationForm(
                      //                   vkid: widget.vkid,
                      //                 ));
                      //           },
                      //           child: getNormalText(
                      //               '<< Previous Form', Colors.black, 16),
                      //         ),
                      //         getNormalText('|', Colors.black, 16),
                      //         GestureDetector(
                      //           onTap: () {
                      //             pushReplacementNavigate(
                      //                 context,
                      //                 MMSheetsForm(
                      //                   vkid: widget.vkid,
                      //                 ));
                      //           },
                      //           child: getNormalText(
                      //               'Next Form >>', Colors.black, 16),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  showBottomSheeet(int index) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((index == 1)) {
                        selectImageCameraDrawing();
                      } else if (index == 2) {
                        selectImageCameraElevation();
                      } else if (index == 3) {
                        selectImageCameraPhotograph();
                      }

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      height: 150,
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera,
                            size: 50,
                            color: MyColors.primaryColor,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          getBoldText('Take a photo', Colors.black, 16)
                        ],
                      ),
                    ),
                  ),
                  index == 2
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            if (index == 1) {
                              selectImageGalleryDrawing();
                            } else if (index == 2) {
                              selectImageGalleryElevation();
                            } else if (index == 3) {
                              selectImageGalleryPhotograph();
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)),
                            height: 150,
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_album,
                                  size: 50,
                                  color: MyColors.primaryColor,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                getBoldText(
                                    'Import from gallery', Colors.black, 16)
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getCompressionLoader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 50,
                animation: true,
                lineHeight: 10.0,
                animateFromLastPercent: true,
                // animationDuration: 2500,
                percent: loaderIndex / totalImageFileLength,
                // center: Text("80.0%"),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.green,
              ),
            ),
            getNormalText(
                '${loaderIndex}/${totalImageFileLength}', Colors.grey, 12)
          ],
        ),
      ),
    );
  }
}
