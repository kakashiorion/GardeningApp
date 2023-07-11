import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_watering_app/pages/all_plants_page.dart';
import 'package:plant_watering_app/utils/constants.dart';
import 'package:plant_watering_app/utils/plant.dart';
import 'package:plant_watering_app/utils/plant_database.dart';
import 'package:plant_watering_app/utils/take_picture.dart';
import 'package:plant_watering_app/utils/water_activity.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({Key? key}) : super(key: key);

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final PageController _pageController = PageController();
  bool pictureTaken = false;
  var imagePath = '';
  var plantName = '';
  PlantSize? plantSize = PlantSize.medium;
  double sliderValue = 0.5;
  var wateringGap = 1;
  DateTime lastWatered =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: lightColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              //Page 1: Take a picture of the plant
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Text(
                        'Add Plant',
                        style: titleStyleDark,
                      ),
                      const Text(
                        '(1/2)',
                        style: plantSizeStyle,
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: darkGrayColor,
                          radius: 24,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: lightColor,
                              size: 24,
                            ),
                            onPressed: () async {
                              //Open camera and take picture
                              imagePath = await takePicture(context);
                              if (imagePath != '') {
                                setState(() {
                                  pictureTaken = true;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        pictureTaken
                            ? Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: grayColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: SizedBox(
                                      height: size.height / 2,
                                      child: Image(
                                        image: FileImage(
                                          File(imagePath),
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  TextButton(
                                    onPressed: () async {
                                      //Move to next page
                                      if (_pageController.hasClients) {
                                        _pageController.animateToPage(
                                          1,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: darkGrayColor,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8),
                                      child: Text(
                                        'NEXT',
                                        style: takePictureTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const Center(
                                child: Text(
                                    'Take a picture of your lovely plant to show up here',
                                    style: subtitleTextStyle,
                                    textAlign: TextAlign.center),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              //Page 2: Input details of the plant
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                            //Go back to 1st page
                            FocusScope.of(context).unfocus();
                            if (_pageController.hasClients) {
                              _pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ),
                      const Text(
                        'Add Plant',
                        style: titleStyleDark,
                      ),
                      const Text(
                        '(2/2)',
                        style: plantSizeStyle,
                      ),
                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Input 1: Name of plant
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    blurStyle: BlurStyle.normal,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: lightColor,
                                        radius: 12,
                                        child: Icon(
                                          Icons.text_fields,
                                          color: darkGrayColor,
                                          size: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text('Name of your plant',
                                          style: plantSizeStyle)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: lightColor,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurStyle: BlurStyle.inner,
                                          )
                                        ]),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                        hintText: 'Rose',
                                        border: InputBorder.none,
                                        hintStyle: plantNameStyle.copyWith(
                                          color: grayColor,
                                        ),
                                        fillColor: lightColor,
                                      ),
                                      style: plantNameStyle,
                                      cursorColor: grayColor,
                                      onChanged: (value) {
                                        setState(() {
                                          plantName = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Input 2 : Size of plant
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurStyle: BlurStyle.normal,
                                    )
                                  ],
                                ),
                                child: Column(children: [
                                  const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: lightColor,
                                        radius: 12,
                                        child: Icon(
                                          Icons.grass,
                                          color: darkGrayColor,
                                          size: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text('Size of your plant',
                                          style: plantSizeStyle)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CupertinoSlidingSegmentedControl(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    backgroundColor: lightColor,
                                    children: <PlantSize, Widget>{
                                      PlantSize.small: Text(
                                        'Small',
                                        style: plantSize == PlantSize.small
                                            ? selectedSizeStyle
                                            : sizeStyle,
                                      ),
                                      PlantSize.medium: Text(
                                        'Medium',
                                        style: plantSize == PlantSize.medium
                                            ? selectedSizeStyle
                                            : sizeStyle,
                                      ),
                                      PlantSize.large: Text('Large',
                                          style: plantSize == PlantSize.large
                                              ? selectedSizeStyle
                                              : sizeStyle),
                                    },
                                    groupValue: plantSize,
                                    thumbColor: Colors.white,
                                    onValueChanged: (PlantSize? value) {
                                      setState(() {
                                        plantSize = value;
                                      });
                                    },
                                  ),
                                ]),
                              )),
                          //Input 3: Water frequency
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    blurStyle: BlurStyle.normal,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: lightColor,
                                        radius: 12,
                                        child: Icon(
                                          Icons.water_drop,
                                          color: darkGrayColor,
                                          size: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text('Watering frequency',
                                          style: plantSizeStyle)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Text('Every',
                                          style: plantNameStyle),
                                      CircleAvatar(
                                        backgroundColor: darkGrayColor,
                                        child: IconButton(
                                          onPressed: () {
                                            if (wateringGap > 0) {
                                              setState(() {
                                                wateringGap--;
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                            color: lightColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                  blurStyle: BlurStyle.inner)
                                            ]),
                                        child: Text(
                                          wateringGap.toString(),
                                          style: plantNameStyle,
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: darkGrayColor,
                                        child: IconButton(
                                          onPressed: () {
                                            if (wateringGap < 15) {
                                              setState(() {
                                                wateringGap++;
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Text('days', style: plantNameStyle),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          //Submit button
                          CircleAvatar(
                            backgroundColor: darkGrayColor,
                            radius: 24,
                            child: IconButton(
                              onPressed: () async {
                                //Add this plant in DB
                                Plant newPlant = Plant(
                                    pName: plantName,
                                    pImageLocation: imagePath,
                                    pLastWateredDate: lastWatered,
                                    pWateringGap: wateringGap,
                                    pSize: plantSize.toString().substring(10),
                                    pCreatedTime: DateTime.now());
                                int createdPlantId = await PlantDatabase
                                    .instance
                                    .createPlantReturnId(newPlant);

                                //Also add a watering activity for today in DB
                                WaterActivity waterActivity = WaterActivity(
                                    wPlantId: createdPlantId,
                                    wWaterActivityDate: lastWatered);
                                PlantDatabase.instance
                                    .createWaterActivity(waterActivity);
                                //And go back to home page
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllPlantsPage()));
                                }
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
