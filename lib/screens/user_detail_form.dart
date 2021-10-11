import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../provider/profile.dart';
import '../provider/profile_provider.dart';
import 'all_users_overview.dart';

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
          college: this.college.toString(),
        ));
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An error Occured \n Something went wrong! '),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'))
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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(labelText: 'Name'),
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
                    TextFormField(
                      initialValue: emailAddress,
                      decoration: InputDecoration(labelText: 'Email Address'),
                      onSaved: (value) {
                        emailAddress = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email Address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue:
                          phoneNumber == 0 ? '' : phoneNumber.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Phone number'),
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
                    TextFormField(
                      initialValue: course,
                      decoration: InputDecoration(labelText: 'Course'),
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
                    TextFormField(
                      initialValue: college,
                      decoration: InputDecoration(labelText: 'College'),
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
                    TextFormField(
                      initialValue: city,
                      decoration: InputDecoration(labelText: 'City'),
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
                    TextFormField(
                      initialValue: state,
                      decoration: InputDecoration(labelText: 'State'),
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
                    TextFormField(
                      initialValue: country,
                      decoration: InputDecoration(labelText: 'Country'),
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
