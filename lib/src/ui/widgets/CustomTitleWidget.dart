import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
class CustomTitleWidget extends StatelessWidget {
  String title;
  BuildContext context;

  CustomTitleWidget({this.context, this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline2.copyWith(
          color:AppColors.black.withOpacity(0.6),
          fontSize: AppConfig.of(context).appWidth(10)),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}
