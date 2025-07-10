import 'package:etr_mark/helper.dart';
import 'package:etr_mark/provider/plant_details_controller.dart';
import 'package:etr_mark/provider/plants_controller.dart';
import 'package:etr_mark/provider/user_controller.dart';
import 'package:etr_mark/screens/plant_view/plant_details.dart';
import 'package:etr_mark/screens/restarter_widget.dart';
import 'package:etr_mark/screens/search_screen/search_screen.dart';
import 'package:etr_mark/theme.dart';
import 'package:etr_mark/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final watch = context.watch<UserController>();
    final plants = context.watch<PlantsController>();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: primaryColor,
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg',
                        width: 100,
                        height: 100,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/logo/logo.png',
                            width: 65,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, ${withNullCheckerGetName(data: watch.fullName)}',
                                style: const TextStyle(
                                  color: whiteText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                'Welcome to Green Guardian',
                                style: TextStyle(
                                  color: whiteText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            RestartWidget.restartApp(context);
                          }
                        },
                        child: const Icon(
                          Icons.logout_rounded,
                          color: whiteText,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const SearchScreen(),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: const Text(
                        'Search...',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: whiteText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 1,
                          color: primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Plants',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 100,
                          height: 1,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  plants.isLoading
                      ? const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        )
                      : plants.isError
                          ? Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      plants.errorMessage,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                      ),
                                      onPressed: () {
                                        plants.fetchPlant();
                                      },
                                      child: const Text(
                                        'Refresh',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: plants.plants.length,
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  final plant = plants.plants[index];
                                  if (index >= plants.plants.length - 2) {
                                    plants.fetchPlant();
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      context
                                          .read<PlantDetailsController>()
                                          .fetchPlantDetails(
                                              plantId: plant['id'].toString());
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: const PlantDetails(),
                                        withNavBar:
                                            false, // OPTIONAL VALUE. True by default.
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
                                              plant['default_image']
                                                      ['thumbnail'] !=
                                                  null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                plant['default_image']
                                                    ['thumbnail'],
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          if (plant['default_image'] != null &&
                                              plant['default_image']
                                                      ['thumbnail'] !=
                                                  null)
                                            const SizedBox(
                                              width: 8,
                                            ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  plant['common_name'],
                                                  style: const TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Watering: ${plant['watering']}',
                                                  style: const TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Cycle: ${plant['cycle']}',
                                                  style: const TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
