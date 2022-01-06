import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/ui/pages/user/HistoryScreen.dart';
import 'package:hiltonSample/src/ui/pages/user/Profile.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';

//import 'package:hiltonSample/src/model/User.dart';
import '../../../AppLocalizations.dart';
import '../../../route_generator.dart';

import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';

//import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';

class MyDrawer extends StatefulWidget {
  // //AnimationController _animationController;
  AuthenticationBloc authenticationBloc;

  MyDrawer({Key key, this.authenticationBloc}) : super(key: key);

  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  int currentSelectedDrawerItem = 0;
  User user;
  ThemeBloc themeBloc;

  @override
  void initState() {
    themeBloc = ThemeBloc.getInstance();
    super.initState();
    print("open");
    //widget._animationController.forward();
  }

  @override
  void dispose() {
    print("close");
    super.dispose();
    //widget._animationController.reverse();
  }

  void refreshDrawer() async {
    user = await SharedPref.createInstance().getCurrentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              AppColors.of(context).mainColor(1),
              AppColors.of(context).secondColor(1),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          drawerHeader(context),
          drawerBody(context),
        ],
      ),
    );
  }

  Container drawerBody(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          addDrawerItem(Icons.home_filled, 2,
              AppLocalizations.of(context).translate(Strings.HOME), () {
            widget.authenticationBloc.loginDrawerStreamController.sink.add({});
          }),
          SizedBox(height: AppConfig.of(context).appWidth(3)),
          addDrawerItem(Icons.history, 4,
              AppLocalizations.of(context).translate(Strings.HISTORY), () {
            Navigator.of(context).pushNamed(RouteNames.MAINPAGE,
                arguments: ScreenArguments(currentPage: HistoryScreen()));
            widget.authenticationBloc.loginDrawerStreamController.sink.add({});
          }),
          if (user != null) SizedBox(height: AppConfig.of(context).appWidth(3)),
          if (user != null)
            addDrawerItem(Icons.perm_identity, 5,
                AppLocalizations.of(context).translate(Strings.PROFILE), () {
              Navigator.of(context).pushNamed(RouteNames.MAINPAGE,
                  arguments: ScreenArguments(currentPage: Profile()));
              widget.authenticationBloc.loginDrawerStreamController.sink
                  .add({});
            }),
          SizedBox(height: AppConfig.of(context).appWidth(3)),
          user != null
              ? addDrawerItem(Icons.logout, 5,
                  AppLocalizations.of(context).translate(Strings.LOGOUT),
                  () async {
                  await SharedPref.createInstance().setCurrentUser(null);
                  widget.authenticationBloc.loginDrawerStreamController.sink
                      .add({});
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                })
              : addDrawerItem(Icons.login, 5,
                  AppLocalizations.of(context).translate(Strings.LOGIN), () {
                  Navigator.of(context).pushNamed(RouteNames.LOGIN);
                  widget.authenticationBloc.loginDrawerStreamController.sink
                      .add({});
                }),
        ],
      ),
    );
  }

  Container drawerHeader(BuildContext context) {
    if (user != null)
      return Container(
        margin: EdgeInsets.only(
            left: AppConfig.of(context).appWidth(2),
            top: AppConfig.of(context).appWidth(6),
            bottom: AppConfig.of(context).appWidth(35)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate(Strings.WELCOME),
                  style: Styles.getDrawerItemStyle(
                      color: AppColors.white,
                      fontSize: AppConfig.of(context).appWidth(9),
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: AppConfig.of(context).appWidth(1)),
                  child: Text(
                    user.name ?? user.email,
                    style: Styles.getDrawerItemStyle(
                        color: AppColors.white,
                        fontSize: AppConfig.of(context).appWidth(6),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    else
      return Container(
        margin: EdgeInsets.only(
            left: AppConfig.of(context).appWidth(2),
            top: AppConfig.of(context).appWidth(6),
            bottom: AppConfig.of(context).appWidth(35)),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate(Strings.WELCOME),
                  style: Styles.getDrawerItemStyle(
                      color: AppColors.white,
                      fontSize: AppConfig.of(context).appWidth(9),
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      );
  }

  addDrawerItem(
      IconData icon, int id, String itemName, GestureTapCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: IconButton(
                  icon: Icon(
                    icon,
                    size: AppConfig.of(context).appWidth(8),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            SizedBox(
                width: AppConfig.of(context).appWidth(2)),
            Container(
              width: AppConfig.of(context).appWidth(35),
              child: Text(
                itemName,
                style: Styles.getDrawerItemStyle(
                    color: AppColors.white,
                    fontSize: AppConfig.of(context).appWidth(5),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
