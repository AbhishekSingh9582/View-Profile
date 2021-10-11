import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../provider/profile.dart';
import '../provider/profile_provider.dart';
import '../widgets/grid_item.dart';
import 'user_detail_form.dart';
import 'users_detail_screen.dart';
import 'auth_screen.dart';

class AllUsersOverview extends StatefulWidget {
  AllUsersOverview({Key? key}) : super(key: key);
  static const routeArgs = '/AllUsersOverview';

  @override
  _AllUsersOverviewState createState() => _AllUsersOverviewState();
}

class _AllUsersOverviewState extends State<AllUsersOverview> {
  final auth = FirebaseAuth.instance;
  var _isLoading = false;
  List<Profile> currentUserProfileinList = [];
  List<Profile> nonCurrentUserList = [];

  // var _isInit = true;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<ProfileProvider>(context, listen: false)
            .fetchAndSetProfile(auth.currentUser!.uid);
        currentUserProfileinList =
            Provider.of<ProfileProvider>(context, listen: false)
                .currentUserProfile(auth.currentUser!.uid);

        nonCurrentUserList =
            Provider.of<ProfileProvider>(context, listen: false)
                .listWithoutCurrentUser(auth.currentUser!.uid);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthScreen()));
      }
    });
    super.initState();
  }
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     print('i am in _isInit true dependecy');
  //     print('fetchAndSetProfileCall');
  //     Provider.of<ProfileProvider>(context, listen: false).fetchAndSetProfile();
  //   }
  //   print('outside didChangeDependency and _isInit false');
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // List<Profile> userList = Provider.of<ProfileProvider>(context).users;
    Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE VIEW'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Edit Profile')
                    ],
                  ),
                ),
                value: 'Edit Profile',
              ),
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Sign Out'),
                    ],
                  ),
                ),
                value: 'Sign Out',
              )
            ],
            onChanged: (selectedItem) async {
              if (selectedItem == 'Edit Profile') {
                Navigator.of(context).pushReplacementNamed(
                    UserDetailForm.routeArgs,
                    arguments: auth.currentUser!
                        .uid); // Hint:  Repalce with auth.instance!.uid
              }
              if (selectedItem == 'Sign Out') {
                await auth.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthScreen()));
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      print(
                          '${auth.currentUser!.uid} and ${currentUserProfileinList[index].id} index=$index userLength= ${currentUserProfileinList.length}');
                      if (auth.currentUser!.uid ==
                          currentUserProfileinList[index].id) {
                        //May be don't need this condition now
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              UsersDetailScreen.routeArgs,
                              arguments: currentUserProfileinList[index].id),
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 12, left: 12, right: 12, bottom: 2),
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(children: [
                              const SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                height: 135,
                                width: 135,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      currentUserProfileinList[index].imageUrl),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                  width: double.maxFinite,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Text(
                                        currentUserProfileinList[index].name,
                                        style: const TextStyle(
                                          fontSize: 30,
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                            ]),
                          ),
                        );
                      }
                    },
                    childCount: currentUserProfileinList.length,
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (auth.currentUser!.uid !=
                              nonCurrentUserList[index].id &&
                          nonCurrentUserList.length > 0) {
                        print('Now i am in NonCurrent list widget SliverGrid');
                        //May be i don't need this condition too
                        return Container(
                          margin: const EdgeInsets.all(10),
                          child: GridItem(
                            nonCurrentUserList[index].id,
                            nonCurrentUserList[index].imageUrl,
                            nonCurrentUserList[index].name,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue),
                        );
                      }
                    },
                    childCount: nonCurrentUserList.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    // crossAxisSpacing: 10,
                    // mainAxisSpacing: 10,
                  ),
                )
              ],
            ),
    );
  }
}
