import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerView extends StatefulWidget {

  CustomShimmerView();

  @override
  _CustomShimmerViewState createState() => _CustomShimmerViewState();
}

class _CustomShimmerViewState extends State<CustomShimmerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor:Colors.white,
              child: ListView.builder(
                itemBuilder: (_, __) => Container(
                  margin: EdgeInsets.all(AppConfig.of(context).appWidth(4)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppConfig.of(context).appWidth(20),
                        height: AppConfig.of(context).appWidth(20),
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: AppConfig.of(context).appWidth(5),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: AppConfig.of(context).appWidth(2),
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: AppConfig.of(context).appWidth(2),
                            ),
                            Container(
                              width: double.infinity,
                              height: AppConfig.of(context).appWidth(2),
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: AppConfig.of(context).appWidth(7),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: AppConfig.of(context).appWidth(8),
                                  height: AppConfig.of(context).appWidth(3),
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: AppConfig.of(context).appWidth(2),
                                ),
                                Container(
                                  width: AppConfig.of(context).appWidth(5),
                                  height: AppConfig.of(context).appWidth(3),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                itemCount: 7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
