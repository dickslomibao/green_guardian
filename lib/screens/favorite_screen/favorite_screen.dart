import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etr_mark/provider/plant_details_controller.dart';
import 'package:etr_mark/screens/plant_view/plant_details.dart';
import 'package:etr_mark/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: whiteText,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('favorites')
              .where('user_id',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy('date_added', descending: true)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Favorite is empty.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              );
            }
            final plants = snapshot.data!.docs;
            return ListView.builder(
              itemCount: plants.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                final plant = plants[index]['data'];
                return GestureDetector(
                  onTap: () {
                    context.read<PlantDetailsController>().fetchPlantDetails(
                          plantId: plant['id'].toString(),
                          fromFavorites: true,
                        );
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const PlantDetails(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: plantCardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        if (plant['default_image'] != null &&
                            plant['default_image']['thumbnail'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              plant['default_image']['thumbnail'],
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(),
                            ),
                          ),
                        if (plant['default_image'] != null &&
                            plant['default_image']['thumbnail'] != null)
                          const SizedBox(
                            width: 8,
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plant['common_name'],
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Watering: ${plant['watering']}',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Cycle: ${plant['cycle']}',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
