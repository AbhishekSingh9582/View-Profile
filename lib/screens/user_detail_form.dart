import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';
import '../provider/profile.dart';
import '../provider/profile_provider.dart';
import 'all_users_overview.dart';
import '../widgets/take_pic_section.dart';

class UserDetailForm extends StatefulWidget {
  static const routeArgs = '/UserDetailForm';

  UserDetailForm({Key? key}) : super(key: key);

  @override
  State<UserDetailForm> createState() => _UserDetailFormState();
}

class _UserDetailFormState extends State<UserDetailForm> {
  final _formKey = GlobalKey<FormState>();
  // final auth=FirebaseAuth.instance;
  String id = '';
  String? name = '';
  String? emailAddress = '';
  int? phoneNumber = 0;
  String? college = '';
  String? course = '';
  String? city = '';
  String? state = '';
  String? country = '';
  String? imageUrl =
      'https://pointchurch.com/wp-content/uploads/2021/06/Blank-Person-Image.png';

  var isLoading = false;
  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final profileId = ModalRoute.of(context)!.settings.arguments;
      if (profileId != null) {
        final _editedProfile =
            Provider.of<ProfileProvider>(context, listen: false)
                .findById(profileId);
        id = _editedProfile.id;
        name = _editedProfile.name;
        emailAddress = _editedProfile.emailAddress;
        phoneNumber = _editedProfile.phoneNumber;
        college = _editedProfile.college;
        course = _editedProfile.course;
        city = _editedProfile.city;
        state = _editedProfile.state;
        country = _editedProfile.country;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _picImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    print('below image return from picker');
    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final imageName = p.basename(image.path);
    final imageFile = File('${directory.path}/$imageName');
    final newImage = await File(image.path).copy(imageFile.path);
    setState(() {
      imageUrl = newImage.path;
    });
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      print('not valid');
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });
    if (id != '') {
      print("I am in detail form update profile ");
      await Provider.of<ProfileProvider>(context, listen: false).updateProfile(
          id,
          Profile(
            id: this.id, // Hint Or FirebaseAuth.instance.currentUser!.uid,
            city: this.city.toString(),
            name: this.name.toString(),
            emailAddress: this.emailAddress.toString(),
            phoneNumber: this.phoneNumber!,
            state: this.state.toString(),
            country: this.country.toString(),
            course: this.course.toString(),
            college: this.college.toString(),
            imageUrl: this.imageUrl.toString(),
          ));
      Navigator.of(context).pushReplacementNamed(AllUsersOverview.routeArgs);
      setState(() {
        isLoading = false;
      });
    } else {
      try {
        print('I m in add user detail form');
        await Provider.of<ProfileProvider>(context, listen: false)
            .addUser(Profile(
          id: FirebaseAuth.instance.currentUser!.uid,
          city: this.city.toString(),
          name: this.name.toString(),
          emailAddress: this.emailAddress.toString(),
          phoneNumber: this.phoneNumber!,
          state: this.state.toString(),
          country: this.country.toString(),
          course: this.course.toString(),
          college: college.toString(),
          imageUrl: this.imageUrl.toString(),
        ));
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('An error Occured \n Something went wrong! '),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Okay'))
                ],
              );
            });
      } finally {
        Navigator.of(context).pushReplacementNamed(AllUsersOverview.routeArgs);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FILL FORM'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TakePicSection(_picImage, imageUrl.toString()),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onSaved: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Name ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onSaved: (value) {
                        emailAddress = value;
                      },
                      onChanged: (value) => emailAddress = value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email Address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue:
                          phoneNumber == 0 ? '' : phoneNumber.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Phone number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onSaved: (value) {
                        phoneNumber = int.parse(value as String);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Phone Number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: course,
                      decoration: InputDecoration(
                          labelText: 'Course',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onSaved: (value) {
                        course = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Course';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: college,
                      decoration: InputDecoration(
                          labelText: 'College',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onSaved: (value) {
                        college = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter College';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: city,
                      decoration: InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onSaved: (value) {
                        city = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter City';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: state,
                      decoration: InputDecoration(
                          labelText: 'State',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onSaved: (value) {
                        state = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter State';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: country,
                      decoration: InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onSaved: (value) {
                        country = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Country';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
