import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/presenters/user_profile_page_presenter.dart';
import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';
import 'package:qr/src/presantation/widgets/without_error_text_form_field.dart';

class UserProfilePage extends StatefulWidget {
  static const nameRoute = routes.userProfile;

  static PageRoute<UserProfilePage> buildPageRoute([User user]) {
    return MaterialPageRoute<UserProfilePage>(
      builder: (context) => _builder(context, user),
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context, User user) {
    return ChangeNotifierProvider(
      create: (_) => UserProfilePagePresenter(user),
      child: UserProfilePage(),
    );
  }

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formStateKey = GlobalKey<FormState>();

  UserProfilePagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<UserProfilePagePresenter>(context);
    return GestureDetector(
      onTap: _resetFocusNode,
      child: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: Scaffold(
          appBar: AppBar(title: Text(qrLocale.userProfile)),
          drawer: _presenter.isCurrentUser ? QrDrawer() : null,
          extendBody: true,
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 480.0,
                maxHeight: 500.0,
              ),
              margin: EdgeInsets.symmetric(vertical: 42.0),
              padding: EdgeInsets.symmetric(horizontal: 42.0),
              child: Form(
                key: _formStateKey,
                child: Column(
                  children: <Widget>[
                    _buildNameFormField(),
                    _buildPositionFormField(),
                    _buildEmailFormField(),
                    _buildPhoneFormField(),
                    _buildStatusFormField(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetFocusNode() => FocusScope.of(context).requestFocus(FocusNode());

  Widget _buildNameFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.name),
      initialValue: _presenter.user.name,
      readOnly: true,
    );
  }

  Widget _buildPositionFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.position),
      initialValue: _presenter.user.position,
      enabled: false,
    );
  }

  Widget _buildEmailFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.email, isDense: true),
      initialValue: _presenter.user.email,
      readOnly: true,
    );
  }

  Widget _buildPhoneFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.phone),
      initialValue: _presenter.user.phone,
      readOnly: true,
    );
  }

  Widget _buildStatusFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.rules),
      initialValue: _presenter.user.status.status,
      enabled: false,
    );
  }
}
