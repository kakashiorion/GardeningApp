import 'package:flutter/material.dart';
import 'package:plant_watering_app/pages/add_plant_page.dart';
import 'package:plant_watering_app/pages/all_plants_page.dart';
import 'package:plant_watering_app/pages/today_page.dart';
import 'package:plant_watering_app/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedBarItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          extendBody: true,
          body: selectedBarItemIndex == 0
              ? const TodayPage()
              : const AllPlantsPage(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddPlantPage()));
            },
            backgroundColor: darkGrayColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: Colors.white,
            elevation: 8,
            notchMargin: 8,
            child: BottomNavigationBar(
              currentIndex: selectedBarItemIndex,
              onTap: (selectedIndex) {
                setState(() {
                  selectedBarItemIndex = selectedIndex;
                });
              },
              backgroundColor: lightColor.withAlpha(0),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: darkColor,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    alignment: Alignment.bottomCenter,
                    child: FaIcon(
                      FontAwesomeIcons.fillDrip,
                      color:
                          selectedBarItemIndex == 0 ? darkGrayColor : grayColor,
                      size: selectedBarItemIndex == 0 ? 24 : 20,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.tree,
                    color:
                        selectedBarItemIndex == 1 ? darkGrayColor : grayColor,
                    size: selectedBarItemIndex == 1 ? 24 : 20,
                  ),
                  label: 'Plants',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
