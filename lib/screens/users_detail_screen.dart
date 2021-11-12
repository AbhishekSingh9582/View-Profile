import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/profile.dart';
import '../provider/profile_provider.dart';

class UsersDetailScreen extends StatelessWidget {
  const UsersDetailScreen({Key? key}) : super(key: key);

  static const String routeArgs = '/userDetail';

  Widget getDetailCardWidget(String label, dynamic data, String image) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(width: 26),
      SizedBox(height: 32, width: 32, child: Image.asset(image)),
      const SizedBox(
        width: 25.5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
          ),
          Text(data, style: const TextStyle(fontSize: 17.5)),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    List<Profile> usersList =
        Provider.of<ProfileProvider>(context, listen: false).users;
    String userId = ModalRoute.of(context)!.settings.arguments as String;
    Profile _selectedUser =
        usersList.firstWhere((profile) => profile.id == userId);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28)),
              child: Container(
                height: MediaQuery.of(context).size.height / 2 - 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepOrangeAccent.shade700,
                      Colors.deepOrangeAccent.shade400,
                      Colors.orange.shade700,
                      Colors.orange.shade500,
                      Colors.orange.shade400,
                      Colors.orange.shade700,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 57),
                      SizedBox(
                        height: 158,
                        width: 158,
                        child: ClipOval(
                          //maxRadius: double.infinity,
                          child: Image.network(_selectedUser.imageUrl,
                              fit: BoxFit.cover),
                          // backgroundImage: NetworkImage(_selectedUser.imageUrl),
                        ),
                      ),
                      const Expanded(child: SizedBox(height: 16)),
                      Text(
                        _selectedUser.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'AkayaTelivigala',
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 21,
            ),
            const Text(
              'INFO',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            const SizedBox(
              height: 16,
            ),
            getDetailCardWidget('Mobile Number', '${_selectedUser.phoneNumber}',
                'assets/images/ic_mobile.png'),
            const SizedBox(
              height: 26,
            ),
            getDetailCardWidget('E-Mail', _selectedUser.emailAddress,
                'assets/images/ic_email.png'),
            const SizedBox(
              height: 26,
            ),
            getDetailCardWidget(
                'Course', _selectedUser.course, 'assets/images/courses.png'),
            const SizedBox(
              height: 26,
            ),
            getDetailCardWidget(
                'College', _selectedUser.college, 'assets/images/college.png'),
            const SizedBox(
              height: 26,
            ),
            getDetailCardWidget(
                'Address',
                'City - ${_selectedUser.city}\nState - ${_selectedUser.state}\nCountry - ${_selectedUser.country}',
                'assets/images/ic_address.png')
          ],
        ),
      ),
    );
  }
}
