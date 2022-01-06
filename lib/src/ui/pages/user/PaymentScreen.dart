import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hiltonSample/src/bloc/utility/AppUtility.dart';
import 'package:hiltonSample/src/model/Car.dart';
import 'package:hiltonSample/src/ui/widgets/CustomShimmerView.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTextField.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/widgets/CustomItemWidget.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/model/Service.dart';
import 'package:hiltonSample/src/bloc/utility/SessionClass.dart';
import 'package:hiltonSample/src/bloc/utility/FirebaseRef.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/model/Order.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:toast/toast.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';

class PaymentScreen extends StatefulWidget {
  Car selectedCar;
  List<Service> serviceList;
  Order order;

  PaymentScreen({this.selectedCar, this.serviceList, this.order});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController carController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController chargesController = TextEditingController();
  bool isLoading = true,_isVisible = false,_disableTouch = false;
  SessionClass session;

  @override
  void initState() {
    initializePayment();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading)
      return SafeArea(
        child: Scaffold(
          body: AbsorbPointer(
            absorbing: _disableTouch,
            child: Stack(
              children: [
                Container(
                  height: AppConfig.of(context).appHeight(40),
                  width: AppConfig.of(context).appHeight(60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      image: (widget.selectedCar != null &&
                              widget.selectedCar.image != null)
                          ? NetworkImage(widget.selectedCar.image)
                          : (widget.order != null &&
                                  widget.order.car.image != null)
                              ? NetworkImage(widget.order.car.image)
                              : AssetImage(ImageAssetsResolver.CAR),
                      // NetworkImage("https://picsum.photos/seed/picsum/200/300"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.6,
                  maxChildSize: 0.8,
                  builder:
                      (BuildContext context, ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.appScreenColor.withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        controller: scrollController,
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              SizedBox(
                                  height: AppConfig.of(context).appWidth(10)),
                              CustomTextField(
                                  "Car Name",
                                  TextInputType.text,
                                  VALIDATION_TYPE.TEXT,
                                  Icons.account_circle,
                                  carController,
                                  false,
                                  () {},
                                  isEnabled: false,
                                  isAppColorEnable: true,
                                  width: AppConfig.of(context).appWidth(80)),
                              SizedBox(height: AppConfig.of(context).appWidth(5)),
                              CustomTextField(
                                  "Address",
                                  TextInputType.text,
                                  VALIDATION_TYPE.TEXT,
                                  Icons.account_circle,
                                  addressController,
                                  false,
                                  () {},
                                  isEnabled: false,
                                  isAppColorEnable: true,
                                  width: AppConfig.of(context).appWidth(80)),
                              SizedBox(height: AppConfig.of(context).appWidth(5)),
                              CustomTextField(
                                  "Date",
                                  TextInputType.text,
                                  VALIDATION_TYPE.TEXT,
                                  Icons.account_circle,
                                  dateController,
                                  false,
                                  () {},
                                  isEnabled: false,
                                  isAppColorEnable: true,
                                  width: AppConfig.of(context).appWidth(80)),
                              SizedBox(height: AppConfig.of(context).appWidth(5)),
                              CustomTextField(
                                  "Charges",
                                  TextInputType.text,
                                  VALIDATION_TYPE.TEXT,
                                  Icons.account_circle,
                                  chargesController,
                                  false,
                                  () {},
                                  isEnabled: false,
                                  isAppColorEnable: true,
                                  width: AppConfig.of(context).appWidth(80)),
                              SizedBox(height: AppConfig.of(context).appWidth(5)),
                              CustomScrollView(
                                shrinkWrap: true,
                                slivers: [
                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                    Service service = widget.serviceList[index];
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: AppConfig.of(context)
                                                    .appWidth(2),
                                                right: AppConfig.of(context)
                                                    .appWidth(3)),
                                            child: CustomItemWidget(
                                              service: service,
                                              image: index == 0
                                                  ? ImageAssetsResolver.INTERIOR
                                                  : index == 1
                                                      ? ImageAssetsResolver
                                                          .MAINTAINANCE
                                                      : index == 2
                                                          ? ImageAssetsResolver
                                                              .POLISH
                                                          : ImageAssetsResolver
                                                              .WASH,
                                              onPressed: () {},
                                              isViewOnly: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }, childCount: widget.serviceList.length)),
                                ],
                              ),
                              SizedBox(
                                  height: AppConfig.of(context).appWidth(10)),
                              Visibility(
                                  visible: _isVisible,
                                  child:
                                  Center(child: CircularProgressIndicator())),
                              if (_isVisible)
                                SizedBox(
                                  height: AppConfig.of(context).appWidth(5),
                                ),
                              if (widget.order == null)
                                CustomButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isVisible = true;
                                      _disableTouch = true;
                                    });
                                    List<Map<String, dynamic>> result =
                                        new List<Map<String, dynamic>>();
                                    widget.serviceList.forEach((service) {
                                      result.add(service.toJson());
                                    });
                                    Map<String, dynamic> resultCar =
                                        Map<String, dynamic>();
                                    resultCar.addAll(widget.selectedCar.toJson());

                                    User user = await SharedPref.createInstance()
                                        .getCurrentUser();
                                    var _firebaseRef = FirebaseDatabase()
                                        .reference()
                                        .child(FirebaseRef.USERS_ORDERS)
                                        .child(user.id);
                                    _firebaseRef.push().set({
                                      "Car": resultCar,
                                      "Address": addressController.text,
                                      "Lat": session.getCurrentLocation().lat,
                                      "Lng": session.getCurrentLocation().lng,
                                      "Date": dateController.text,
                                      "Charges": chargesController.text,
                                      "Services": result
                                    }).then((value) {
                                      Toast.show(
                                          "Order Placed Successfully", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                      Navigator.pop(context);
                                    }, onError: (error) {
                                      Toast.show(error.toString(), context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    });
                                  },
                                  radius: 10,
                                  text: "Place Order",
                                  textColor: Colors.white,
                                  backgorundColor:
                                      AppColors.of(context).mainColor(1),
                                  width: AppConfig.of(context).appWidth(80),
                                  isToShowEndingIcon: false,
                                ),
                              SizedBox(
                                  height: AppConfig.of(context).appWidth(10)),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    else
      return Container(
          height: AppConfig.of(context).appWidth(120),
          child: Center(child: CustomShimmerView()));
  }

  String getCharges() {
    int charges = 0;
    widget.serviceList.forEach((service) {
      if (service.isSelected) charges = charges + int.parse(service.price);
    });
    return charges.toString();
  }

  void initializePayment() async {
    if (widget.order != null) {
      carController.text = widget.order.car.car;
      addressController.text = widget.order.address;
      dateController.text = widget.order.date;
      chargesController.text = widget.order.charges;
      widget.serviceList = widget.order.services;
    } else {
      SessionClass.getInstance().then((sessionClass) async {
        session = sessionClass;
        carController.text = widget.selectedCar.car;
        addressController.text = session.getCurrentLocation().address;
        dateController.text = await AppUtility.getCurrentDate();
        chargesController.text = getCharges();
      });
    }

    setState(() {
      isLoading = false;
    });
  }
}
