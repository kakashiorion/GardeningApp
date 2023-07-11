import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/plant.dart';
import '../utils/plant_database.dart';
import '../widgets/plant_card.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
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
                'Water Today',
                style: titleStyleDark,
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(child: WaterTodayList()),
            ],
          ),
        ),
      ),
    );
  }
}

class WaterTodayList extends StatefulWidget {
  const WaterTodayList({
    Key? key,
  }) : super(key: key);
  @override
  State<WaterTodayList> createState() => _WaterTodayListState();
}

class _WaterTodayListState extends State<WaterTodayList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plant>>(
      future: PlantDatabase.instance.readAllPlants(),
      builder: (context, otherPlantsList) {
        DateTime today = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        List<Plant> todayList = otherPlantsList.data
                ?.where((element) =>
                    element.pLastWateredDate == today ||
                    element.pLastWateredDate
                        .add(Duration(days: element.pWateringGap))
                        .isBefore(DateTime.now()))
                .toList() ??
            [];
        if (otherPlantsList.connectionState == ConnectionState.none ||
            otherPlantsList.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 4,
            ),
          );
        } else if (otherPlantsList.hasData == false || todayList.isEmpty) {
          return const Center(
            child: Text(
              'No plants to water today!',
              style: subtitleTextStyle,
            ),
          );
        } else {
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: todayList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var plant = todayList[index];
              return PlantCard(
                  wateringGap: plant.pWateringGap,
                  index: index,
                  plantId: plant.pId,
                  plantSize: plant.pSize,
                  plantImageLocation: plant.pImageLocation,
                  plantName: plant.pName,
                  lastWateredDaysAgo:
                      today.difference(plant.pLastWateredDate).inDays,
                  onPressed: () => setState(() {}));
            },
          );
        }
      },
    );
  }
}
