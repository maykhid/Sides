import 'package:flutter/material.dart';
import 'package:trove_app/screens/settings_screen.dart';
import 'package:sizer/sizer.dart';

class DashHeader extends StatelessWidget {
  DashHeader({this.setOtherViews = false, this.headerText});
  final bool setOtherViews;
  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.0.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //
          Text(
            headerText,
            style: TextStyle(fontSize: 2.5.h, fontWeight: FontWeight.bold),
          ),
          //
          setOtherViews
              ? Container(
                  width: 20.0.w,
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
                              builder: (BuildContext context) =>
                                  SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      //
                      CircleAvatar(),
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

buildDashHeader({bool setOtherViews, @required String headerText}) =>
    DashHeader(
      setOtherViews: setOtherViews,
      headerText: headerText,
    );
