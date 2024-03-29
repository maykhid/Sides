import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trove_app/widgets/snacks.dart';
import 'package:trove_app/extras/validators.dart';
import 'package:trove_app/models/portfolio_position.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/services/firestore.dart';
import 'package:trove_app/widgets/buttons.dart';
import 'package:trove_app/widgets/ui_widgets.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _username;
  // FormType _formType = FormType.register;

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
    // ScreenData().init(context);

    return Consumer2<Auth, FirestoreNotifier>(
      builder: (context, auth, firestore, _) {
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
                      boldText: 'Create Account',
                      boldSubText: 'Sign up to get started!',
                    ),

                    SizedBox(
                      height: 9.0.h,
                    ),

                    _buildSignUpForm(),

                    SizedBox(
                      height: 9.0.h,
                    ),

                    Button.plain(
                      context: context,
                      label: "Sign Up",
                      gradientColors: [Colors.black, Colors.black54],
                      useIcon: false,
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();

                          //
                          await auth.validateAndSignUp(
                              formKey, _email, _password, _username);

                          //
                          if (auth.user.uid != null) {
                            print("post user?");

                            // writes user data to firestore
                            await firestore.addUserToDb(
                                uid: auth.user.uid,
                                email: _email,
                                username: _username,
                                time: Timestamp.now());

                            // writes default data to firestore for user
                            await firestore.addDefaultPortfolio(
                                json: jsonPortfolio,
                                collection: 'portfolio',
                                document: 'document${auth.user.uid}');

                            // writes a value-less loan
                            await firestore.acquireLoan(
                              document: 'loansDoc${auth.user.uid}',
                              amount: 0.00,
                              paid: true,
                              duration: '',
                            );
                          }
                        }
                      },
                    ),

                    SizedBox(
                      height: 5.0.h,
                    ),

                    _buildBottomText(),
                    // SizedBox.expand()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildBottomText() {
    return Center(
      child: AuthScreenBottomText(
        firstText: 'Already a member',
        secondText: 'Log in',
        onPressed: _goto,
      ),
    );
  }

  _buildSignUpForm() {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          children: [
            TextInputField(
              labelText: 'Full Name',
              validator: UsernameFieldValidator.validate,
              onSaved: (String value) => _username = value,
            ),
            TextInputField(
              labelText: 'Email ID',
              validator: EmailFieldValidator.validate,
              onSaved: (String value) => _email = value,
            ),
            TextInputField(
              labelText: 'Password',
              shouldObscureText: true,
              validator: PasswordFieldValidator.validate,
              onSaved: (String value) => _password = value,
            ),
          ],
        ),
      ),
    );
  }

  void _goto() =>
      //     // This updates Status to Unauthenticated so it can move to the LoginScreen
      Provider.of<Auth>(context, listen: false)
          .updateStatus(Status.Unauthenticated);
}
