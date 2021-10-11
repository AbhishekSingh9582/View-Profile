import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/profile.dart';
import '../provider/profile_provider.dart';

class UsersDetailScreen extends StatelessWidget {
  const UsersDetailScreen({Key? key}) : super(key: key);

  static const String routeArgs = '/userDetail';

  Widget getDetailCardWidget(String stringPart, dynamic data) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '$stringPart  - ${data}',
        style: TextStyle(fontSize: 22),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Profile> usersList =
        Provider.of<ProfileProvider>(context, listen: false).users;
    String userId = ModalRoute.of(context)!.settings.arguments as String;
    Profile _selectedUser =
        usersList.firstWhere((profile) => profile.id == userId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 270,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  _selectedUser.name,
                  style: TextStyle(
                    fontSize: 23,
                    // color: Colors.orange[600],
                    //backgroundColor: Colors.black),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              background:
                  Image.network(_selectedUser.imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              getDetailCardWidget('Email Address ', _selectedUser.emailAddress),
              getDetailCardWidget('Mobile Number ', _selectedUser.phoneNumber),
              getDetailCardWidget('College ', _selectedUser.college),
              getDetailCardWidget('Course ', _selectedUser.course),
              getDetailCardWidget('City ', _selectedUser.city),
              getDetailCardWidget('State ', _selectedUser.state),
              getDetailCardWidget('Country ', _selectedUser.country),
            ]),
          )
        ],
      ),
    );
  }
}
