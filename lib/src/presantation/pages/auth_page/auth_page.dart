import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/auth_screen_presenter.dart';
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthScreenPresenter(),
      child: Builder(
        builder: _buildLayout,
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    final presenter = Provider.of<AuthScreenPresenter>(context);
    return AuthLayout(
      isLoading: presenter.isLoading,
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
              onPressed: () => _login(presenter),
            ),
            Text(
              qrLocale.or.toLowerCase(),
              style: Theme.of(context).textTheme.subtitle,
            ),
            SocialButton.google(
              title: qrLocale.signUpViaGoogle,
              onPressed: () => _register(presenter),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(AuthScreenPresenter presenter) async {
    try {
      final authPayload = await _googleSignIn(presenter);
      Navigator.of(context).pushNamedAndRemoveUntil(
        routes.inventories,
        (_) => false,
      );
    } on GoogleLoginException catch (e) {
      print(e);
    } on QrStateException catch (e) {
      showInfoDialog(
        context: context,
        errorMessage: '${qrLocale.userIsNotRegistered}: ${e.message}',
        onPressed: () => Navigator.of(context).pop(),
      );
    } on QrPlatformException catch (e) {
      showInfoDialog(
        context: context,
        errorMessage: '${qrLocale.checkConnection}: ${e.code}',
        onPressed: () => Navigator.of(context).pop(),
      );
    } catch (e) {
      showInfoDialog(
        context: context,
        errorMessage: '${qrLocale.unknownError}: ${e.runtimeType}',
        onPressed: () => Navigator.of(context).pop(),
      );
    }
  }

  Future<void> _register(AuthScreenPresenter presenter) async {
    try {
      final authPayload = await _googleSignUp(presenter);
      Navigator.of(context).pushNamed(
        routes.registration,
        arguments: authPayload,
      );
    } on GoogleLoginException catch (e) {
      print(e);
    } on QrPlatformException catch (e) {
      showInfoDialog(
        context: context,
        errorMessage: '${qrLocale.checkConnection}: ${e.code}',
        onPressed: () => Navigator.of(context).pop(),
      );
    } catch (e) {
      showInfoDialog(
        context: context,
        errorMessage: '${qrLocale.unknownError}: ${e.runtimeType}',
        onPressed: () => Navigator.of(context).pop(),
      );
    }
  }

  Future<GooglePayload> _googleSignIn(AuthScreenPresenter presenter) async {
    return await presenter.loginWithGoogle();
  }

  Future<GooglePayload> _googleSignUp(AuthScreenPresenter presenter) async {
    return await presenter.getGoogleCredential();
  }
}
