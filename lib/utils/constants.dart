import 'package:flutter/material.dart';

const grayColor = Color(0xFF717171);
const darkGrayColor = Color(0xFF1E1E1E);
const primaryColor = Color(0xFF87DFFB);
const lightColor = Color(0xFFE8F3FC);
const darkColor = Color(0xFF073848);

const secondaryColor = Color(0xFFF6EECE);
const tertiaryColor = Color(0xFFE5F9F4);

const months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

MaterialColor primarySwatchColor = const MaterialColor(0xFFAAD400, {
  50: Color(0xFF6C9A8B),
  100: Color(0xFF6C9A8B),
  200: Color(0xFF6C9A8B),
  300: Color(0xFF6C9A8B),
  400: Color(0xFF6C9A8B),
  500: Color(0xFF6C9A8B),
  600: Color(0xFF6C9A8B),
  700: Color(0xFF6C9A8B),
  800: Color(0xFF6C9A8B),
  900: Color(0xFF6C9A8B)
});

const titleStyleDark = TextStyle(
    color: darkColor, fontSize: 40, fontWeight: FontWeight.bold, height: 1);

const titleStyleLight =
    TextStyle(color: primaryColor, fontSize: 24, fontWeight: FontWeight.bold);

const timeStyle =
    TextStyle(color: darkColor, fontSize: 12, fontFamily: 'Poppins');

const sizeStyle = TextStyle(color: grayColor, fontSize: 16);
const selectedSizeStyle = TextStyle(color: darkGrayColor, fontSize: 16);

const plantNameStyle = TextStyle(color: darkGrayColor, fontSize: 24);
const plantSizeStyle = TextStyle(color: grayColor, fontSize: 12);
const todayStyle = TextStyle(color: darkColor, fontSize: 12, height: 1);
const subTitleStyle = TextStyle(color: darkGrayColor, fontSize: 16, height: 1);

const takePictureTextStyle =
    TextStyle(color: Colors.white, fontSize: 16, height: 1);

const plantNameStyleDark =
    TextStyle(color: darkColor, fontSize: 20, fontWeight: FontWeight.bold);

const dayTextStyle =
    TextStyle(color: darkColor, fontSize: 20, fontFamily: 'Poppins');
const monthTextStyle =
    TextStyle(color: darkColor, fontSize: 16, fontFamily: 'Poppins');
const plantTitlePrimary = TextStyle(
    color: primaryColor,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins');
const plantSubTitlePrimary = TextStyle(
    color: primaryColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins');
const plantSubTitleSecondary = TextStyle(
    color: secondaryColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins');

const buttonTextStyleLight =
    TextStyle(color: lightColor, fontSize: 16, fontWeight: FontWeight.bold);
const buttonTextStyleDark =
    TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold);

const subtitleTextStyle = TextStyle(color: grayColor, fontSize: 24);

enum PlantSize { small, medium, large }

var cardBoxDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
        spreadRadius: 1,
        blurRadius: 1,
        color: grayColor.withOpacity(.2),
        offset: const Offset(1, 1))
  ],
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
);
