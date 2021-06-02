import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trove_app/extras/essentials.dart';
import 'package:trove_app/extras/test_snack.dart';
import 'package:trove_app/extras/validators.dart';
import 'package:trove_app/screens/home_screen.dart';
import 'package:trove_app/screens/render_screen.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/services/firestore.dart';
import 'package:trove_app/widgets/buttons.dart';
import 'package:trove_app/widgets/dash_header.dart';
import 'package:sizer/sizer.dart';

class AcquireLoanScreen extends StatefulWidget {
  static String route = 'aquireScreen';
  @override
  _AcquireLoanScreenState createState() => _AcquireLoanScreenState();
}

class _AcquireLoanScreenState extends State<AcquireLoanScreen> {
  var list = ['6 months', '12 months'];
  String _chosenDuration;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _loanAmount;
  EssentialFunctions _essentialFunctions = EssentialFunctions();
  String _totalAmount;

  @override
  Widget build(BuildContext context) {
    return Consumer2<Auth, FirestoreNotifier>(
        builder: (context, auth, firestore, _) {
      return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                DashHeader(
                  headerText: 'Get Loan',
                ),

                //
                Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // loan amount
                        buildLoanField(),

                        // duration
                        buildDurationDropDown(),

                        SizedBox(height: 10.0.h),
                        //
                        Button.plain(
                          label: 'Get Loan',
                          useGradient: false,
                          buttonColor: Colors.black,
                          useIcon: false,
                          showLoading: firestore.inProgress,
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();

                              await firestore.acquireLoan(
                                // collection: 'loans',
                                document: 'loansDoc${auth.user.uid}',
                                amount: int.parse(_loanAmount),
                                paid: false,
                                duration: _chosenDuration,
                              );

                              if (!firestore.inProgress)
                                GlobalSnackBar.show(
                                  context,
                                  firestore.message,
                                );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Padding buildDurationDropDown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // width: double.infinity,
        height: 8.0.h,
        padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
        //
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        //
        child: DropdownButtonFormField<String>(
          focusColor: Colors.transparent,
          value: _chosenDuration,
          elevation: 5,
          style: TextStyle(color: Colors.white),
          iconEnabledColor: Colors.black,
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          //
          hint: Text(
            "Please select preferred duration ",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),

          onChanged: (String value) {
            setState(() {
              _chosenDuration = value;
            });
          },
          //
          validator: (value) => value == null ? 'Duration is required' : null,
          onSaved: (newValue) => _chosenDuration = newValue,
        ),
      ),
    );
  }

  Container buildLoanField() {
    //
    return Container(
      width: double.infinity,
      height: 8.0.h,
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),

      //
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 2.0.w),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          // enabledBorder: InputBorder.none,
          // errorBorder: InputBorder.none,
          // disabledBorder: InputBorder.none,
          hintText: "Enter amount ",
        ),

        onChanged: (_) async {
          final check = await getFutureInt();
          setState(() => _totalAmount = check);
        },

        validator: (number) {
          //
          final digitOnly = int.tryParse(number);
          //
          // String total = getFutureInt().toString();
          //
          int sixtyPercentOf = _essentialFunctions.sixtyPercent(_totalAmount);
          //
          return LoanValidator.validate(digitOnly, sixtyPercentOf);
        },
        onSaved: (String value) => _loanAmount = value,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        // inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
      ),
    );
  }

  // since a validator does not take in an async function
  // use the fuction below to prepare the result of getPortfoliovalue()
  getFutureInt() async {
    var providerAuth = Provider.of<Auth>(context, listen: false);
    var value = await Provider.of<FirestoreNotifier>(context, listen: false)
        .getPortfolioValue(providerAuth.user.uid);
    return value;
  }
}
