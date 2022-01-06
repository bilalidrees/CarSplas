import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/model/Service.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';

class CustomServiceWidget extends StatefulWidget {
  GestureTapCallback onPressed;
  String image;

  CustomServiceWidget({this.onPressed, this.service, this.image});

  Service service;

  @override
  _CustomServiceWidgetState createState() => _CustomServiceWidgetState();
}

class _CustomServiceWidgetState extends State<CustomServiceWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: AppConfig.of(context).appWidth(95),
        margin: EdgeInsets.only(
            left: AppConfig.of(context).appWidth(4),
            right: AppConfig.of(context).appWidth(4),
            bottom: AppConfig.of(context).appWidth(5)),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(
            color: widget.service.isSelected
                ? AppColors.of(context).secondColor(1).withOpacity(0.7)
                : Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
                color: AppColors.of(context).mainColor(1).withOpacity(0.3), width: 2.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.0),
            Container(
              height: AppConfig.of(context).appWidth(42),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  //NetworkImage("https://picsum.photos/seed/picsum/200/300"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: AppConfig.of(context).appWidth(4)),
            Text("${ widget.service.name} ( PKR: ${widget.service.price} )",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.headline2.copyWith(
                  color: widget.service.isSelected
                      ? Colors.white
                      : Colors.black,
                  fontSize: AppConfig.of(context).appWidth(6)),
            ),
            SizedBox(height: AppConfig.of(context).appWidth(4)),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.service.description,
                  style: Theme.of(context).textTheme.headline2.copyWith(
                      color: widget.service.isSelected
                          ? Colors.white
                          : Colors.black.withOpacity(0.7),
                      fontSize: AppConfig.of(context).appWidth(4.5)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
