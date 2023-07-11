import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_watering_app/pages/plant_details_page.dart';
import 'package:plant_watering_app/utils/constants.dart';
import 'package:plant_watering_app/utils/plant.dart';
import 'package:plant_watering_app/utils/plant_database.dart';
import 'package:plant_watering_app/utils/water_activity.dart';

class PlantCard extends StatefulWidget {
  const PlantCard({
    Key? key,
    required this.plantId,
    required this.plantName,
    required this.plantSize,
    required this.lastWateredDaysAgo,
    required this.wateringGap,
    required this.plantImageLocation,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

  final int? plantId;
  final String plantName;
  final String plantSize;
  final String plantImageLocation;
  final int lastWateredDaysAgo;
  final int index;
  final int wateringGap;
  final Function onPressed;
  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cTAWidget = widget.lastWateredDaysAgo == 0
        ? WateredTodayButton(
            onPressed: widget.onPressed,
            pId: widget.plantId ?? 0,
          )
        : widget.wateringGap <= widget.lastWateredDaysAgo
            ? WaterCTAButton(
                pId: widget.plantId ?? 0,
                onPressed: widget.onPressed,
              )
            : WaterInfoButton(
                wateringGap: widget.wateringGap,
                lastWateredDaysAgo: widget.lastWateredDaysAgo,
                onPressed: widget.onPressed,
                pId: widget.plantId ?? 0);
    return TextButton(
      onPressed: () async {
        Plant plant = await PlantDatabase.instance.readPlant(widget.plantId!);
        if (context.mounted) {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => PlantDetailsPage(plant: plant)))
              .then((value) => widget.onPressed());
        }
      },
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: cardBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 2,
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.plantName,
                      style: plantNameStyle,
                      softWrap: true,
                    ),
                    cTAWidget,
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: 'plantImage${widget.plantId}',
                    child: Image(
                      fit: BoxFit.cover,
                      image: FileImage(File(widget.plantImageLocation)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaterCTAButton extends StatelessWidget {
  const WaterCTAButton({super.key, required this.pId, required this.onPressed});
  final int pId;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.all(16),
          backgroundColor: primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(48)))),
      onPressed: () async {
        //Add water plant today
        DateTime newDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        WaterActivity waterActivity =
            WaterActivity(wPlantId: pId, wWaterActivityDate: newDate);
        PlantDatabase.instance.createWaterActivity(waterActivity);
        PlantDatabase.instance.updatePlantWateredDate(pId, newDate);
        onPressed();
      },
      child: const Icon(
        CupertinoIcons.drop,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

class WateredTodayButton extends StatelessWidget {
  const WateredTodayButton(
      {super.key, required this.onPressed, required this.pId});
  final Function onPressed;
  final int pId;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            elevation: 2,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)))),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check,
                color: darkColor,
                size: 16,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Today',
                style: todayStyle,
              ),
            ],
          ),
        ),
        onPressed: () async {
          //Remove water today
          DateTime newDate = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);
          List<WaterActivity> waterActivities =
              await PlantDatabase.instance.readAllWaterActivitiesByPlantId(pId);
          WaterActivity(wPlantId: pId, wWaterActivityDate: newDate);
          await PlantDatabase.instance
              .deleteWaterActivity(waterActivities.last.wId ?? 0);
          PlantDatabase.instance.updatePlantWateredDate(pId,
              waterActivities[waterActivities.length - 2].wWaterActivityDate);
          onPressed();
        });
  }
}

class WaterInfoButton extends StatelessWidget {
  final int lastWateredDaysAgo;
  final int wateringGap;
  final Function onPressed;
  final int pId;
  const WaterInfoButton({
    Key? key,
    required this.lastWateredDaysAgo,
    required this.wateringGap,
    required this.onPressed,
    required this.pId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: lightColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Water ${wateringGap - lastWateredDaysAgo > 1 ? 'in ${wateringGap - lastWateredDaysAgo} days' : 'tomorrow'} ',
            style: todayStyle,
          ),
        ),
        onPressed: () async {
          //Add water plant today
          DateTime newDate = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);
          WaterActivity waterActivity =
              WaterActivity(wPlantId: pId, wWaterActivityDate: newDate);
          PlantDatabase.instance.createWaterActivity(waterActivity);
          PlantDatabase.instance.updatePlantWateredDate(pId, newDate);
          onPressed();
        });
  }
}
