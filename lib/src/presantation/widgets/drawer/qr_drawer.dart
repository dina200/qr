import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/drawer/qr_drawer_presenter.dart';
import 'package:qr/src/presantation/widgets/no_scroll_behavior.dart';

class QrDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QrDrawerPresenter(),
      child: Builder(
        builder: buildDrawer,
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    final presenter = Provider.of<QrDrawerPresenter>(context);
    final user = presenter.user;
    return Drawer(
      child: ScrollConfiguration(
        behavior: NoOverScrollBehavior(),
        child: ListTileTheme(
          dense: true,
          child: ListView(
            children: <Widget>[
              _buildDrawerHeader(context, user),
              Divider(height: 0.0),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(qrLocale.userProfile),
                onTap: () {
                  //todo: navigate to user profile
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text(qrLocale.inventories),
                onTap: () => _navigateTo(context, routes.inventories),
              ),
              ListTile(
                leading: Icon(Icons.center_focus_strong),
                title: Text(qrLocale.qrReader),
                onTap: () => _navigateTo(context, routes.qrReader),
              ),
              Divider(height: 0.0),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(qrLocale.quit),
                onTap: () async {
                  await presenter.logOut();
                  await _navigateTo(context, routes.auth);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, User user) {
    return DrawerHeader(
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(text: user.name, style: Theme.of(context).textTheme.subtitle),
              TextSpan(text: '\n\n'),
              TextSpan(text: '${qrLocale.position.toLowerCase()}: ${user.position}'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateTo(BuildContext context, String routeName) async {
    if (ModalRoute.of(context).settings.name != routeName) {
      await Navigator.of(context).pushNamedAndRemoveUntil(
        routeName,
        (_) => false,
      );
    }
  }
}
