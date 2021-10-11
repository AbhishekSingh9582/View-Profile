import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile.dart';

class ProfileProvider with ChangeNotifier {
  List<Profile> _users = [
    // Profile(
    //   id: 'a',
    //   name: 'Abhishek',
    //   emailAddress: 'abhishekSingh1@gmail.com',
    //   phoneNumber: 9582737212,
    //   city: 'Gurgaon',
    //   state: 'Haryana',
    //   country: 'Inida',
    //   college: 'MDU',
    //   course: 'Btech',
    //   imageUrl:
    //       'https://pointchurch.com/wp-content/uploads/2021/06/Blank-Person-Image.png',
    // ),
    // Profile(
    //   id: 'b',
    //   name: 'Abhi',
    //   emailAddress: 'Singh1@gmail.com',
    //   phoneNumber: 2342526235,
    //   city: 'Lucknow',
    //   state: 'Uttar pradesh',
    //   country: 'Inida',
    //   college: 'Birla',
    //   course: 'MBA',
    //   imageUrl:
    //       'https://pointchurch.com/wp-content/uploads/2021/06/Blank-Person-Image.png',
    // ),
    // Profile(
    //   id: 'c',
    //   name: 'Harsh',
    //   emailAddress: 'harshSharma@gmail.com',
    //   phoneNumber: 9582737234,
    //   city: 'Kota',
    //   state: 'Rajasthan',
    //   country: 'Inida',
    //   college: 'Allen',
    //   course: 'Jee prepration',
    //   imageUrl:
    //       'https://pointchurch.com/wp-content/uploads/2021/06/Blank-Person-Image.png',
    // ),
  ];
  String currentFirebaseUniqueId = '';
  List<Profile> get users {
    return [..._users];
  }

  Future<void> addUser(Profile profile) async {
    final url = Uri.https(
        'profile-view-bf8f8-default-rtdb.firebaseio.com', '/users.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'id': profile.id,
            'userName': profile.name,
            'emailAddress': profile.emailAddress,
            'phone': profile.phoneNumber,
            'college': profile.college,
            'course': profile.course,
            'city': profile.city,
            'state': profile.state,
            'country': profile.country,
          }));

      //print(json.decode(respone.body));

      final newProduct = Profile(
          id: profile.id,
          name: profile.name,
          emailAddress: profile.emailAddress,
          phoneNumber: profile.phoneNumber,
          college: profile.college,
          course: profile.course,
          city: profile.city,
          state: profile.state,
          country: profile.country);
      _users.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetProfile(String auth) async {
    final url = Uri.https(
        'profile-view-bf8f8-default-rtdb.firebaseio.com', '/users.json');
    try {
      final response = await http.get(url);
      print('response body in fetchAndSetProfile');
      print(json.decode(response.body));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData['error'] != null) {
        return;
      }
      final List<Profile> loadedProd = [];

      extractedData.forEach((userId, userData) {
        if (userData['id'] == auth) {
          print('Inside fetchAndSetProfile forEach loop');
          print('currentFirebaseUniqueid =$userId');
          currentFirebaseUniqueId = userId;
        }
        loadedProd.add(Profile(
            id: userData['id'],
            name: userData['userName'],
            emailAddress: userData['emailAddress'],
            phoneNumber: userData['phone'],
            college: userData['college'],
            course: userData['course'],
            city: userData['city'],
            state: userData['state'],
            country: userData['country']));
      });
      // _users.replaceRange(0, loadedProd.length, loadedProd);
      _users = loadedProd;
      _users.forEach((element) {
        print(element.id);
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  List<Profile> listWithoutCurrentUser(String currentUserId) {
    var tempList = users;
    tempList.removeWhere((element) => element.id == currentUserId);
    return tempList;
  }

  List<Profile> currentUserProfile(currentUserId) {
    List<Profile> tempList = [];
    try {
      print('  in CurrentUser List   ');

      var temp = _users.firstWhere((element) => element.id == currentUserId,
          orElse: () {
        print('orElse of currentUserProfile has run ');
        return _users.elementAt(0);
      });

      tempList.add(temp);

      return tempList;
    } catch (error) {
      FirebaseAuth.instance.signOut();
      throw error;
      //return tempList;
    }
  }

  Future<bool> isUserFilledForm(String currentid) async {
    final url = Uri.https(
        'profile-view-bf8f8-default-rtdb.firebaseio.com', '/users.json');
    print(
        'inside isUserFilledForm profile provider AND current user id= $currentid');
    try {
      final response = await http.get(url);
      print(' isUserFilledForm response==${json.decode(response.body)} ');
      if (json.decode(response.body) != null) {
        final extractedData = json.decode(response.body).cast<String, dynamic>()
            as Map<String, dynamic>;
        print('extractedData= $extractedData');
        bool isfilled = false;
        if (extractedData.isEmpty) {
          print(' extracted data empty (isUserFilledForm)');
          return false;
        } else {
          extractedData.forEach((key, profileData) {
            if (profileData['id'] == currentid) {
              print('profleData.id == currentid (iisUserFilledForm)');
              isfilled = true;
            }
          });
          print('is form has filled = $isfilled  (isUserFilledForm) ');
          return isfilled;
        }
      }
      return false;
    } catch (error) {
      print('inside isUserFilledForm Catch block and error = ${error}');
      FirebaseAuth.instance.signOut();
      return false;
    }

    // return _users.any((element) {
    //   print('element.id=${element.id}  :  currentId = ${currentid}');
    //   if (element.id == currentid) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // });
  }

  Profile findById(profileId) {
    return _users.firstWhere((prof) => prof.id == profileId);
  }

  Future<void> updateProfile(String id, Profile newProfile) async {
    print('I am in update profile provider');
    print('current User Firebase Unique id= $currentFirebaseUniqueId');
    final profIndex = _users.indexWhere((element) => element.id == id);
    if (profIndex >= 0) {
      final url = Uri.https('profile-view-bf8f8-default-rtdb.firebaseio.com',
          '/users/$currentFirebaseUniqueId.json');
      await http.patch(url,
          body: json.encode({
            // 'id':newProfile.id,  I think,i don' need this because patch will update only mention data and rest will same as previous
            'userName': newProfile.name,
            'emailAddress': newProfile.emailAddress,
            'phone': newProfile.phoneNumber,
            'college': newProfile.college,
            'course': newProfile.course,
            'city': newProfile.city,
            'state': newProfile.state,
            'country': newProfile.country,
          }));
      _users[profIndex] = newProfile;
      notifyListeners();
    } else {
      print('Error at updateProfile profileProvider.dart');
    }
  }
}
