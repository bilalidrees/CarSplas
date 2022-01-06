import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/FirebaseRef.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/model/User.dart' as AppUser;
import 'package:hiltonSample/src/ui/widgets/BackgroundImage.dart';
import 'package:hiltonSample/src/ui/widgets/CustomOverFlowWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTextField.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTitleWidget.dart';
import 'package:toast/toast.dart';
import '../../../../route_generator.dart';
import '../../../../AppLocalizations.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import '../../ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isToShowLoginDialog = false,
      isPasswordHidden = true,
      _isVisible = false,
      _disableTouch = false;
  final _formKey = GlobalKey<FormState>();

  setPasswordStatus() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _disableTouch,
      child: Stack(
        children: [
          BackgroundImage(
            image: ImageAssetsResolver.APP_BG,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomOverFlowWidget(
              child: Column(
                children: [
                  Flexible(
                    child: Container(
                      child: Center(
                        child: Text(
                          'CarSplash',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextField(
                                AppLocalizations.of(context)
                                    .translate(Strings.EMAIL),
                                TextInputType.text,
                                VALIDATION_TYPE.TEXT,
                                Icons.account_circle,
                                emailController,
                                false,
                                () {},
                                isAppColorEnable: false,
                                width: AppConfig.of(context).appWidth(80)),
                            SizedBox(
                              height: AppConfig.of(context).appWidth(5),
                            ),
                            CustomTextField(
                                AppLocalizations.of(context)
                                    .translate(Strings.PASSWORD),
                                TextInputType.visiblePassword,
                                VALIDATION_TYPE.PASSWORD,
                                Icons.lock,
                                passwordController,
                                isPasswordHidden, () {
                              setPasswordStatus();
                            },
                                isAppColorEnable: false,
                                width: AppConfig.of(context).appWidth(80)),
                            SizedBox(
                              height: AppConfig.of(context).appWidth(5),
                            ),
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
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _isVisible = true;
                                    _disableTouch = true;
                                  });
                                  try {
                                    FirebaseUser user = (await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text))
                                        .user;
                                    var _firebaseRef = FirebaseDatabase()
                                        .reference()
                                        .child(FirebaseRef.USERS);
                                    _firebaseRef
                                        .orderByKey()
                                        .equalTo(user.uid)
                                        .once()
                                        .then((snapshot) {
                                      Map<dynamic, dynamic> responseData =
                                          snapshot.value
                                              as Map<dynamic, dynamic>;
                                      Map<dynamic, dynamic> userDate =
                                          responseData[user.uid];
                                      AppUser.User usera =
                                          AppUser.User.fromJson(userDate);
                                      SharedPref.createInstance()
                                          .setCurrentUser(usera);
                                      Future.delayed(Duration(seconds: 3))
                                          .then((value) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                RouteNames.LOCATION);
                                      });
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
                                  .translate(Strings.LOG_IN),
                              textColor: Colors.white,
                              backgorundColor:
                                  AppColors.of(context).mainColor(1),
                              width: AppConfig.of(context).appWidth(80),
                              isToShowEndingIcon: false,
                            ),
                            SizedBox(
                              height: AppConfig.of(context).appWidth(20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(RouteNames.SIGN_UP),
                    child: Container(
                      child: Text(
                        'Create New Account',
                        style: Theme.of(context).textTheme.headline2.copyWith(
                            fontSize: AppConfig.of(context).appWidth(5)),
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.white))),
                    ),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(10),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
