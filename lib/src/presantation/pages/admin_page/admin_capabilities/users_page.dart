import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/pages/user_profile_page/user_profile_page.dart';
import 'package:qr/src/presantation/presenters/admin_page_presenters/users_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/widgets/filters/users_filter_panel.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';

class UsersPage extends StatefulWidget {
  static const nameRoute = routes.users;

  static PageRoute<UsersPage> buildPageRoute() {
    return MaterialPageRoute<UsersPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersPagePresenter(),
      child: UsersPage(),
    );
  }

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  UsersPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<UsersPagePresenter>(context);
    final users = _presenter.users;

    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.users),
      ),
      body: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: Column(
          children: <Widget>[
            UsersFilterPanel(
              onPressed: _onPressedFilter,
              selectedFilter: _presenter.selectedFilter,
            ),
            if (users != null && users.isNotEmpty)
              _buildUsersList(users),
            if (users?.isEmpty ?? false) _buildInfoWidgetAboutEmptyList(),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressedFilter(UserFilter filter) async {
    await _presenter.fetchUsers(filter);
  }

  Widget _buildUsersList(List<User> users) {
    return Expanded(
      child: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (context, index) => Divider(height: 0.0),
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserTile(user);
        },
      ),
    );
  }

  Widget _buildUserTile(User user) {
    return ListTile(
      trailing: Text(user.status.status),
      title: Text(user.name),
      onTap: () => _navigateToUserProfile(user),
    );
  }

  Future<void> _navigateToUserProfile(User user) async {
    await Navigator.of(context).push(UserProfilePage.buildPageRoute(user));
  }

  Widget _buildInfoWidgetAboutEmptyList() {
    return Expanded(
      child: Center(
        child: Text(qrLocale.listIsEmpty),
      ),
    );
  }
}
