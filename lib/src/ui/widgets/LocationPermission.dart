import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/widgets/DialogStatus.dart';
import '../../../AppLocalizations.dart';
import 'CustomButton.dart';

class LocationPermission extends StatelessWidget {
  GestureTapCallback onPressed;
  Function function;
  int isPermission;

  LocationPermission({this.onPressed, this.function, this.isPermission});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: AppConfig.of(context).appHeight(60),
        margin: EdgeInsets.only(
            left: AppConfig.of(context).appWidth(2),
            right: AppConfig.of(context).appWidth(2)),
        padding: EdgeInsets.only(
            left: AppConfig.of(context).appWidth(5),
            right: AppConfig.of(context).appWidth(5)),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: AppColors.of(context).mainColor(1).withOpacity(0.3),
                width: 2),
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                ImageAssetsResolver.APP_BG,
                height: AppConfig.of(context).appHeight(10),
                fit: BoxFit.cover,
              ),
              SizedBox(height: AppConfig.of(context).appHeight(5)),
              Text(
                (isPermission == DialogStatus.LOCATION_PERMISSION.index)
                    ? "Location Permission"
                    : "AppLocalizations.of(context)",
                style: Theme.of(context).textTheme.headline2.copyWith(
                    color: AppColors.black.withOpacity(0.8),
                    fontSize: AppConfig.of(context).appWidth(6)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConfig.of(context).appHeight(3)),
              Container(
                margin: const EdgeInsets.only(right: 38.0, left: 38.0),
                child: Text(
                  (isPermission == DialogStatus.LOCATION_PERMISSION.index)
                      ? "Allow CarSplash to access your location for better experience"
                      : "AppLocalizations.of(context)",
                  style: Theme.of(context).textTheme.headline2.copyWith(
                      color: AppColors.black.withOpacity(0.8),
                      fontSize: AppConfig.of(context).appWidth(5)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppConfig.of(context).appHeight(5)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomButton(
                    onPressed: () {
                      function(
                          AppLocalizations.of(context).translate(Strings.YES));
                    },
                    radius: 10,
                    text: AppLocalizations.of(context).translate(Strings.YES),
                    textColor: AppColors.white,
                    backgorundColor: AppColors.of(context).mainColor(1),
                    width: AppConfig.of(context).appWidth(35),
                    isToShowEndingIcon: false,
                  ),
                  SizedBox(width: AppConfig.of(context).appWidth(2)),
                  isPermission != DialogStatus.LOCATION_PERMISSION.index
                      ? CustomButton(
                          onPressed: () {
                            function(AppLocalizations.of(context)
                                .translate(Strings.NO));
                          },
                          radius: 10,
                          text: AppLocalizations.of(context)
                              .translate(Strings.NO),
                          textColor: AppColors.white,
                          backgorundColor: AppColors.buttonDenied,
                          width: AppConfig.of(context).appWidth(35),
                          isToShowEndingIcon: false,
                        )
                      : Container()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
