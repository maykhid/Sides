import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/services/firestore.dart';
import 'package:trove_app/widgets/dash_header.dart';
import 'package:trove_app/widgets/ui_widgets.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Future<void> didChangeDependencies() async {
    //
    super.didChangeDependencies();
    var auth = Provider.of<Auth>(context);
    var portfolio = await Provider.of<FirestoreNotifier>(context)
        .getPortfolioValue(auth.user.uid);
    print("Portfolio: $portfolio");
  }

  Map<String, double> dataMap = {
    "AAPL": 2500,
    "TSLA": 3000,
    "AMZN": 4500,
    // "Ionic": 2,
  };

  @override
  Widget build(BuildContext context) {
    return Consumer2<Auth, FirestoreNotifier>(
        builder: (context, auth, firestore, _) {
      return FutureBuilder(
          future: firestore.getPortfolioValue(auth.user.uid),
          initialData: 0.00,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      buildDashHeader(setOtherViews: true, headerText: 'Home'),
                      //
                      buildWelcomeUser(),
                      //
                      buildLineSeparator(),
                      //
                      PieChart(
                        dataMap: dataMap,
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                      ),
                      //
                      Text(
                        'Your Portfolio',
                        style: TextStyle(
                          fontSize: 2.5.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //
                      PortfolioCard(
                        assetImage: 'assets/images/texture.jpg',
                        topText: 'Total Assets',
                        centerText: snapshot.data.toString(),
                        onTap: (){},
                      ),
                      //
                      Text(
                        'Loans',
                        style: TextStyle(
                          fontSize: 2.5.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //
                      PortfolioCard(
                        assetImage: 'assets/images/purple_gradient.jpg',
                        topText: 'Loan collected',
                        centerText: '0.00',
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }

  LineSeparator buildLineSeparator() => LineSeparator();

  buildWelcomeUser() => WelcomeUser(
        boldText: 'Hi',
        boldSubText: 'Henry Ifebunandu',
        fontSize: 40.0,
      );
}

class LineSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.0.h, bottom: 2.5.h),
      child: Container(
        height: 0.1.h,
        color: Colors.black.withOpacity(0.2),
      ),
    );
  }
}

class PortfolioCard extends StatefulWidget {
  PortfolioCard({
    @required this.assetImage,
    @required this.topText,
    @required this.centerText,
    this.onTap,
  });

  final String assetImage, topText, centerText;
  final Function onTap;

  @override
  _PortfolioCardState createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0.h),
      //
      child: GestureDetector(
        
        child: Container(
          height: 20.0.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            // image: DecorationImage(
            //   fit: BoxFit.fill,
            //   image: AssetImage(widget.assetImage),
            // ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),

          //
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 20.0.h,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  Text(
                    widget.topText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 2.5.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //
                  SizedBox(
                    height: 15.0.h,
                    child: Center(
                      child: Text(
                        '\$' + widget.centerText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0.h,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
