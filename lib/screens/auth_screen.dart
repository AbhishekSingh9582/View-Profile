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

  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

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
        elevation: 8,
        child: Container(
          width: MediaQuery.of(context).size.width - 30,
          height: MediaQuery.of(context).size.height / 4 - 30,
          padding: EdgeInsets.symmetric(vertical: 19, horizontal: 35),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.indigo,
                offset: Offset(0, 2),
              )
            ],

            //color: Colors.deepOrange.shade900,
          ),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Text(
              'PROFILE  VIEW',
              style: TextStyle(
                fontWeight: FontWeight.bold,
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
        getAppHeadingBanner(),
        SizedBox(
          height: 16,
        ),
        Flexible(
          child: Card(
            elevation: 14,
            margin: EdgeInsets.all(13),
            shadowColor: Colors.black,
            child: TextField(
              controller: _phoneController,
              decoration: InputDecoration(hintText: 'Phone number'),
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
        SizedBox(
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
            child: Text('Send'),
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
        getAppHeadingBanner(),
        SizedBox(
          height: 16,
        ), //how can we center these below widgets on screen without using Spacer()?
        Flexible(
          child: Card(
            elevation: 14,
            shadowColor: Colors.black,
            margin: EdgeInsets.all(13),
            child: TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter OTP'),
            ),
          ),
        ),
        SizedBox(
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
            child: Text('Verify'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.white, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          width: deviceSize.width,
          height: deviceSize.height,
          child: _showLoading == true
              ? Center(child: CircularProgressIndicator())
              : _currentState == MobileVerificationState.MOBILE_FORM_STATE
                  ? getMobileFormWidget()
                  : getOtpFormWidget(),
        ),
      ),
    );
  }
}
