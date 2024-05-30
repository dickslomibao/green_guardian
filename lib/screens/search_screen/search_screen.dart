import 'package:etr_mark/provider/plant_details_controller.dart';
import 'package:etr_mark/provider/plants_search_controller.dart';
import 'package:etr_mark/screens/plant_view/plant_details.dart';
import 'package:etr_mark/theme.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final plants = context.watch<PlantSearchController>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      scrollPadding: const EdgeInsets.all(0),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      plants.searchPlant(controller.text.trim());
                    },
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        color: whiteText,
                      ),
                    ),
                  )
                ],
              ),
            ),
            (plants.isLoading)
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  )
                : (plants.plants.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          left: 16,
                        ),
                        child: Text(
                          'Search Results (${plants.total}):',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: Text(
                            'No Result',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
            if (!plants.isLoading && plants.plants.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: plants.plants.length,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      final plant = plants.plants[index];
                      if (index >= plants.plants.length - 2) {
                        plants.searchPlant(controller.text.trim());
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
                                  plant['default_image']['thumbnail'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    plant['default_image']['thumbnail'],
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
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
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
