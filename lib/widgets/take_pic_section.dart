import 'dart:io';

import 'package:flutter/material.dart';

class TakePicSection extends StatefulWidget {
  final VoidCallback onClicked;
  final String imagePath;
  // TakePicSection(this.onClicked);
  TakePicSection(this.onClicked, this.imagePath, {Key? key}) : super(key: key);

  @override
  _TakePicSectionState createState() => _TakePicSectionState();
}

class _TakePicSectionState extends State<TakePicSection> {
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
              backgroundImage: widget.imagePath.contains('https://')
                  ? NetworkImage(widget.imagePath)
                  : FileImage(File(widget.imagePath)) as ImageProvider,
            ),
            clipBehavior: Clip.antiAlias,
          ),
          Positioned(
            bottom: 0,
            right: 6,
            child: ClipOval(
              child: Container(
                padding: const EdgeInsets.all(3),
                color: Theme.of(context).colorScheme.secondary,
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  onPressed: widget.onClicked,
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
