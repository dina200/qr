import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/auth_presenters/auth_page_presenter.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/auth_layout.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/social_buttons.dart';
import 'package:qr/src/utils/exceptions.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthPagePresenter(),
      child: Builder(
        builder: _buildLayout,
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    _presenter = Provider.of<AuthPagePresenter>(context);
    return AuthLayout(
      isLoading: _presenter.isLoading,
      child: AuthContainer(
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10.0,
          children: <Widget>[
            Text(
              qrLocale.appName,
              style: Theme.of(context).textTheme.title,
            ),
            SocialButton.google(
              title: qrLocale.loginWithGoogle,
              onPressed: _login,
            ),
            Text(
              qrLocale.or.toLowerCase(),
              style: Theme.of(context).textTheme.subtitle,
            ),
            SocialButton.google(
              title: qrLocale.signUpViaGoogle,
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      await _googleSignIn(_presenter);
      Navigator.of(context).pushNamedAndRemoveUntil(
        routes.inventories,
        (_) => false,
      );
    } on GoogleLoginException catch (e) {
      print(e);
    } on QrStateException catch (e) {
      _errorDialog('${qrLocale.stateException}: ${e.message}');
    } on QrPlatformException catch (e) {
      _errorDialog('${qrLocale.platformException}: ${e.code}');
    } catch (e) {
      _errorDialog('${qrLocale.unknownError}: ${e.runtimeType}');
    }
  }

  Future<void> _register() async {
    try {
      final authPayload = await _googleSignUp(_presenter);
      Navigator.of(context).pushNamed(
        routes.registration,
        arguments: authPayload,
      );
    } on GoogleLoginException catch (e) {
      print(e);
    } on QrPlatformException catch (e) {
      _errorDialog('${qrLocale.platformException}: ${e.code}');
    } catch (e) {
      _errorDialog('${qrLocale.unknownError}: ${e.runtimeType}');
    }
  }

  Future<GooglePayload> _googleSignIn(AuthPagePresenter presenter) async {
    return await presenter.authGoogle(presenter.loginWithGoogle);
  }

  Future<GooglePayload> _googleSignUp(AuthPagePresenter presenter) async {
    return await presenter.authGoogle();
  }

  Future<void> _errorDialog(String info) async {
    await showErrorDialog(
      context: context,
      errorMessage: info,
      onPressed: _returnToSignUpScreen,
    );
  }

  void _returnToSignUpScreen() {
    Navigator.of(context).pop();
  }
}
