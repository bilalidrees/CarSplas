import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiltonSample/src/bloc/utility/AppUtility.dart';
import 'package:hiltonSample/src/bloc/utility/FirebaseRef.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/model/Car.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/widgets/BackgroundImage.dart';
import 'package:hiltonSample/src/ui/widgets/RoundedButton.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTextField.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../../../../AppLocalizations.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';

class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  File _image;
  String imageUrl;
  final picker = ImagePicker();
  bool _isVisible = false, _disableTouch = false;
  String selectedCarCompany, selectedCarName, selectedCarCC, selectedCarType;
  final List<String> carCCList = [
    "Auto",
    "Manual",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AbsorbPointer(
          absorbing: _disableTouch,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  height: AppConfig.of(context).appHeight(40),
                  width: AppConfig.of(context).appHeight(60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      width: AppConfig.of(context).appWidth(30),
                      image: _image == null
                          ? AssetImage(
                              ImageAssetsResolver.CAR,
                            )
                          : FileImage(
                              _image,
                            ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.6,
                maxChildSize: 0.8,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.appScreenColor.withOpacity(0.9),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      //  controller: scrollController,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(
                                height: AppConfig.of(context).appWidth(10)),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                color: AppColors.dropDownItems.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: AppConfig.of(context).appWidth(80),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: AppConfig.of(context).appWidth(3),
                                  right: AppConfig.of(context).appWidth(3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        underline: Container(),
                                        dropdownColor: Colors.white,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                        iconSize:
                                            AppConfig.of(context).appWidth(6),
                                        isExpanded: true,
                                        hint: Text(
                                          "Select Car Company",
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: AppConfig.of(context)
                                                  .appWidth(4)),
                                        ),
                                        value: selectedCarCompany,
                                        style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: AppConfig.of(context)
                                                .appWidth(4)),
                                        onChanged: (String value) {
                                          selectedCarCompany = value;
                                          updateCarList();
                                        },
                                        items: AppUtility.companiesName
                                            .map((String name) {
                                          return DropdownMenuItem<String>(
                                            value: name,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: AppConfig.of(context).appWidth(5)),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                color: AppColors.dropDownItems.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: AppConfig.of(context).appWidth(80),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: AppConfig.of(context).appWidth(3),
                                  right: AppConfig.of(context).appWidth(3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        underline: Container(),
                                        dropdownColor: Colors.white,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                        iconSize:
                                            AppConfig.of(context).appWidth(6),
                                        isExpanded: true,
                                        hint: Text("Select Car Car",
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: AppConfig.of(context)
                                                    .appWidth(4))),
                                        value: selectedCarName,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: AppConfig.of(context)
                                                .appWidth(4)),
                                        onChanged: (String value) {
                                          selectedCarName = value;
                                          updateCarCC();
                                        },
                                        items: AppUtility.carsName
                                            .map((String name) {
                                          return DropdownMenuItem<String>(
                                            value: name,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: AppConfig.of(context).appWidth(5)),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                color: AppColors.dropDownItems.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: AppConfig.of(context).appWidth(80),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: AppConfig.of(context).appWidth(3),
                                  right: AppConfig.of(context).appWidth(3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        underline: Container(),
                                        dropdownColor: Colors.white,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                        iconSize:
                                            AppConfig.of(context).appWidth(6),
                                        isExpanded: true,
                                        hint: Text("Select Car CC",
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: AppConfig.of(context)
                                                    .appWidth(4))),
                                        value: selectedCarCC,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: AppConfig.of(context)
                                                .appWidth(4)),
                                        onChanged: (String Value) {
                                          setState(() {
                                            selectedCarCC = Value;
                                          });
                                        },
                                        items: AppUtility.carsCC
                                            .map((String name) {
                                          return DropdownMenuItem<String>(
                                            value: name,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: AppConfig.of(context).appWidth(5)),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                color: AppColors.dropDownItems.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: AppConfig.of(context).appWidth(80),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: AppConfig.of(context).appWidth(3),
                                  right: AppConfig.of(context).appWidth(3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        underline: Container(),
                                        dropdownColor: Colors.white,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                        iconSize:
                                            AppConfig.of(context).appWidth(6),
                                        isExpanded: true,
                                        hint: Text("Select Car Type",
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: AppConfig.of(context)
                                                    .appWidth(4))),
                                        value: selectedCarType,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: AppConfig.of(context)
                                                .appWidth(4)),
                                        onChanged: (String Value) {
                                          setState(() {
                                            selectedCarType = Value;
                                          });
                                        },
                                        items: carCCList.map((String name) {
                                          return DropdownMenuItem<String>(
                                            value: name,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height: AppConfig.of(context).appWidth(12)),
                            Visibility(
                                visible: _isVisible,
                                child:
                                    Center(child: CircularProgressIndicator())),
                            if (_isVisible)
                              SizedBox(
                                height: AppConfig.of(context).appWidth(5),
                              ),
                            CustomButton(
                              onPressed: () async {
                                setState(() {
                                  _isVisible = true;
                                  _disableTouch = true;
                                });
                                User user = await SharedPref.createInstance()
                                    .getCurrentUser();
                                var _firebaseRef = FirebaseDatabase()
                                    .reference()
                                    .child(FirebaseRef.USERS_CARS)
                                    .child(user.id);
                                var key = _firebaseRef.push().key;
                                _firebaseRef.child(key).set({
                                  "Id": key,
                                  "Image": imageUrl,
                                  "Company": selectedCarCompany,
                                  "Model": selectedCarName,
                                  "CC": selectedCarCC,
                                  "Type": selectedCarType,
                                }).then((value) {
                                  Toast.show("Car Added Successfully", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                  Navigator.pop(context);
                                }, onError: (error) {
                                  setState(() {
                                    _isVisible = false;
                                    _disableTouch = false;
                                  });
                                  Toast.show(error.toString(), context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                });
                              },
                              radius: 10,
                              text: AppLocalizations.of(context)
                                  .translate(Strings.ADD_CAR),
                              textColor: Colors.white,
                              backgorundColor:
                                  AppColors.of(context).mainColor(1),
                              width: AppConfig.of(context).appWidth(80),
                              isToShowEndingIcon: false,
                            ),
                            SizedBox(
                                height: AppConfig.of(context).appWidth(10)),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateCarList() async {
    AppUtility.carsName = await AppUtility.getCarsName(selectedCarCompany);
    AppUtility.carsName.sort((a, b) => a.compareTo(b));
    setState(() {});
  }

  void updateCarCC() async {
    AppUtility.carsCC =
        await AppUtility.getCarsCC(selectedCarCompany, selectedCarName);
    setState(() {});
  }

  Future getImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      //Upload to Firebase
      StorageUploadTask snapshot = await _firebaseStorage
          .ref()
          .child('CarImages/${DateTime.now().toString()}')
          .putFile(_image);
     // var downloadUrl = await snapshot.ref.getDownloadURL();
      var downloadUrl = await (await snapshot.onComplete).ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        print("$imageUrl");
      });
    } else {
      print('No image selected.');
    }
  }
}
