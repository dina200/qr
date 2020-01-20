import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/locale/qr_localizations.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/pages/auth_page/registration_page.dart';
import 'package:qr/src/presantation/pages/inventories_page/inventories_page.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/auth_page_presenter.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/presantation/widgets/auth_layout.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/social_buttons.dart';
import 'package:qr/src/utils/exceptions.dart';

class AuthPage extends StatefulWidget {
  static const nameRoute = routes.auth;

  static PageRoute<InventoriesPage> buildPageRoute() {
    return MaterialPageRoute<InventoriesPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthPagePresenter(),
      child: AuthPage(),
    );
  }

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthPagePresenter _presenter;

  QrLocalizations get qrLocale => QrLocalizations.of(context);

  @override
  Widget build(BuildContext context) {
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
      await _presenter.loginGoogle();
      await Navigator.of(context).pushAndRemoveUntil(
        InventoriesPage.buildPageRoute(),
        (_) => false,
      );
    } on GoogleLoginException catch (e) {
      print(e);
    } on QrStateException catch (e) {
      await _errorDialog('${qrLocale.stateException}: ${e.message}');
    } on WrongCreditException {
      await _errorDialog(qrLocale.wrongCredits);
    } on PlatformException {
      await _errorDialog(qrLocale.checkConnection);
    } catch (e) {
      await _errorDialog('${qrLocale.unknownError}: ${e.runtimeType}');
    }
  }

  Future<void> _register() async {
    try {
      final authPayload = await _getAuthPayload();
      Navigator.of(context).push(
          RegistrationScreen.buildPageRoute(authPayload)
      );
    } on GoogleLoginException catch (e) {
      print(e);
    } on PlatformException {
      await _errorDialog(qrLocale.checkConnection);
    } catch (e) {
      await _errorDialog('${qrLocale.unknownError}: ${e.runtimeType}');
    }
  }

  Future<GooglePayload> _getAuthPayload() async {
    return await _presenter.authGoogle();
  }

  Future<void> _errorDialog(String info) async {
    await _showErrorDialog(
      errorMessage: info,
      onPressed: _returnToSignInScreen,
    );
  }

  Future<void> _showErrorDialog({
    @required String errorMessage,
    @required VoidCallback onPressed,
  }) async {
    assert(errorMessage != null);
    await showDialog(
      context: context,
      builder: (context) {
        return InfoDialog(
          info: errorMessage,
          actions: [
            DialogAction(
              text: qrLocale.ok,
              onPressed: onPressed,
            )
          ],
        );
      },
    );
  }

  void _returnToSignInScreen() {
    Navigator.of(context).pop();
  }
}
