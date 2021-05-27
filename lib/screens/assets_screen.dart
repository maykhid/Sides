import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trove_app/models/portfolio_position.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/services/firestore.dart';
import 'package:trove_app/widgets/dash_header.dart';
import 'package:sizer/sizer.dart';

class AsssetsScreen extends StatefulWidget {
  @override
  _AsssetsScreenState createState() => _AsssetsScreenState();
}

class _AsssetsScreenState extends State<AsssetsScreen> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);

    return SafeArea(
        child: Padding(
      padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w),
      child: Column(
        children: [
          //
          buildDashHeader(setOtherViews: false, headerText: 'Assets'),
          //
          FutureBuilder(
              future: Provider.of<FirestoreNotifier>(context)
                  .getUserPortfolio(auth.user.uid),
              builder: (context, snapshot) {
                //
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return Center(
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                //
                return ListView.separated(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemBuilder: (context, index) {
                    //
                    return ListContainer(index: index, snapshot: snapshot);
                  },
                );
              }),
        ],
      ),
    ));
  }
}

class ListContainer extends StatelessWidget {
  ListContainer({this.snapshot, this.index});
  final AsyncSnapshot<dynamic> snapshot;
  final index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10.0.h,
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
          title: Text(snapshot.data[index].symbol),
          subtitle: Text(
            '\$ ${formatString(snapshot.data[index].equityValue.toStringAsFixed(0))}',
            style: TextStyle(
              fontSize: 20.0.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_rounded,
            size: 10.0.sp,
          ),
        ),
      ),
    );
  }
}

formatString(value) {
return value.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}