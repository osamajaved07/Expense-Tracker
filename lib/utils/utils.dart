import 'package:flutter/material.dart';

//--------------Color----------------------
const tPrimaryColor = Color.fromARGB(255, 252, 202, 96);
const tlightPrimaryColor = Color.fromARGB(255, 229, 229, 229);
const ttextcolor = Colors.black;
const tbuttoncolor = Color.fromARGB(255, 0, 251, 255);
const tSecondaryColor = Colors.white;
const tin = Colors.green;
const tout = Colors.red;

//--------------Fontsize----------------------
double tverysmallfontsize(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.037;
}

double tsmallfontsize(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.042;
} // Set a constant value

double tmidfontsize(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.047;
}

double tlargefontsize(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.06;
}

//--------------Space----------------------
double tsmallspace(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.04;
}
