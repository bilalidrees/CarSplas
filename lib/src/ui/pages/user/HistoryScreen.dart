import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hiltonSample/src/bloc/utility/FirebaseRef.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/model/Order.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTitleWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomItemWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomShimmerView.dart';
import 'package:hiltonSample/src/ui/pages/user/PaymentScreen.dart';
import '../../../../route_generator.dart';

import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isDataFetching = true, isOrderAvailable = false;
  List<Order> orderList = List();

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  void getOrders() async {
    orderList.clear();
    User user = await SharedPref.createInstance().getCurrentUser();
    var _firebaseRef = FirebaseDatabase()
        .reference()
        .child(FirebaseRef.USERS_ORDERS)
        .child(user.id);
    await _firebaseRef.once().then((DataSnapshot dataSnapshot) {
      for (var value in dataSnapshot.value.values) {
        orderList.add(new Order.fromJson(value));
      }
    });

    setState(() {
      if (orderList.isEmpty) {
        isDataFetching = false;
      } else {
        isOrderAvailable = true;
        isDataFetching = false;
      }
    });
  }

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
                        context: context, title: "Order History")),
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
                : isOrderAvailable
                    ? showOrderList()
                    : SliverList(
                        delegate: SliverChildListDelegate([
                          SizedBox(
                            height: AppConfig.of(context).appWidth(1.8),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                left: AppConfig.of(context).appWidth(5),
                              ),
                              child: CustomTitleWidget(
                                  context: context,
                                  title: "No Order Available")),
                          SizedBox(
                            height: AppConfig.of(context).appWidth(1.8),
                          ),
                        ]),
                      ),
          ],
        ),
      ),
    );
  }

  Widget showOrderList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      Order order = orderList[index];
      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: CustomItemWidget(
              order: order,
              image: ImageAssetsResolver.CAR,
              onPressed: () {
                Navigator.of(context).pushNamed(RouteNames.MAINPAGE,
                    arguments: ScreenArguments(
                        currentPage: PaymentScreen(order: order)));
              },
              isViewOnly: true,
            ),
          ),
        ),
      );
    }, childCount: orderList.length));
  }
}
