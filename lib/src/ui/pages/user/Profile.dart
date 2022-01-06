import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/bloc/utility/FirebaseRef.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTextField.dart';
import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';
import '../../../../AppLocalizations.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import '../../../../route_generator.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  AuthenticationBloc authenticationBloc = AuthenticationBloc();
  bool _isVisible = false,
      isToShowLoginDialog = false,
      isPasswordHidden = true,
      isKeyBoardOpen = false,
      isLoading = true;
  ThemeBloc themeBloc;
  final _formKey = GlobalKey<FormState>();
  String genderId;
  List<String> gender = [
    "Male",
    "Female",
  ];
  DateTime _dateTime;
  File _image;
  String imageUrl;
  User user;
  final picker = ImagePicker();

  setVisiblity(bool visiblity) {
    setState(() {
      _isVisible = visiblity;
    });
  }

  setPasswordStatus() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  Future getImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child('UserImages/${DateTime.now().toString()}')
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

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    user = await SharedPref.createInstance().getCurrentUser();
    if (user != null) {
      emailController.text = user.email;
      nameController.text = user.name;
      phoneController.text = user.number;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: loginWithEmailWidget(context),
      ),
    );
  }

  Widget loginWithEmailWidget(BuildContext context) {
    final app = AppConfig(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            AppColors.of(context).mainColor(1),
            AppColors.of(context).secondColor(1)
          ])),
      child: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Container(
                  margin: EdgeInsets.all(AppConfig.of(context).appWidth(5)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: app.appWidth(2)),
                          Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                child: CircleAvatar(
                                  radius: AppConfig.of(context).appWidth(13),
                                  backgroundColor: Colors.white,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("tapped");
                                      getImage();
                                    },
                                    child: Container(
                                      child: CircleAvatar(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: AppConfig.of(context)
                                                .appWidth(4),
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: AppConfig.of(context)
                                                  .appWidth(5),
                                              color: Color(0xFF404040),
                                            ),
                                          ),
                                        ),
                                        radius:
                                            AppConfig.of(context).appWidth(12),
                                        backgroundImage: (_image == null &&
                                                user.image == null)
                                            ? AssetImage(
                                                ImageAssetsResolver.APP_ICON)
                                            : _image != null
                                                ? Image.file(
                                                    _image,
                                                    fit: BoxFit.cover,
                                                  ).image
                                                : NetworkImage(user.image),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(height: app.appWidth(5)),
                          Form(
                            key: _formKey,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: AppConfig.of(context).appWidth(5),
                                  right: AppConfig.of(context).appWidth(5)),
                              child: Column(
                                children: <Widget>[
                                  CustomTextField(
                                      AppLocalizations.of(context)
                                          .translate(Strings.USER_NAME),
                                      TextInputType.text,
                                      VALIDATION_TYPE.TEXT,
                                      Icons.account_circle,
                                      nameController,
                                      false,
                                      () {},
                                      isAppColorEnable: true,
                                      width:
                                          AppConfig.of(context).appWidth(80)),
                                  SizedBox(
                                      height:
                                          AppConfig.of(context).appWidth(5)),
                                  CustomTextField(
                                      AppLocalizations.of(context)
                                          .translate(Strings.EMAIL),
                                      TextInputType.emailAddress,
                                      VALIDATION_TYPE.EMAIL,
                                      Icons.alternate_email,
                                      emailController,
                                      false,
                                      () {},
                                      isAppColorEnable: true,
                                      width:
                                          AppConfig.of(context).appWidth(80)),
                                  SizedBox(
                                      height:
                                          AppConfig.of(context).appWidth(5)),
                                  CustomTextField(
                                      AppLocalizations.of(context)
                                          .translate(Strings.PH_NUMBER),
                                      TextInputType.number,
                                      VALIDATION_TYPE.TEXT,
                                      Icons.wifi_calling_sharp,
                                      phoneController,
                                      false,
                                      () {},
                                      isAppColorEnable: true,
                                      width:
                                          AppConfig.of(context).appWidth(80)),
                                  SizedBox(height: app.appWidth(3)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: app.appHeight(3)),
                          Container(
                            margin: EdgeInsets.only(
                                left: AppConfig.of(context).appWidth(5),
                                right: AppConfig.of(context).appWidth(5)),
                            child: CustomButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  var _firebaseRef = FirebaseDatabase()
                                      .reference()
                                      .child(FirebaseRef.USERS);
                                  _firebaseRef.child(user.id).set({
                                    "name": nameController.text,
                                    "id": user.id,
                                    "image": imageUrl,
                                    "email": emailController.text,
                                    "number": phoneController.text
                                  }).then((value) {
                                    SharedPref.createInstance().setCurrentUser(
                                        User(
                                            name: nameController.text,
                                            id: user.id,
                                            image: imageUrl,
                                            email: emailController.text,
                                            number: phoneController.text));
                                    Toast.show("updated Successfully", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                    Navigator.pop(context);
                                  }, onError: (error) {
                                    Toast.show(error.toString(), context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  });
                                }
                              },
                              radius: 10,
                              text: "Save",
                              textColor: Colors.white,
                              backgorundColor:
                                  AppColors.of(context).mainColor(1),
                              width: AppConfig.of(context).appWidth(84),
                              isToShowEndingIcon: false,
                            ),
                          ),
                          SizedBox(height: app.appHeight(3)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
//          top: AppConfig.of(context).appHeight(50),
//          right: AppConfig.of(context).appHeight(28),
            child: Visibility(
                visible: _isVisible,
                child: Center(child: CircularProgressIndicator())),
          ),
        ],
      ),
    );
  }

  Future<void> saveUser({User user}) async {
    await SharedPref.createInstance().setCurrentUser(user);
    Toast.show("Profile updated successfully", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
