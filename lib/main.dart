import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_watering_app/utils/constants.dart';
import 'package:plant_watering_app/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Watering App',
      themeMode: ThemeMode.light,
      theme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.light,
          primarySwatch: primarySwatchColor),
      home: const HomePage(),
    );
  }
}
