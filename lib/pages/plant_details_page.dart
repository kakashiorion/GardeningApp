import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_watering_app/pages/home_page.dart';
import 'package:plant_watering_app/utils/constants.dart';
import 'package:plant_watering_app/utils/plant.dart';
import 'package:plant_watering_app/utils/plant_database.dart';
import 'package:plant_watering_app/utils/take_picture.dart';
import 'package:plant_watering_app/utils/water_activity.dart';

class PlantDetailsPage extends StatefulWidget {
  const PlantDetailsPage({Key? key, required this.plant}) : super(key: key);
  final Plant plant;

  @override
  State<PlantDetailsPage> createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  int waterDiff = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime day4 =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime day1 = day4.subtract(const Duration(days: 3));
    DateTime day2 = day4.subtract(const Duration(days: 2));
    DateTime day3 = day4.subtract(const Duration(days: 1));
    DateTime day5 = day4.add(const Duration(days: 1));
    DateTime day6 = day4.add(const Duration(days: 2));
    DateTime day7 = day4.add(const Duration(days: 3));
    List<DateTime> days = [day1, day2, day3, day4, day5, day6, day7];
    waterDiff = day4.difference(widget.plant.pLastWateredDate).inDays;
    bool mustWaterToday = waterDiff >= widget.plant.pWateringGap;

    return SafeArea(
        bottom: false,
        child: Scaffold(
            extendBody: true,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.plant.pImageLocation)),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircleAvatar(
                          backgroundColor: darkGrayColor,
                          radius: 24,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: lightColor,
                              size: 24,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /** Edit plant photo */
                            CircleAvatar(
                              backgroundColor: darkGrayColor,
                              radius: 24,
                              child: IconButton(
                                onPressed: () async {
                                  var imagePath = await takePicture(context);
                                  if (imagePath !=
                                          widget.plant.pImageLocation &&
                                      imagePath != '') {
                                    Plant updatedPlant = widget.plant
                                        .copy(pImageLocation: imagePath);
                                    PlantDatabase.instance
                                        .updatePlant(updatedPlant);
                                    if (context.mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlantDetailsPage(
                                            plant: updatedPlant,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            /** Remove plant*/
                            CircleAvatar(
                              backgroundColor: darkGrayColor,
                              radius: 24,
                              child: IconButton(
                                  onPressed: () {
                                    //Show dialog to confirm delete
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Remove plant?',
                                              style: titleStyleDark,
                                            ),
                                            content: const Text(
                                              'Are you sure you want to remove this plant?',
                                              style: timeStyle,
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'CLOSE',
                                                    style: plantNameStyle,
                                                  )),
                                              TextButton(
                                                child: Text(
                                                  'CONFIRM',
                                                  style:
                                                      plantNameStyle.copyWith(
                                                          color: Colors.red),
                                                ),
                                                onPressed: () async {
                                                  //Remove plant from DB
                                                  await PlantDatabase.instance
                                                      .deletePlant(
                                                          widget.plant.pId!);
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HomePage()));
                                                  }
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: lightColor,
                                    size: 24,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              height: size.height * .5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Header with name and edit button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.plant.pName,
                            style: titleStyleDark,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: darkGrayColor,
                              size: 24,
                            ),
                            onPressed: () {
                              //TODO: Edit plant details?
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      //Plant details such as size and freq
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.grass,
                                            color: grayColor,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Size',
                                            style: plantSizeStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.plant.pSize,
                                        style: plantNameStyle,
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: tertiaryColor,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.water_drop,
                                            color: grayColor,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Frequency',
                                            style: plantSizeStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${widget.plant.pWateringGap == 1 ? '1 day' : '${widget.plant.pWateringGap} days'} ',
                                        style: plantNameStyle,
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      //Watering schedule of the plant
                      Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: lightColor,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                color: grayColor,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                'Schedule',
                                                style: plantSizeStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          FutureBuilder(
                                              future: PlantDatabase.instance
                                                  .readAllWaterActivitiesByPlantId(
                                                      widget.plant.pId),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          List<WaterActivity>>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return SizedBox(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: days.map((d) {
                                                        bool wateredThisDay =
                                                            snapshot.data?.any(
                                                                    (element) =>
                                                                        element
                                                                            .wWaterActivityDate ==
                                                                        d) ??
                                                                false;
                                                        bool itsToday =
                                                            d == day4;
                                                        bool mustWaterThisDay = (d ==
                                                                    day4 ||
                                                                d == day5 ||
                                                                d == day6 ||
                                                                d == day7) &&
                                                            d
                                                                        .difference(widget
                                                                            .plant
                                                                            .pLastWateredDate)
                                                                        .inDays %
                                                                    widget.plant
                                                                        .pWateringGap ==
                                                                0;
                                                        return Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        2.0),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                //If already watered today, remove water today
                                                                if (itsToday) {
                                                                  if (wateredThisDay) {
                                                                    await PlantDatabase
                                                                        .instance
                                                                        .deleteWaterActivity(
                                                                            snapshot.data?.last.wId ??
                                                                                0);
                                                                    await PlantDatabase.instance.updatePlantWateredDate(
                                                                        widget
                                                                            .plant
                                                                            .pId,
                                                                        snapshot
                                                                            .data![snapshot.data!.length -
                                                                                2]
                                                                            .wWaterActivityDate);
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    //Else, add water today
                                                                    WaterActivity
                                                                        waterActivity =
                                                                        WaterActivity(
                                                                            wPlantId: widget.plant.pId ??
                                                                                0,
                                                                            wWaterActivityDate:
                                                                                day4);
                                                                    await PlantDatabase
                                                                        .instance
                                                                        .createWaterActivity(
                                                                            waterActivity);
                                                                    await PlantDatabase
                                                                        .instance
                                                                        .updatePlantWateredDate(
                                                                            widget.plant.pId,
                                                                            day4);
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                }
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              8,
                                                                          horizontal:
                                                                              2),
                                                                      backgroundColor: itsToday &&
                                                                              (wateredThisDay ||
                                                                                  mustWaterToday)
                                                                          ? primaryColor
                                                                          : Colors
                                                                              .white, //Add bg color based on water activity
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8))),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                      d.day
                                                                          .toString(),
                                                                      style:
                                                                          plantSizeStyle),
                                                                  const SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Icon(
                                                                      wateredThisDay
                                                                          ? Icons
                                                                              .check
                                                                          : mustWaterThisDay
                                                                              ? CupertinoIcons.drop
                                                                              : null,
                                                                      size: 24), //Day Icon based on water activity
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  );
                                                } else {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              }),
                                        ]),
                                  )))
                        ],
                      ),
                    ]),
              ),
            )));
  }
}
