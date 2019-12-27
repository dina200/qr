import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr/src/presantation/locale/strings.dart';
import 'package:qr/src/presantation/widgets/auth_layout.dart';
import 'package:qr/src/presantation/widgets/social_buttons.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginPayload _loginPayload;

  @override
  void initState() {
    _loginPayload = LoginPayload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: AuthContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              QrLocale.login.toUpperCase(),
              style: Theme.of(context).textTheme.title,
            ),
            SocialButton.google(title: 'Google', onPressed: (){}),
          ],
        ),
      ),
    );
  }
}

class LoginPayload {
  String login;
  String password;
}
