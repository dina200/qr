import 'package:flutter/material.dart';
import 'package:qr/src/presantation/widgets/no_scroll_behavior.dart';

class QrDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ScrollConfiguration(
        behavior: NoOverScrollBehavior(),
        child: ListTileTheme(
          dense: true,
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {},
              ),
              Divider(height: 0.0),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Quit'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
