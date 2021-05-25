import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trove_app/screens/render_screen.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/services/firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // remove status bar
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth.instance(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider.value(
          value: FirestoreNotifier.instance(FirebaseFirestore.instance),
        ),
      ],
      child: InitBuilders(),
    );
  }
}

class InitBuilders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /**
     * [LayoutBuilder] is necessary when the parent
     * constrains/determines the child size.
     * see [https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html]
     * 
     * [OrientationBuilder] is necessary to render a widget
     * depending on parent widgets orientation.
     *  */
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          // This intializes the Sizer package for usage across the app
          // with contraints from LayoutBuilder and orientation
          // from OrientationBuilder
          SizerUtil().init(constraints, orientation);

          return RootMaterialWidget();
        });
      },
    );
  }
}

class RootMaterialWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      // home: RenderScreen(),
      home: RenderScreen(),
      builder: (context, child) {
        return Scaffold(
          // drawer: AppDrawer(),
          body: child,
        );
      },
    );
  }
}
