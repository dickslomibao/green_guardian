import 'package:etr_mark/helper.dart';
import 'package:etr_mark/provider/plant_details_controller.dart';
import 'package:etr_mark/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlantDetails extends StatefulWidget {
  const PlantDetails({Key? key}) : super(key: key);

  @override
  _PlantDetailsState createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  @override
  Widget build(BuildContext context) {
    context.watch<PlantDetailsController>();
    final read = context.read<PlantDetailsController>();

    final plant = read.plant;
    final care = read.care;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 52,
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        actions: [
          if (!read.isLoading)
            GestureDetector(
              onTap: () {
                read.addToFavorites();
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: 15,
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: plantCardColor,
                  child: Icon(
                    read.isFavorites
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: primaryColor,
                  ),
                ),
              ),
            )
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 26,
            color: Colors.white,
          ),
        ),
      ),
      body: read.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  top: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      if (plant['default_image'] != null &&
                          plant['default_image']['original_url'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            plant['default_image']['original_url'],
                            width: double.infinity,
                          ),
                        ),
                      if (plant['default_image'] != null &&
                          plant['default_image']['original_url'] != null)
                        const SizedBox(
                          height: 10,
                        ),
                      Text(
                        plant['common_name'],
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        plant['description'],
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Watering',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        plant['watering'],
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Scientific name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (plant['scientific_name'] == null ||
                              plant['scientific_name'].length == 0)
                          ? const Text(
                              'No available other names',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          : ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: plant['scientific_name'].length,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Text(
                                  plant['scientific_name'][index],
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Other names',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (plant['other_name'] == null ||
                              plant['other_name'].length == 0)
                          ? const Text(
                              'No available other names',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          : ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: plant['other_name'].length,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Text(
                                  plant['other_name'][index],
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Origin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (plant['origin'] == null || plant['origin'].length == 0)
                          ? const Text(
                              'No available Origin name',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          : ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: plant['origin'].length,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Text(
                                  plant['origin'][index],
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Propagation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (plant['propagation'] == null ||
                              plant['propagation'].length == 0)
                          ? const Text(
                              'No available propagation',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          : ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: plant['propagation'].length,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Text(
                                  plant['propagation'][index],
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Pruning month',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (plant['pruning_month'] == null ||
                              plant['pruning_month'].length == 0)
                          ? const Text(
                              'No available pruning month',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: plant['pruning_month'].length,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Text(
                                  plant['pruning_month'][index],
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Care guides',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: care['section'].length,
                        padding: const EdgeInsets.all(0),
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final c = care['section'][index];
                          return Container(
                            margin: EdgeInsets.only(top: index == 0 ? 0 : 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  toTitleCase(c['type']),
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  c['description'],
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
