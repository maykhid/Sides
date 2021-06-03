import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trove_app/widgets/snacks.dart';
import 'package:trove_app/extras/validators.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/services/firestore.dart';
import 'package:trove_app/widgets/buttons.dart';
import 'package:trove_app/widgets/dash_header.dart';
import 'package:trove_app/widgets/ui_widgets.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

enum PickOptions {
  ChangeUsername,
  ChangePassword,
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    // var auth = Provider.of<Auth>(context, listen: false);

    return Consumer2<Auth, FirestoreNotifier>(
        // stream: null,
        builder: (context, auth, firestore, _) {
      return SafeArea(
        key: _messangerKey,
        child: Padding(
          padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w),
          child: Column(
            children: [
              //
              buildDashHeader(setOtherViews: false, headerText: 'Settings'),
              //
              buildListContainer(context, firestore, _messangerKey),
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

  Container buildListContainer(
    BuildContext context,
    FirestoreNotifier firestore,
    GlobalKey<ScaffoldMessengerState> messengerKey,
  ) {
    //
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (firestore.inProgress) {
        messengerKey.currentState
            .showSnackBar(GlobalSnackBar.show(context, firestore.message, duration: 2));
      } else if (!firestore.inProgress && firestore.message.isNotEmpty){
        // messengerKey.currentState.removeCurrentSnackBar();
        messengerKey.currentState.showSnackBar(
            GlobalSnackBar.show(context, firestore.message, duration: 5));
      }
    });

    // else {
    //   messengerKey.currentState
    //       .showSnackBar(GlobalSnackBar.show(context, firestore.message));
    // }
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text('Change Username'),
            onTap: () => _showMaterialDialog(
                context, PickOptions.ChangeUsername, _messangerKey),
          ),
          ListTile(
            title: Text('Change Password'),
            onTap: () => _showMaterialDialog(
                context, PickOptions.ChangePassword, _messangerKey),
          ),

          // ListTile(title: Text('Change Password'),),
        ],
      ),
    );
  }
}

_showMaterialDialog(context, PickOptions options,
    GlobalKey<ScaffoldMessengerState> messengerKey) {
  String _password, _username;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // var auth = Provider.of<Auth>(context, listen: false);
  // var firestore = Provider.of<FirestoreNotifier>(context, listen: false);
  //
  showDialog(
    context: context,
    builder: (_) => Consumer2<FirestoreNotifier, Auth>(
        // stream: null,
        builder: (context, firestore, auth, _) {
      return Form(
        key: formKey,
        child: (options == PickOptions.ChangePassword)
            //
            ? AlertDialog(
                title: Text("Change Password"),
                content: TextInputField(
                  labelText: 'Password',
                  // shouldObscureText: true,
                  validator: PasswordFieldValidator.validate,
                  onSaved: (String value) => _password = value,
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Change Password'),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        // Navigator.of(context).pop();

                        await auth.updatePassword(_password);
                      }
                    },
                  ),
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            //
            : AlertDialog(
                title: Text("Change Username"),
                content: TextInputField(
                  labelText: 'Username',
                  // shouldObscureText: true,
                  validator: UsernameFieldValidator.validate,
                  onSaved: (String value) => _username = value,
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Change Username'),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();

                        Navigator.of(context).pop();
                        await firestore.updateUsername(
                            _username, auth.user.uid);
                        // Navigator.of(context).pop();
                        //

                      }
                    },
                  ),
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
      );
    }),
  );
}
