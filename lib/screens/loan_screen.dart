import 'package:flutter/material.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //
              DashHeader(
                headerText: 'Loan',
              ),
              //
              Column(
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
                              builder: (BuildContext context) => AcquireLoanScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10.0.w, right: 10.0.w, top: 10.0.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'You can get a loan of up to 60% of your net asset.',
                              style: TextStyle(
                                  fontSize: 8.0.sp,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
