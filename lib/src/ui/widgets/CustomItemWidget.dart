import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/model/Car.dart';
import 'package:hiltonSample/src/model/Service.dart';
import 'package:hiltonSample/src/model/Order.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';

class CustomItemWidget extends StatefulWidget {
  GestureTapCallback onPressed;
  int value, groupValue;
  bool isViewOnly;
  String image;
  Car car;
  Service service;
  Order order;

  CustomItemWidget(
      {this.car,
      this.service,
      this.order,
      this.image,
      this.onPressed,
      this.value,
      this.groupValue,
      this.isViewOnly});

  @override
  _CustomItemWidgetState createState() => _CustomItemWidgetState();
}

class _CustomItemWidgetState extends State<CustomItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            margin: EdgeInsets.fromLTRB(
                AppConfig.of(context).appWidth(10),
                AppConfig.of(context).appWidth(5),
                AppConfig.of(context).appWidth(5),
                AppConfig.of(context).appWidth(1)),
            height: AppConfig.of(context).appWidth(30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.isViewOnly
                  ? Colors.white
                  : widget.value == widget.groupValue
                      ? AppColors.of(context).mainColor(1).withOpacity(0.7)
                      : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Container(
              margin: EdgeInsets.only(
                  left: AppConfig.of(context).appWidth(30),
                  top: AppConfig.of(context).appWidth(3),
                  right: AppConfig.of(context).appWidth(3)),
              child: widget.car != null
                  ? Column(
                      children: <Widget>[
                        // SizedBox(
                        //   height: AppConfig.of(context).appWidth(0.5),
                        // ),
                        itemName("${widget.car.company} : ${widget.car.car}"),
                        SizedBox(
                          height: AppConfig.of(context).appWidth(1.5),
                        ),
                        itemName("CC : ${widget.car.cc}"),
                        SizedBox(
                          height: AppConfig.of(context).appWidth(1.5),
                        ),
                        itemName("Type : ${widget.car.type}"),
                      ],
                    )
                  : widget.order != null
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              height: AppConfig.of(context).appWidth(1.5),
                            ),
                            itemName(
                                "${widget.order.car.company} : ${widget.order.car.car}"),
                            SizedBox(
                              height: AppConfig.of(context).appWidth(1.5),
                            ),
                            itemName("Address : ${widget.order.address}"),
                            SizedBox(
                              height: AppConfig.of(context).appWidth(1.5),
                            ),
                            itemName("Charges : ${widget.order.charges}"),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: AppConfig.of(context).appWidth(1.5),
                            ),
                            itemName("Service : ${widget.service.name}"),
                            SizedBox(
                              height: AppConfig.of(context).appWidth(1.5),
                            ),
                            itemName("Price : ${widget.service.price}"),
                          ],
                        ),
            ),
          ),
        ),
        Positioned(
          left: AppConfig.of(context).appWidth(5),
          top: AppConfig.of(context).appWidth(8),
          bottom: AppConfig.of(context).appWidth(4),
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                width: AppConfig.of(context).appWidth(30),
                image: (widget.car != null && widget.car.image != null)
                    ? NetworkImage(widget.car.image)
                    : (widget.order != null && widget.order.car.image != null)
                        ? NetworkImage(widget.order.car.image)
                        : AssetImage(widget.image),
                // NetworkImage("https://picsum.photos/seed/picsum/200/300"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemName(String text) {
    return Container(
      // height: (widget.car != null || widget.order != null)
      //     ? AppConfig.of(context).appWidth(7)
      //     : AppConfig.of(context).appWidth(12.5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline2.copyWith(
              fontSize: AppConfig.of(context).appWidth(5),
              color: widget.isViewOnly
                  ? AppColors.black.withOpacity(0.6)
                  : widget.value == widget.groupValue
                      ? Colors.white
                      : Colors.black87,
              fontWeight: FontWeight.w400),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
