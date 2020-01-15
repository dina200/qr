import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/admin_page_presenters/super_admins_presenters/remove_user_from_admins_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/loading_layout.dart';

class RemoveUserFromAdminsPage extends StatefulWidget {
  static const nameRoute = routes.removeUserFromAdmins;

  static PageRoute<RemoveUserFromAdminsPage> buildPageRoute() {
    return MaterialPageRoute<RemoveUserFromAdminsPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RemoveUserFromAdminsPagePresenter(),
      child: RemoveUserFromAdminsPage(),
    );
  }

  @override
  _RemoveUserFromAdminsPageState createState() => _RemoveUserFromAdminsPageState();
}

class _RemoveUserFromAdminsPageState extends State<RemoveUserFromAdminsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  RemoveUserFromAdminsPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<RemoveUserFromAdminsPagePresenter>(context);
    final user = _presenter.onlyAdmins;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(qrLocale.removeUserFromAdmins),
      ),
      body: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: _buildBody(user),
      ),
    );
  }

  Widget _buildBody(List<User> users) {
    if (users != null && users.isNotEmpty)
      return _buildUsersList(users);
    else if (users?.isEmpty ?? false)
      return _buildInfoWidgetAboutEmptyList();
    else
      return SizedBox();
  }

  Widget _buildInfoWidgetAboutEmptyList() {
    return Center(
      child: Text(qrLocale.thereIsNoAnyAdmin),
    );
  }

  Widget _buildUsersList(List<User> users) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 16.0),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildTile(users[index]);
      },
      separatorBuilder: (context, index) => Divider(height: 0.0),
    );
  }

  Widget _buildTile(User user) {
    return ListTile(
      leading: Container(
        width: 80.0,
        alignment: Alignment.centerLeft,
        child: Text(
          '${user.name}',
          style: Theme.of(context).textTheme.subtitle,
        ),
      ),
      title: _buildUserInfo(user),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async => await _onRemoveUserFromAdmins(user),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Text(
      '${user.email}\n${user.phone}',
      style: Theme.of(context).textTheme.caption,
    );
  }

  Future<void> _onRemoveUserFromAdmins(User user) async {
    final isConfirmed = await _showChoiceRemoveUserFromAdminsPageDialog(user);

    if (isConfirmed) {
      try {
        await _presenter.removeUserFromAdmin(user.id);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(qrLocale.successfullyUserRemoved),
          ),
        );
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  Future<bool> _showChoiceRemoveUserFromAdminsPageDialog(User user) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: _buildDialogTitle(user),
          actions: <Widget>[
            FlatButton(
              child: Text(qrLocale.cancel),
              onPressed: () => Navigator.of(context).pop<bool>(false),
            ),
            FlatButton(
              child: Text(qrLocale.ok),
              onPressed: () => Navigator.of(context).pop<bool>(true),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  Widget _buildDialogTitle(User user) {
    return RichText(
      text: TextSpan(
        text: qrLocale.areYouSureWantToRemoveUserFromAdmins,
        style: Theme.of(context).textTheme.subtitle,
        children: [
          TextSpan(
            text:
            '\n\n${qrLocale.name} : ${user.name}\n${qrLocale.email} : ${user.email}\n${qrLocale.phone} : ${user.phone}',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
