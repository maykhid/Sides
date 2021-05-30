import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trove_app/extras/essentials.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/services/firestore.dart';
import 'package:trove_app/widgets/buttons.dart';
import 'package:trove_app/widgets/dash_header.dart';
import 'package:sizer/sizer.dart';

import 'acquire_loan_screen.dart';

class LoanScreen extends StatefulWidget {
  @override
  _LoanScreenState createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w),
          child: Consumer2<Auth, FirestoreNotifier>(
              // stream: null,
              builder: (context, auth, firestore, _) {
            return FutureBuilder(
                future: firestore.userLoanFuture(auth.user.uid),
                initialData: false,
                builder: (context, snapshot) {
                  //
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return Center(
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  //
                  return snapshot.data.paid
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //
                            DashHeader(
                              headerText: 'Loan',
                            ),
                            //
                            buildGetLoanWidget()
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //
                            DashHeader(
                              headerText: 'Loan',
                            ),
                            //
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Your oustanding loan',
                                    style: TextStyle(
                                        fontSize: 14.0.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                //
                                SizedBox(
                                  height: 4.0.h,
                                ),
                                //
                                LoanBox(snapshot),
                                //
                                SizedBox(
                                  height: 4.0.h,
                                ),
                                //
                                Text(
                                  'Your oustanding loan is to be paid in ${snapshot.data.duration}, but you can pay before then.',
                                  style: TextStyle(
                                    fontSize: 8.0.sp,
                                  ),
                                ),
                                //
                                SizedBox(height: 25.0.h,),
                                //
                                Button.rounded(buttonText: 'Pay Now'),
                              ],
                            ),
                          ],
                        );
                });
          }),
        ),
      ),
    );
  }

  GetLoanWidget buildGetLoanWidget() => GetLoanWidget();
}

class LoanBox extends StatelessWidget {
  final _essentialFunctions = EssentialFunctions();
  LoanBox(this.snapshot);
  final snapshot;
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10.0.h,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      //
      child: Center(
        child: ListTile(
          title: Center(
              child: Text(
            '\$ ${_essentialFunctions.formatToStringComma(snapshot.data.amount.toString())}',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0.sp,
                fontWeight: FontWeight.w700),
          )),
          onTap: () {},
        ),
      ),
    );
  }
}

//
class GetLoanWidget extends StatelessWidget {
  const GetLoanWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 8.0.h,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          //
          child: Center(
            child: ListTile(
              title: Text('Get a loan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // settings: RouteSettings(name: AcquireLoanScreen.route),
                    builder: (BuildContext context) => AcquireLoanScreen(),
                  ),
                );
              },
            ),
          ),
        ),

        //
        Padding(
          padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w, top: 10.0.h),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'You can get a loan of up to 60% of your net asset.',
                    style: TextStyle(
                        fontSize: 8.0.sp, color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
