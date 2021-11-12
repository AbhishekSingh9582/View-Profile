import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:profile_view_app/screens/user_detail_form.dart';
import '../provider/profile_provider.dart';
import 'all_users_overview.dart';

enum MobileVerificationState {
  MOBILE_FORM_STATE,
  OTP_FORM_STATE,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  MobileVerificationState _currentState =
      MobileVerificationState.MOBILE_FORM_STATE;
  final _phoneController =
      TextEditingController(); //do we need to make different controller for each TextField
  final _otpController = TextEditingController();
  String verificationID = '';
  bool _showLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  void signInWithPhoneNumber(phoneAuthCredentials) async {
    setState(() {
      _showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredentials);

      if (authCredential.user != null) {
        if (await Provider.of<ProfileProvider>(context, listen: false)
            .isUserFilledForm(_auth.currentUser!.uid)) {
          print('Inside is UserFilledForm authScreen');

          Navigator.of(context)
              .pushReplacementNamed(AllUsersOverview.routeArgs);
          setState(() {
            _showLoading = false;
          });
        } else {
          print(' isUserFilledForm is false in auth Screen');

          Navigator.of(context).pushReplacementNamed(UserDetailForm.routeArgs);
          setState(() {
            _showLoading = false;
          });
        }
      } else {
        setState(() {
          _showLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showLoading = false;
      });
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  Widget getAppHeadingBanner() {
    return Flexible(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
        child: Container(
          width: MediaQuery.of(context).size.width - 30,
          height: MediaQuery.of(context).size.height / 4 - 30,
          padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 35),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade900,
                Colors.purple.shade700,
                Colors.purple.shade400,
                Colors.deepPurple,
                Colors.deepPurple.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const FittedBox(
            fit: BoxFit.fill,
            child: Text(
              'PROFILE  VIEW',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'AkayaTelivigala',
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getMobileFormWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: SizedBox(
            height: 270,
            width: 280,
            child: Image.asset('assets/images/ProfilePagePic.png'),
          ),
        ),
        getAppHeadingBanner(),
        const SizedBox(
          height: 16,
        ),
        Flexible(
          child: Card(
            elevation: 14,
            margin: const EdgeInsets.all(16),
            shadowColor: Colors.black,
            child: TextField(
              controller: _phoneController,
              decoration: const InputDecoration(hintText: 'Phone number'),
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Flexible(
          child: ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              setState(() {
                _showLoading = true;
              });
              await _auth.verifyPhoneNumber(
                  phoneNumber: "+91${_phoneController.text}",
                  verificationCompleted: (phoneAuthCredentials) async {
                    setState(() {
                      _showLoading = false;
                    });
                  },
                  verificationFailed: (firebaseAuthException) async {
                    setState(() {
                      _showLoading = false;
                    });
                    _scaffoldKey.currentState!.showSnackBar(SnackBar(
                      content: Text(firebaseAuthException.message.toString()),
                    ));
                  },
                  codeSent: (verificationId, resendToken) async {
                    setState(() {
                      _showLoading = false;
                      _currentState = MobileVerificationState.OTP_FORM_STATE;
                      verificationID = verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (verfication) async {});
            },
            child: const Text(
              'Send',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget getOtpFormWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.asset('assets/images/ProfilePagePic.png'),
        ),
        getAppHeadingBanner(),
        const SizedBox(
          height: 16,
        ), //how can we center these below widgets on screen without using Spacer()?
        Flexible(
          child: Card(
            elevation: 14,
            shadowColor: Colors.black,
            margin: const EdgeInsets.all(16),
            child: TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter OTP'),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Flexible(
          child: ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              AuthCredential phoneAuthCredentials =
                  PhoneAuthProvider.credential(
                      verificationId: verificationID,
                      smsCode: _otpController.text);

              signInWithPhoneNumber(phoneAuthCredentials);
            },
            child: const Text('Verify'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      //appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent.shade400,
              Colors.greenAccent.shade700,
              Colors.lightGreenAccent,
              Colors.lightGreenAccent.shade700,
              Colors.lightGreenAccent.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        width: deviceSize.width,
        height: deviceSize.height,
        child: _showLoading == true
            ? const Center(child: CircularProgressIndicator())
            : _currentState == MobileVerificationState.MOBILE_FORM_STATE
                ? getMobileFormWidget()
                : getOtpFormWidget(),
      ),
    );
  }
}
