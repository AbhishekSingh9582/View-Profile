import 'package:flutter/material.dart';
import '../screens/users_detail_screen.dart';
// import 'package:provider/provider.dart';
// import '../provider/profile_provider.dart';

class GridItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String name;
  const GridItem(this.id, this.imageUrl, this.name, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //List<Profile> listUser= Provider.of<ProfileProvider>(context,listen: false).users;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(UsersDetailScreen.routeArgs, arguments: id);
      },
      child: Column(children: [
        const SizedBox(
          height: 5,
        ),
        Expanded(
            child: Image.network(
          imageUrl,
        )),
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: double.maxFinite,
          height: 27,
          color: Colors.amber,
          child: Center(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Text(
                name,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
