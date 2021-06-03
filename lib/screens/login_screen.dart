import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trove_app/widgets/snacks.dart';
import 'package:trove_app/extras/validators.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/widgets/buttons.dart';
import 'package:trove_app/widgets/ui_widgets.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;

  @override
  void didChangeDependencies() {
    var auth = Provider.of<Auth>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!auth.inProgress && auth.message.isNotEmpty) {
      GlobalSnackBar.showAuthSnackbar(context, auth.message, Colors.red, 10);
    }
    });
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, _) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 9.0.h,
                  ),

                  WelcomeUser(
                    boldText: 'Welcome',
                    boldSubText: 'Sign in to continue!',
                    fontSize: 23.0.sp,
                  ),

                  SizedBox(
                    height: 9.0.h,
                  ),

                  _buildLoginForm(),

                  SizedBox(
                    height: 9.0.h,
                  ),

                  Button.plain(
                    context: context,
                    label: "Login",
                    gradientColors: [Colors.black, Colors.black54],
                    useIcon: false,
                    onPressed: () async {
                      //
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        // context
                        //     .read<Auth>()
                        //     .validateAndSubmit(formKey, _email, _password);
                        await auth.validateAndLogin(formKey, _email, _password);
                      }
                    },
                  ),

                  SizedBox(
                    height: 9.0.h,
                  ),

                  _buildBottomText(),
                  // SizedBox.expand()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _buildBottomText() {
    return Center(
      child: AuthScreenBottomText(
        firstText: 'New User',
        secondText: 'Sign up',
        // onPressed: () {
        //   Provider.of<Auth>(context, listen: false)
        //       .updateStatus(Status.NewUser);
        // }
        onPressed: _goto,
      ),
    );
  }

  _buildLoginForm() {
    return Form(
      key: formKey,
      child: Container(
        // padding: EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          children: [
            TextInputField(
              labelText: 'Email ID',
              validator: EmailFieldValidator.validate,
              onSaved: (String value) => _email = value,
            ),
            // SizedBox(
            //   height: 12.0,
            // ),
            TextInputField(
              labelText: 'Password',
              shouldObscureText: true,
              validator: PasswordFieldValidator.validate,
              onSaved: (String value) => _password = value,
            ),
            // SizedBox(
            //   height: 12.0,
            // ),
            Align(
              child: Text(
                'Forgot password?',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      ),
    );
  }

  void _goto() {
    // This updates Status to NewUser so it can move to the SignUpScreen
    Provider.of<Auth>(context, listen: false).updateStatus(Status.NewUser);
  }
}
