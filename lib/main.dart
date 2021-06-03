import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trove_app/extras/test_snack.dart';
import 'package:trove_app/screens/acquire_loan_screen.dart';
import 'package:trove_app/screens/render_screen.dart';
import 'package:trove_app/services/auth.dart';
import 'package:trove_app/services/firestore.dart';
import 'package:trove_app/services/paystack_payment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // remove status bar
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final PaystackPlugin _paystackPlugin = PaystackPlugin();
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
        ChangeNotifierProvider.value(
          value: PayStackNotifier.initialize(_paystackPlugin),
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

class RootMaterialWidget extends StatefulWidget {
  @override
  _RootMaterialWidgetState createState() => _RootMaterialWidgetState();
}

class _RootMaterialWidgetState extends State<RootMaterialWidget> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // displays across app nerwork status
      if (_connectionStatus == ConnectivityResult.none) {
        _messangerKey.currentState.removeCurrentSnackBar();
        _messangerKey.currentState.showSnackBar(
            GlobalSnackBar.showNetworkSnackbar(
                'Check your internet connection', Colors.redAccent, 50000));
      } else {
        _messangerKey.currentState.removeCurrentSnackBar();
        _messangerKey.currentState.showSnackBar(
            GlobalSnackBar.showNetworkSnackbar('Online', Colors.greenAccent, 5));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      // home: RenderScreen(),
      home: RenderScreen(),
      routes: {
        RenderScreen.route: (context) => RenderScreen(),
        AcquireLoanScreen.route: (context) => AcquireLoanScreen(),
      },
      builder: (context, child) {
        return Scaffold(
          // drawer: AppDrawer(),
          body: child,
        );
      },
    );
  }
}
