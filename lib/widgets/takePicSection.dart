import 'package:flutter/material.dart';

class TakePicSection extends StatelessWidget {
  const TakePicSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ClipOval(
          //   child: Image.asset(
          //     'assets/images/blankPerson.jpg',
          //     fit: BoxFit.cover,
          //     height: MediaQuery.of(context).size.height / 4,
          //     width: MediaQuery.of(context).size.width / 1.5,
          //   ),
          // ),
          ClipOval(
            child: CircleAvatar(
              maxRadius: MediaQuery.of(context).size.width / 4,
              backgroundImage: AssetImage('assets/images/blankPerson.jpg'),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          Positioned(
            bottom: 0,
            right: 6,
            child: ClipOval(
              child: Container(
                padding: EdgeInsets.all(3),
                color: Theme.of(context).accentColor,
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                  iconSize: 33,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
