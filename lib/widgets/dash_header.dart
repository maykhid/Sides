import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DashHeader extends StatelessWidget {
  DashHeader({this.setOtherViews = false, this.headerText, this.pushScreen, this.snapshot});
  final bool setOtherViews;
  final String headerText;
  final Widget pushScreen;
  final snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.0.h,
      // color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //
          Text(
            headerText,
            style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.bold),
          ),
          //
          setOtherViews
              ? Container(
                  // width: 20.0.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => pushScreen,
                            ),
                          );
                        },
                      ),
                      //
                      CircleAvatar(child: Text(snapshot.data[1].username.toString()[0]),),
                    ],
                  ),
                )
              //
              : Container(),
        ],
      ),
    );
  }
}

buildDashHeader(
        {bool setOtherViews, @required String headerText, Widget pushScreen, snapshot}) =>
    DashHeader(
      setOtherViews: setOtherViews,
      headerText: headerText,
      pushScreen: pushScreen,
      snapshot: snapshot,
    );
