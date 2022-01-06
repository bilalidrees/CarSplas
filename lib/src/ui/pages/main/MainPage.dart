import 'package:flutter/material.dart';
import 'package:hiltonSample/appLocalizations.dart';
import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/widgets/CustomDrawer.dart';
//import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';

import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';

class MainPage extends StatefulWidget {
  int currentTab = 0;
  String currentTitle;
  Widget currentPage;
  String currentDeliveryAddress;

  MainPage({Key key, this.currentTab, this.currentPage, this.currentTitle})
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<CustomDrawerState> _drawerKey =
      new GlobalKey<CustomDrawerState>();

  AuthenticationBloc authenticationBloc;
  ThemeBloc themeBloc;

  initState() {
    authenticationBloc = AuthenticationBloc.getInstance();
    authenticationBloc.loginDrawerStream.listen((event) {
      _drawerKey.currentState.toggleDrawer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomDrawer(
          key: _drawerKey,
          authenticationBloc: authenticationBloc,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: getTitleText(),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                        AppColors.of(context).mainColor(1),
                        AppColors.of(context).secondColor(1),
                      ])),
                ),
                backgroundColor: AppColors.of(context).mainColor(1),
                elevation: 0,
                leading: IconButton(
                    icon: Icon(
                      Icons.dehaze,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      _drawerKey.currentState.toggleDrawer();
                    }),
                automaticallyImplyLeading: false,
                centerTitle: false,
              ),
              body: widget.currentPage,
            ),
          ),
        ),
      ),
    );
  }

  Text getTitleText() {
    String titleText;
    if (widget.currentTitle != null)
      titleText = widget.currentTitle;
    else
      titleText = "Main Page";
    return Text(titleText,
        style: Styles.getDrawerItemStyle(
            color: AppColors.white,
            fontSize: AppConfig.of(context).appWidth(5),
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.center);
  }
}
