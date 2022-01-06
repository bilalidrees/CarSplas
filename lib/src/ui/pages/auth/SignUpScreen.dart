import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/FirebaseRef.dart';
import 'package:hiltonSample/src/ui/widgets/BackgroundImage.dart';
import 'package:hiltonSample/src/ui/widgets/CustomOverFlowWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTextField.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import '../../ui_constants/ImageAssetsResolver.dart';
import '../../../../AppLocalizations.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordHidden = true,
      isConfirmPasswordHidden = true,
      _isVisible = false,
      _disableTouch = false;
  File _image;
  String imageUrl;
  FirebaseUser user;
  final picker = ImagePicker();

  setPasswordStatus(bool isPassword) {
    setState(() {
      if (isPassword)
        isPasswordHidden = !isPasswordHidden;
      else
        isConfirmPasswordHidden = !isConfirmPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _disableTouch,
      child: Stack(
        children: [
          BackgroundImage(image: ImageAssetsResolver.APP_BG),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomOverFlowWidget(
              child: Column(
                children: [
                  SizedBox(
                    height: AppConfig.of(context).appWidth(13),
                  ),
                  Stack(
                    children: [
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
                                        radius:
                                            AppConfig.of(context).appWidth(4),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size:
                                              AppConfig.of(context).appWidth(5),
                                          color: Color(0xFF404040),
                                        ),
                                      ),
                                    ),
                                    radius: AppConfig.of(context).appWidth(12),
                                    backgroundImage: (_image == null)
                                        ? AssetImage(
                                            ImageAssetsResolver.APP_BG,
                                          )
                                        : FileImage(
                                            _image,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(5),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                            AppLocalizations.of(context)
                                .translate(Strings.USER_NAME),
                            TextInputType.text,
                            VALIDATION_TYPE.TEXT,
                            Icons.account_circle,
                            nameController,
                            false,
                            () {},
                            isAppColorEnable: false,
                            width: AppConfig.of(context).appWidth(80)),
                        SizedBox(height: AppConfig.of(context).appWidth(5)),
                        CustomTextField(
                            AppLocalizations.of(context)
                                .translate(Strings.EMAIL),
                            TextInputType.emailAddress,
                            VALIDATION_TYPE.EMAIL,
                            Icons.alternate_email,
                            emailController,
                            false,
                            () {},
                            isAppColorEnable: false,
                            width: AppConfig.of(context).appWidth(80)),
                        SizedBox(height: AppConfig.of(context).appWidth(5)),
                        CustomTextField(
                            AppLocalizations.of(context)
                                .translate(Strings.PH_NUMBER),
                            TextInputType.number,
                            VALIDATION_TYPE.TEXT,
                            Icons.wifi_calling_sharp,
                            phoneController,
                            false,
                            () {},
                            isAppColorEnable: false,
                            width: AppConfig.of(context).appWidth(80)),
                        SizedBox(height: AppConfig.of(context).appWidth(5)),
                        CustomTextField(
                            AppLocalizations.of(context)
                                .translate(Strings.PASSWORD),
                            TextInputType.visiblePassword,
                            VALIDATION_TYPE.PASSWORD,
                            Icons.lock,
                            passwordController,
                            isPasswordHidden, () {
                          setPasswordStatus(true);
                        },
                            isAppColorEnable: false,
                            width: AppConfig.of(context).appWidth(80)),
                        SizedBox(height: AppConfig.of(context).appWidth(5)),
                        CustomTextField(
                            AppLocalizations.of(context)
                                .translate(Strings.CONFIRM_PASSWORD),
                            TextInputType.visiblePassword,
                            VALIDATION_TYPE.PASSWORD,
                            Icons.lock,
                            confirmPasswordController,
                            isConfirmPasswordHidden, () {
                          setPasswordStatus(false);
                        },
                            isAppColorEnable: false,
                            width: AppConfig.of(context).appWidth(80)),
                        SizedBox(height: AppConfig.of(context).appWidth(10)),
                        Visibility(
                            visible: _isVisible,
                            child: Center(child: CircularProgressIndicator())),
                        if (_isVisible)
                          SizedBox(
                            height: AppConfig.of(context).appWidth(5),
                          ),
                        CustomButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isVisible = true;
                                _disableTouch = true;
                              });
                              try {
                                FirebaseUser user = (await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text))
                                    .user;
                                var _firebaseRef = FirebaseDatabase()
                                    .reference()
                                    .child(FirebaseRef.USERS);
                                _firebaseRef.child(user.uid).set({
                                  "name": nameController.text,
                                  "id": user.uid,
                                  "image": imageUrl,
                                  "email": emailController.text,
                                  "number": phoneController.text
                                }).then((value) {
                                  Toast.show("Registered Successfully", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                  Navigator.pop(context);
                                }, onError: (error) {
                                  Toast.show(error.toString(), context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                });
                              } catch (error) {
                                setState(() {
                                  _isVisible = false;
                                  _disableTouch = false;
                                });
                                Toast.show(error.message, context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                            }
                          },
                          radius: 10,
                          text: AppLocalizations.of(context)
                              .translate(Strings.REGISTER),
                          textColor: Colors.white,
                          backgorundColor: AppColors.of(context).mainColor(1),
                          width: AppConfig.of(context).appWidth(80),
                          isToShowEndingIcon: false,
                        ),
                        SizedBox(height: AppConfig.of(context).appWidth(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?  ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                      fontSize:
                                          AppConfig.of(context).appWidth(5)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                        color:
                                            AppColors.of(context).mainColor(1),
                                        fontSize:
                                            AppConfig.of(context).appWidth(5),
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppConfig.of(context).appWidth(10)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
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
}
