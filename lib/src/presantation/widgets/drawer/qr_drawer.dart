import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/locale/qr_localizations.dart';
import 'package:qr/src/presantation/pages/admin_page/admin_page.dart';
import 'package:qr/src/presantation/pages/auth_page/auth_page.dart';
import 'package:qr/src/presantation/pages/inventories_page/inventories_page.dart';
import 'package:qr/src/presantation/pages/qr_reader_page/qr_reader_page.dart';
import 'package:qr/src/presantation/pages/user_profile_page/user_profile_page.dart';
import 'package:qr/src/presantation/widgets/drawer/qr_drawer_presenter.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/no_scroll_behavior.dart';

class QrDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QrDrawerPresenter(),
      child: Builder(
        builder: _buildDrawer,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final qrLocale = QrLocalizations.of(context);
    final presenter = Provider.of<QrDrawerPresenter>(context);
    final user = presenter.user;
    return Drawer(
      child: ScrollConfiguration(
        behavior: NoOverScrollBehavior(),
        child: ListTileTheme(
          dense: true,
          style: ListTileStyle.drawer,
          child: ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              _buildDrawerHeader(context, user),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(qrLocale.userProfile),
                onTap: () => _navigateTo(context, UserProfilePage.buildPageRoute()),
              ),
              ListTile(
                leading: Icon(Icons.center_focus_strong),
                title: Text(qrLocale.qrHelper),
                onTap: () => _navigateTo(context, QrReaderPage.buildPageRoute()),
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text(qrLocale.inventories),
                onTap: () => _navigateTo(context, InventoriesPage.buildPageRoute()),
              ),
              if (!presenter.isSimpleUser) Divider(),
              if (!presenter.isSimpleUser)
                ListTile(
                  leading: Icon(Icons.supervisor_account),
                  title: Text(qrLocale.adminCapabilities),
                  onTap: () => _navigateTo(context, AdminPage.buildPageRoute()),
                ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(qrLocale.quit),
                onTap: () async => await _logOut(context, presenter),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, User user) {
    final qrLocale = QrLocalizations.of(context);
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                  text: user.name, style: Theme.of(context).textTheme.subtitle),
              TextSpan(text: '\n\n'),
              TextSpan(
                  text: '${qrLocale.position.toLowerCase()}: ${user.position}'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logOut(
    BuildContext context,
    QrDrawerPresenter presenter,
  ) async {
    final qrLocale = QrLocalizations.of(context);
    final isLogout = await _showChoiceDialog(
      context: context,
      message: qrLocale.areYouSureWantToLogout,
      onOk: () => Navigator.of(context).pop<bool>(true),
      onCancel: () => Navigator.of(context).pop<bool>(false),
    );

    if (isLogout) {
      await presenter.logOut();
      await _navigateTo(context, AuthPage.buildPageRoute());
    }
  }

  Future<void> _navigateTo(BuildContext context, Route route) async {
    if (ModalRoute.of(context).settings.name != route.settings.name) {
      await Navigator.of(context).pushAndRemoveUntil(
        route,
        (_) => false,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _showChoiceDialog({
    @required BuildContext context,
    @required String message,
    @required VoidCallback onOk,
    @required VoidCallback onCancel,
  }) async {
    assert(context != null || message != null);
    final qrLocale = QrLocalizations.of(context);
    return await showDialog(
          context: context,
          builder: (context) {
            return InfoDialog(
              info: message,
              actions: [
                DialogAction(
                  text: qrLocale.cancel,
                  onPressed: onCancel,
                ),
                DialogAction(
                  text: qrLocale.ok,
                  onPressed: onOk,
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
