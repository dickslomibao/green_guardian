import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etr_mark/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  String fullName = "";
  String email = "";
  String key = "";
  Future<void> getUserData() async {
    String id = FirebaseAuth.instance.currentUser!.uid;

    final data =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    fullName = data.get('name');
    email = data.get('email');
    await readData();
    notifyListeners();
  }

  Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> saveData(String value) async {
    final pref = await getPrefs();
    await pref.setString('key', value);
    apiKey = value;
  }

  Future<dynamic> readData() async {
    final pref = await getPrefs();
    if (pref.containsKey('key')) {
      apiKey = '${pref.get('key')}';
    }
  }
}
