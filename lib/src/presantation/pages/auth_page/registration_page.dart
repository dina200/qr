import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/pages/auth_page/auth_page.dart';
import 'package:qr/src/presantation/pages/inventories_page/inventories_page.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/registration_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/auth_button.dart';
import 'package:qr/src/presantation/widgets/auth_layout.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/without_error_text_form_field.dart';
import 'package:qr/src/utils/exceptions.dart';

class RegistrationScreen extends StatefulWidget {
  static const nameRoute = routes.registration;

  static PageRoute<InventoriesPage> buildPageRoute(
      GooglePayload googlePayload) {
    return MaterialPageRoute<InventoriesPage>(
      builder: (context) => _builder(context, googlePayload),
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context, GooglePayload googlePayload) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationPagePresenter(),
      child: RegistrationScreen(googlePayload: googlePayload),
    );
  }

  final GooglePayload googlePayload;

  const RegistrationScreen({Key key, this.googlePayload}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formStateKey = GlobalKey<FormState>();

  RegistrationPagePresenter _presenter;

  FocusNode _positionFieldFocusNode = FocusNode();
  FocusNode _phoneFieldFocusNode = FocusNode();

  bool _isCreateAccountButtonActive = false;

  String _name;
  String _position;
  String _phone;

  @override
  Widget build(BuildContext context) {
    _presenter =
        Provider.of<RegistrationPagePresenter>(context);
    return AuthLayout(
      isLoading: _presenter.isLoading,
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                isDense: true,
              ),
        ),
        child: AuthContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTitle(),
              SizedBox(height: 32.0),
              Form(
                key: _formStateKey,
                onChanged: _onFormChanged,
                child: Column(
                  children: <Widget>[
                    _buildNameFormField(),
                    _buildEmailFormField(),
                    _buildPositionFormField(),
                    _buildPhoneFormField(),
                    SizedBox(height: 32.0),
                    _buildInfoWidget(),
                    SizedBox(height: 16.0),
                    _buildCreateAccountButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      qrLocale.registration,
      style: Theme.of(context).textTheme.title,
    );
  }

  void _onFormChanged() {
    bool isFormFieldValidated = _formStateKey.currentState.validate();
    if (_isCreateAccountButtonActive != isFormFieldValidated) {
      setState(
        () => _isCreateAccountButtonActive = isFormFieldValidated,
      );
    }
  }

  Widget _buildNameFormField() {
    final GooglePayload payload = widget.googlePayload;

    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.name),
      initialValue: payload.name,
      validator: _validateIsEmpty,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: _onNameSubmitted,
      onSaved: _onSavedName,
    );
  }

  void _onNameSubmitted(_) {
    FocusScope.of(context).requestFocus(_positionFieldFocusNode);
  }

  void _onSavedName(String newValue) {
    _name = newValue;
  }

  Widget _buildPositionFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.position),
      validator: _validateIsEmpty,
      textInputAction: TextInputAction.next,
      focusNode: _positionFieldFocusNode,
      onFieldSubmitted: _onPositionSubmitted,
      onSaved: _onSavedPosition,
    );
  }

  String _validateIsEmpty(String value) {
    if (value.isEmpty) {
      return '';
    } else {
      return null;
    }
  }

  void _onPositionSubmitted(_) {
    FocusScope.of(context).requestFocus(_phoneFieldFocusNode);
  }

  void _onSavedPosition(String newValue) {
    _position = newValue;
  }

  Widget _buildEmailFormField() {
    final GooglePayload payload = widget.googlePayload;

    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.email),
      initialValue: payload.email,
      enabled: false,
    );
  }

  Widget _buildPhoneFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(
        labelText: qrLocale.phone,
        hintText: qrLocale.phoneExample,
      ),
      keyboardType: TextInputType.phone,
      validator: _validatePhone,
      focusNode: _phoneFieldFocusNode,
      onFieldSubmitted: (_) async => await _register(),
      onSaved: _onSavedPhone,
    );
  }

  void _onSavedPhone(String newValue) {
    _phone = newValue;
  }

  String _validatePhone(String value) {
    RegExp regExp = RegExp(r'^\+380\d{9}$');

    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return '';
    }
  }

  Widget _buildInfoWidget() {
    return Center(
      child: Text(
        qrLocale.checkYourPersonalData,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return AuthButton(
      title: qrLocale.createAccount,
      isButtonActive: _isCreateAccountButtonActive,
      onPressed: _register,
    );
  }

  Future<void> _register() async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
      try {
        await _signUpViaGoogle();
        _createRoute();
      } on QrStateException catch (e) {
        await _errorDialog('${qrLocale.stateException}: ${e.message}');
      } on UserIsAlreadyRegisteredException {
        await _userIsExistErrorDialog();
      } on PlatformException {
        await _errorDialog(qrLocale.checkConnection);
      } catch (e) {
        await _errorDialog('${qrLocale.unknownError}: ${e.runtimeType}');
      }
    }
  }

  Future<void> _signUpViaGoogle() async {
    final GooglePayload payload = widget.googlePayload;

    final registrationPayload = GoogleRegistrationPayload(
      _name,
      _position,
      payload.email,
      _phone,
      payload.googleId,
    );

    await _presenter.register(registrationPayload);
  }

  void _createRoute() {
    Navigator.of(context).pushAndRemoveUntil(
      InventoriesPage.buildPageRoute(),
      (_) => false,
    );
  }

  Future<void> _errorDialog(String info) async {
    await _showErrorDialog(
      context: context,
      errorMessage: info,
      onPressed: _returnToSignUpScreen,
    );
  }

  void _returnToSignUpScreen() {
    Navigator.of(context).pop();
  }

  Future<void> _userIsExistErrorDialog() async {
    await _showErrorDialog(
      context: context,
      errorMessage: qrLocale.userAlreadyRegistered,
      onPressed: _returnToLoginScreen,
    );
  }

  void _returnToLoginScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      AuthPage.buildPageRoute(),
      (_) => false,
    );
  }

  Future<void> _showErrorDialog({
    @required BuildContext context,
    @required String errorMessage,
    @required VoidCallback onPressed,
  }) async {
    assert(context != null || errorMessage != null);
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

  @override
  void dispose() {
    _phoneFieldFocusNode.dispose();
    super.dispose();
  }
}
