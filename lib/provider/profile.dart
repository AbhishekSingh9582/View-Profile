import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  final String id;
  final String name;
  final String emailAddress;
  final int phoneNumber;
  final String city;
  final String state;
  final String country;
  final String college;
  final String course;
  final String imageUrl;
  Profile(
      {required this.id,
      required this.name,
      required this.emailAddress,
      required this.phoneNumber,
      required this.city,
      required this.state,
      required this.country,
      required this.college,
      this.imageUrl =
          'https://pointchurch.com/wp-content/uploads/2021/06/Blank-Person-Image.png',
      required this.course});
}
