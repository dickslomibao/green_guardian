import 'package:etr_mark/firebase_options.dart';
import 'package:etr_mark/provider/plant_details_controller.dart';
import 'package:etr_mark/provider/plants_controller.dart';
import 'package:etr_mark/provider/plants_search_controller.dart';
import 'package:etr_mark/provider/user_controller.dart';
import 'package:etr_mark/screens/authentication/login.dart';
import 'package:etr_mark/screens/master_screen.dart';
import 'package:etr_mark/screens/provider_screen.dart';
import 'package:etr_mark/screens/restarter_widget.dart';
import 'package:etr_mark/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlantsController(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlantDetailsController(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlantSearchController(),
        ),
      ],
      child: RestartWidget(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const ProviderScreen(),
          builder: FToastBuilder(),
        ),
      ),
    );
  }
}
