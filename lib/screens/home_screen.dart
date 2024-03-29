import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:trove_app/extras/essentials.dart';
import 'package:trove_app/screens/assets_screen.dart';
import 'package:trove_app/screens/settings_screen.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/services/firestore.dart';
import 'package:trove_app/widgets/dash_header.dart';
import 'package:trove_app/widgets/ui_widgets.dart';
import 'package:sizer/sizer.dart';

import 'loan_screen.dart';

class HomeScreen extends StatefulWidget {
  static String route = 'HOmeScreen';
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

    await Provider.of<FirestoreNotifier>(context, listen: false)
        .getUserFromDb(uid: auth.user.uid);
    // print("Portfolio: $data");
  }

  Map<String, double> dataMap = {
    "AAPL": 2500,
    "TSLA": 3000,
    "AMZN": 4500,
    // "Ionic": 200,
  };

  EssentialFunctions essentialFunctions = EssentialFunctions();

  @override
  Widget build(BuildContext context) {
    return Consumer2<Auth, FirestoreNotifier>(
      builder: (context, auth, firestore, _) {
        return FutureBuilder(
          // future: firestore.getPortfolioValue(auth.user.uid),""
          future: Future.wait([
            firestore.getPortfolioValue(auth.user.uid),
            firestore.getUserFromDb(uid: auth.user.uid),
            firestore.userLoanFuture(auth.user.uid),
          ]),
          // initialData: 0.00,
          builder: (context, snapshot) {
            return !snapshot.hasData
                ?
                //
                Center(child: CircularProgressIndicator())
                :
                //
                SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            buildDashHeader(
                                setOtherViews: true,
                                headerText: 'Home',
                                pushScreen: SettingsScreen(),
                                snapshot: snapshot,),
                            //
                            buildWelcomeUser(
                                boldText: 'Hi',
                                boldSubText: snapshot.data[1].username),
                            //
                            buildLineSeparator(),
                            //
                            buildPieChart(context),
                            //
                            buildPortfolioText(),
                            //
                            buildLineSeparator(),
                            //
                            buildPortfolioCard1(snapshot, context),
                            //
                            loansText(),
                            //
                            buildLineSeparator(),
                            //
                            buildPortfolioCard2(snapshot, context),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        );
      },
    );
  }

  PortfolioCard buildPortfolioCard2(snapshot, context) {
    return PortfolioCard(
      assetImage: 'assets/images/purple_gradient.jpg',
      topText: 'Loan collected',
      centerText: essentialFunctions.formatToStringComma(snapshot.data[2].amount.toString()),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoanScreen(),
          ),
        );
      },
    );
  }

  Text loansText() {
    return Text(
      'Loans',
      style: TextStyle(
        fontSize: 10.5.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black.withOpacity(0.4),
      ),
    );
  }

  PortfolioCard buildPortfolioCard1(
      AsyncSnapshot snapshot, BuildContext context) {
    return PortfolioCard(
      assetImage: 'assets/images/texture.jpg',
      topText: 'Total Assets',
      
      centerText: essentialFunctions.formatToStringComma(snapshot.data[0]),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AsssetsScreen(),
          ),
        );
      },
    );
  }

  Text buildPortfolioText() {
    return Text(
      'Your Portfolio',
      style: TextStyle(
        fontSize: 10.5.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black.withOpacity(0.4),
      ),
    );
  }

  PieChart buildPieChart(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: [Colors.black, Colors.grey, Colors.blueGrey],
    );
  }

  LineSeparator buildLineSeparator() => LineSeparator();

  buildWelcomeUser({String boldText, String boldSubText}) => WelcomeUser(
        boldText: boldText,
        boldSubText: boldSubText,
        fontSize: 24.0.sp,
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
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
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
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //
                  SizedBox(
                    height: 13.0.h,
                    child: Center(
                      child: Text(
                        '\$' + widget.centerText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0.sp,
                            fontWeight: FontWeight.bold,),
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
