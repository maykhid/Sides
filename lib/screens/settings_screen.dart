import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/widgets/buttons.dart';
import 'package:trove_app/widgets/dash_header.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // var auth = Provider.of<Auth>(context, listen: false);

    return Consumer<Auth>(
        // stream: null,
        builder: (context, auth, _) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w),
          child: Column(
            children: [
              //
              buildDashHeader(setOtherViews: false, headerText: 'Settings'),
              //
              Container(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Change Username'),
                    ),
                    ListTile(
                      title: Text('Change Password'),
                    ),
                    // ListTile(title: Text('Change Password'),),
                  ],
                ),
              ),
              //
              SizedBox(
                height: 25.0.h,
              ),

              Button.rounded(
                  buttonText: 'Log out',
                  onPressed: () async {
                    await auth.signOut();

                    if (auth.status == Status.Unauthenticated) {
                      // auth.updateStatus(Status.Unauthenticated);
                      Navigator.pop(context);
                    }
                  }),
              // ListView.builder(
              //   itemCount: 2,
              //   shrinkWrap: true,
              //   itemBuilder: (context, index) {
              //     return ListTile()
              //   },
              // )
            ],
          ),
        ),
      );
    });
  }
}
