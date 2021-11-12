import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TakePicSection extends StatefulWidget {
  final Function(XFile? fileImage) _imagePickFn;
  final String imageUrl;
  TakePicSection(this._imagePickFn, this.imageUrl, {Key? key})
      : super(key: key);

  @override
  _TakePicSectionState createState() => _TakePicSectionState();
}

class _TakePicSectionState extends State<TakePicSection> {
  XFile? _fileImage;

  Future<void> _picImage() async {
    final ImagePicker picker = ImagePicker();
    final fileImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (fileImage == null) return;
    setState(() {
      _fileImage = fileImage;
    });
    widget._imagePickFn(_fileImage);
  }

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
              backgroundImage: _fileImage == null
                  ? NetworkImage(widget.imageUrl)
                  : FileImage(File(_fileImage!.path)) as ImageProvider,
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
                    Icons.photo_album_outlined,
                    color: Colors.white,
                  ),
                  onPressed: _picImage,
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
