import 'package:etr_mark/provider/plants_controller.dart';
import 'package:etr_mark/provider/user_controller.dart';
import 'package:etr_mark/screens/authentication/login.dart';
import 'package:etr_mark/screens/master_screen.dart';
import 'package:etr_mark/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  Future<void> loadData() async {
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      });
      return;
    }
    await context.read<UserController>().getUserData();
    if (context.mounted) {
      context.read<PlantsController>().fetchPlant();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MasterScreen(),
        ),
      );
    });
  }

  // @override
  // void initState() {
  //   loadData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    loadData();
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
