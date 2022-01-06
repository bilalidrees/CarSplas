import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:toast/toast.dart';
import 'package:hiltonSample/src/bloc/utility/FirebaseRef.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/model/Car.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTitleWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomItemWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomShimmerView.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/widgets/CustomShapeClipper.dart';
import '../../../../route_generator.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/pages/user/AddCarScreen.dart';
import 'package:hiltonSample/src/ui/pages/user/Services.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';

class CarListScreen extends StatefulWidget {
  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  bool isCarAvailable = true, isDataFetching = true;
  int selectedCarIndex = -1;
  Car selectedCar;
  List<Car> carList = List();
  User user;

  @override
  void initState() {
    getAvailableCars();
    super.initState();
  }

  void getAvailableCars() async {
    carList.clear();
    user = await SharedPref.createInstance().getCurrentUser();
    var _firebaseRef = FirebaseDatabase()
        .reference()
        .child(FirebaseRef.USERS_CARS)
        .child(user.id);
    await _firebaseRef.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        for (var value in dataSnapshot.value.values) {
          carList.add(new Car.fromJson(value));
        }
      }
    });

    setState(() {
      if (carList.isEmpty) {
        isCarAvailable = false;
        isDataFetching = false;
      } else {
        isDataFetching = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isCarAvailable)
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
                          context: context, title: "Select a Car")),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(1.8),
                  ),
                ]),
              ),
              isDataFetching
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: AppConfig.of(context).appWidth(5)),
                        Container(
                            height: AppConfig.of(context).appWidth(120),
                            child: Center(child: CustomShimmerView()))
                      ]),
                    )
                  : showCarList(),
              if (!isDataFetching)
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: AppConfig.of(context).appWidth(5)),
                    Container(
                      margin: EdgeInsets.only(
                          top: AppConfig.of(context).appWidth(3),
                          left: AppConfig.of(context).appWidth(6),
                          right: AppConfig.of(context).appWidth(6)),
                      child: CustomButton(
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                              RouteNames.MAINPAGE,
                              arguments:
                                  ScreenArguments(currentPage: AddCarScreen()));
                          setState(() {
                            isCarAvailable = true;
                            isDataFetching = true;
                          });
                          getAvailableCars();
                        },
                        radius: 10,
                        text: "Add Car",
                        textColor: Colors.white,
                        backgorundColor: AppColors.of(context).mainColor(1),
                        width: AppConfig.of(context).appWidth(60),
                        isToShowEndingIcon: false,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(AppConfig.of(context).appWidth(6)),
                      child: CustomButton(
                        onPressed: () async {
                          if (selectedCar != null) {
                            Navigator.of(context).pushNamed(RouteNames.MAINPAGE,
                                arguments: ScreenArguments(
                                    currentPage: Services(
                                  selectedCar: selectedCar,
                                )));
                          } else {
                            Toast.show("Please select a car", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          }
                        },
                        radius: 10,
                        text: "Confirm",
                        textColor: Colors.white,
                        backgorundColor: AppColors.of(context).mainColor(1),
                        width: AppConfig.of(context).appWidth(60),
                        isToShowEndingIcon: false,
                      ),
                    ),
                  ]),
                ),
            ],
          ),
        ),
      );
    else
      return addCarWidget(context);
  }

  Container addCarWidget(BuildContext context) {
    return Container(
      height: AppConfig.of(context).appWidth(180),
      color: AppColors.appScreenColor,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: AppConfig.of(context).appWidth(110),
              width: AppConfig.of(context).appWidth(120),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.of(context).mainColor(1),
                    AppColors.of(context).secondColor(1)
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    'Add a Car to get Started!!!',
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: AppConfig.of(context).appWidth(35),
            left: AppConfig.of(context).appWidth(2),
            child: Container(
              width: AppConfig.of(context).appWidth(100),
              child: Text(
                "Enlightened your experience with CarSplash. ",
                style: Theme.of(context).textTheme.headline2.copyWith(
                    color: AppColors.black.withOpacity(0.8),
                    fontSize: AppConfig.of(context).appWidth(5)),
              ),
            ),
          ),
          Positioned(
            bottom: AppConfig.of(context).appWidth(5),
            right: AppConfig.of(context).appWidth(2),
            child: Align(
              alignment: Alignment.bottomRight,
              child: CustomButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed(RouteNames.MAINPAGE,
                      arguments: ScreenArguments(currentPage: AddCarScreen()));
                  setState(() {
                    isCarAvailable = true;
                    isDataFetching = true;
                  });
                  getAvailableCars();
                },
                radius: 10,
                text: "Add Car",
                textColor: Colors.white,
                backgorundColor: AppColors.of(context).mainColor(1),
                width: AppConfig.of(context).appWidth(50),
                isToShowEndingIcon: false,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget showCarList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      Car car = carList[index];
      return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Icon(Icons.favorite, color: Colors.white),
                Text('Move to favorites',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        secondaryBackground: Container(
          color: AppColors.of(context).secondColor(0.5),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.delete_forever, color: Colors.white),
                Text('Remove Car ', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Remove Confirmation",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                        color: AppColors.of(context).mainColor(1).withOpacity(0.6),
                        fontSize: AppConfig.of(context).appWidth(7))),
                content: Text(
                  "Are you sure you want to remove this car?",
                  style: Theme.of(context).textTheme.headline2.copyWith(
                      color:AppColors.black.withOpacity(0.8),
                      fontSize: AppConfig.of(context).appWidth(4.5)),
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Delete")),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (DismissDirection direction) async {
          FirebaseDatabase()
              .reference()
              .child(FirebaseRef.USERS_CARS)
              .child(user.id)
              .child(car.id)
              .remove()
              .then((value) {
            carList.removeAt(index);
            print('Remove item');
          });
        },
        direction: DismissDirection.endToStart,
        child: CustomItemWidget(
          car: car,
          image: ImageAssetsResolver.CAR,
          onPressed: () {
            setState(() {
              selectedCar = carList[index];
              selectedCarIndex = index;
            });
          },
          isViewOnly: false,
          value: index,
          groupValue: selectedCarIndex,
        ),
      );
    }, childCount: carList.length));
  }
}
