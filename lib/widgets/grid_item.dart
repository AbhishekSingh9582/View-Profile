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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () {
          Navigator.of(context)
              .pushNamed(UsersDetailScreen.routeArgs, arguments: id);
        },
        child: Column(children: [
          // const SizedBox(
          //   height: 5,
          // ),
          Expanded(
              child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          )),
          Container(
            // margin: const EdgeInsets.only(top: 5),
            width: double.maxFinite,
            height: 31,

            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
