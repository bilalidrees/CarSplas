import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String text;
  Color textColor, backgorundColor;
  IconData icon;
  GestureTapCallback onPressed;
  bool isToShowEndingIcon;
  double width;
  double height;
  double radius;

  CustomButton({
    @required this.text,
    @required this.textColor,
    @required this.backgorundColor,
    @required this.onPressed,
    @required this.width,
    @required this.radius,
    this.icon,
    this.height,
    this.isToShowEndingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      color: backgorundColor,
      onPressed: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        onPressed();
      },
      child: Container(
        width: (width != null ? width : double.infinity),
        height: (height != null ? height : AppConfig.of(context).appHeight(7)),
        alignment: Alignment.center,
        child: buildRow(context, isToShowEndingIcon),
      ),
    );
  }

  Row buildRow(BuildContext context, bool isToShowEndingIcon) {
    if (isToShowEndingIcon) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: AppConfig.of(context).appWidth(5)),
              child: Text(
                (text).toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            width: AppConfig.of(context).appWidth(14.5),
            height: AppConfig.of(context).appHeight(9),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: new Icon(
              icon,
              color: AppColors.black,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              // margin: EdgeInsets.only(right: AppConfig.of(context).appWidth(2)),
              child: Text(
                (text).toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          buildContainer(),
        ],
      );
    }
  }

  Container buildContainer() {
    if (icon != null)
      return Container(
        width: 50,
        height: 50,
        child: new Icon(icon, color: AppColors.white),
      );
    else
      return Container();
  }
}
