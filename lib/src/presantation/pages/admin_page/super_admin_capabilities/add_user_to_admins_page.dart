import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/admin_page_presenters/super_admins_presenters/add_user_to_admins_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/loading_layout.dart';

class AddUserToAdminsPage extends StatefulWidget {
  static const nameRoute = routes.addNewInventory;

  static PageRoute<AddUserToAdminsPage> buildPageRoute() {
    return MaterialPageRoute<AddUserToAdminsPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddUserToAdminsPagePresenter(),
      child: AddUserToAdminsPage(),
    );
  }

  @override
  _AddUserToAdminsPageState createState() => _AddUserToAdminsPageState();
}

class _AddUserToAdminsPageState extends State<AddUserToAdminsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AddUserToAdminsPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<AddUserToAdminsPagePresenter>(context);
    final user = _presenter.onlyUsers;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(qrLocale.addUserToAdmins),
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
      child: Text(qrLocale.thereIsNoAnySimpleUsers),
    );
  }

  Widget _buildUsersList(List<User> users) {
    return ListView.separated(
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
        width: 150.0,
        alignment: Alignment.centerLeft,
        child: Text(
          '${user.name}',
          style: Theme.of(context).textTheme.subtitle,
        ),
      ),
      title: _buildUserInfo(user),
      trailing: IconButton(
        icon: Icon(Icons.group_add),
        onPressed: () async => await _onAddUserToAdmins(user),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Text(
      '${user.email}\n${user.phone}',
      style: Theme.of(context).textTheme.caption,
    );
  }

  Future<void> _onAddUserToAdmins(User user) async {
    final isConfirmed = await _showChoiceAddUserToAdminsDialog(user);

    if (isConfirmed) {
      try {
        await _presenter.addUserToAdmin(user.id);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(qrLocale.successfullyUserAdded),
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

  Future<bool> _showChoiceAddUserToAdminsDialog(User user) async {
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
        text: qrLocale.areYouSureWantToAddUserToAdmins,
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
