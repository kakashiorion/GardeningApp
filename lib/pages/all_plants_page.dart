import 'package:flutter/material.dart';
import 'package:plant_watering_app/utils/constants.dart';
import 'package:plant_watering_app/utils/plant.dart';
import 'package:plant_watering_app/widgets/plant_card.dart';
import 'package:plant_watering_app/utils/plant_database.dart';

class AllPlantsPage extends StatefulWidget {
  const AllPlantsPage({Key? key}) : super(key: key);

  @override
  State<AllPlantsPage> createState() => _AllPlantsPageState();
}

class _AllPlantsPageState extends State<AllPlantsPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: lightColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Plants',
                style: titleStyleDark,
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(child: MyPlantsList()),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPlantsList extends StatefulWidget {
  const MyPlantsList({
    Key? key,
  }) : super(key: key);

  @override
  State<MyPlantsList> createState() => _MyPlantsListState();
}

class _MyPlantsListState extends State<MyPlantsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plant>>(
      future: PlantDatabase.instance.readAllPlants(),
      builder: (context, otherPlantsList) {
        if (otherPlantsList.connectionState == ConnectionState.none ||
            otherPlantsList.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: darkGrayColor,
              strokeWidth: 4,
            ),
          );
        } else if (otherPlantsList.hasData == false ||
            otherPlantsList.data!.isEmpty) {
          return const Center(
            child: Text(
              'You have no plants.. Add one now!',
              style: subtitleTextStyle,
            ),
          );
        } else {
          DateTime now = DateTime.now();
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: otherPlantsList.data!.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var plant = otherPlantsList.data![index];
              return PlantCard(
                index: index,
                plantId: plant.pId,
                plantImageLocation: plant.pImageLocation,
                plantName: plant.pName,
                lastWateredDaysAgo:
                    now.difference(plant.pLastWateredDate).inDays,
                plantSize: plant.pSize,
                wateringGap: plant.pWateringGap,
                onPressed: () => setState(() {}),
              );
            },
          );
        }
      },
    );
  }
}
