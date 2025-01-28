import 'package:flutter/material.dart';

//--------------Color----------------------
const tPrimaryColor = Colors.blue;
const tlightPrimaryColor = Color.fromARGB(255, 229, 229, 229);
const ttextcolor = Colors.black;
const tbuttoncolor = Color.fromARGB(255, 123, 189, 243);
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
double tverysmallspace(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.02;
}

double tsmallspace(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.04;
}

double tmidspace(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.1;
}

double tlargespace(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.2;
}

double tfullwidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double tfullheight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
