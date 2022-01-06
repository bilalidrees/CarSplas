import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/model/Car.dart';
import 'package:hiltonSample/src/model/Service.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTitleWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomServiceWidget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:toast/toast.dart';
import '../../../../route_generator.dart';
import 'package:hiltonSample/src/ui/pages/user/PaymentScreen.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
class Services extends StatefulWidget {
  Car selectedCar;

  Services({this.selectedCar});

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<Service> selectedServiceList = [];
  List<Service> serviceList = [
    Service(
        name: "Interior Cleaning",
        description:
            "Car interior detailing, as the name implies, is a cleaning of the inner parts of a vehicle including leather, plastics, vinyl, carbon fiber plastics, and natural fibers.To clean the inside of the car’s cabinet, different methods such as vacuuming and steam-cleaning are used. It includes the door jambs, every section of the center console, and around the buttons and controls.",
        price: "3000",
        isSelected: false),
    Service(
        name: "Car Maintainance",
        description:
            "On a regular basis, you should bring your car in for a car tune up as well as replace consumable items such as motor oil, radiator coolant, brake fluid, power steering fluid, wiper blades and brake pads. Some vehicles also require mechanical maintenance like replacing spark plugs, drive belts, timing belts or chains, and air and fluid filters.",
        price: "5000",
        isSelected: false),
    Service(
        name: "Car Polish",
        description:
            "A professional car wash takes care of all of your car’s parts—what you can and can not see. With innovative, agile, and comprehensive car wash services, we will bring you back to the memory of your first day with the car. And the best part? Calling us would be very convenient because we’ll bring everything to you, so you can go about your daily life while your car gets cleaned at a location that’s suitable for you.",
        price: "6000",
        isSelected: false),
    Service(
        name: "Car Body Wash",
        description:
            "At full-service car washes, the exterior of the car is washed mechanically or by hand, or using a combination of both, with attendants available to dry the car manually and to clean the interior.",
        price: "7000",
        isSelected: false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.appScreenColor,
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: AppConfig.of(context).appWidth(1.8),
                ),
                Container(
                    margin: EdgeInsets.only(
                      left: AppConfig.of(context).appWidth(5),
                    ),
                    child: CustomTitleWidget(
                        context: context, title: "Select Services")),
                SizedBox(
                  height: AppConfig.of(context).appWidth(10),
                ),
              ]),
            ),
            showServicesList(),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: EdgeInsets.all(AppConfig.of(context).appWidth(4)),
                  child: CustomButton(
                    onPressed: () async {
                      serviceList.forEach((service) {
                        if (service.isSelected)
                          selectedServiceList.add(service);
                      });
                      if(selectedServiceList.length!=0){
                        Navigator.of(context)
                            .pushReplacementNamed(RouteNames.MAINPAGE,
                            arguments: ScreenArguments(
                                currentPage: PaymentScreen(
                                  serviceList: selectedServiceList,
                                  selectedCar: widget.selectedCar,
                                )));
                      }
                     else{
                        Toast.show("Please select at least 1 service", context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM);
                      }
                    },
                    radius: 10,
                    text: "Confirm",
                    textColor: Colors.white,
                    backgorundColor: AppColors.of(context).mainColor(1),
                    width: AppConfig.of(context).appWidth(80),
                    isToShowEndingIcon: false,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget showServicesList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      Service service = serviceList[index];
      return CustomServiceWidget(
        service: service,
        image: index == 0
            ? ImageAssetsResolver.INTERIOR
            : index == 1
                ? ImageAssetsResolver.MAINTAINANCE
                : index == 2
                    ? ImageAssetsResolver.POLISH
                    : ImageAssetsResolver.WASH,
        onPressed: () {
          setState(() {
            serviceList[index].isSelected =
                !serviceList[index].isSelected;
          });
        },
      );
    }, childCount: serviceList.length));
  }
}
