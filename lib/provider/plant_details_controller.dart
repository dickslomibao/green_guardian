import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:etr_mark/const.dart';
import 'package:etr_mark/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PlantDetailsController extends ChangeNotifier {
  Map plant = {};
  Map care = {};
  bool isLoading = false;
  bool isFavorites = false;
  String id = "";

  Future<void> fetchPlantDetails(
      {required String plantId, bool fromFavorites = false}) async {
    isFavorites = false;
    id = plantId;
    isLoading = true;
    if (!fromFavorites) {
      final dio = Dio();
      final response = await dio.get(
        'https://perenual.com/api/species/details/$id',
        queryParameters: {
          'key': apiKey,
        },
      );
      if (response.statusCode == 200) {
        plant = response.data;
        final careGuides = await dio.get(
          'http://perenual.com/api/species-care-guide-list',
          queryParameters: {
            'species_id': id,
            'key': apiKey,
          },
        );
        care = careGuides.data['data'].first;
      }
      await checkIfFavorites();
    } else {
      await getFromFavorites();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addToFavorites() async {
    if (isFavorites) {
      isFavorites = false;
      deleteFavorites();
    } else {
      await FirebaseFirestore.instance.collection('favorites').add({
        'id': id,
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'data': plant,
        'care': care,
        'date_added': DateTime.now().microsecondsSinceEpoch,
      });
      handleToastSuccess('Added to favorites');
      isFavorites = true;
    }

    notifyListeners();
  }

  Future<void> getFromFavorites() async {
    final data = await FirebaseFirestore.instance
        .collection('favorites')
        .where('id', isEqualTo: id)
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    final result = data.docs.first;
    plant = result['data'];
    care = result['care'];
    isFavorites = true;
  }

  Future<void> checkIfFavorites() async {
    final data = await FirebaseFirestore.instance
        .collection('favorites')
        .where('id', isEqualTo: id)
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (data.docs.isNotEmpty) {
      isFavorites = true;
    }
  }

  Future<void> deleteFavorites() async {
    final data = await FirebaseFirestore.instance
        .collection('favorites')
        .where('id', isEqualTo: id)
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (data.docs.isNotEmpty) {
      final first = data.docs.first;
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(first.id)
          .delete();

      handleToastSuccess('Successfully Removed to favorites');
    }
  }
}
