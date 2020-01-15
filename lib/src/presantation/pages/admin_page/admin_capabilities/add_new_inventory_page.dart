import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/admin_page_presenters/admins_presenters/add_new_inventory_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/confirm_button.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';
import 'package:qr/src/presantation/widgets/no_scroll_behavior.dart';
import 'package:qr/src/presantation/widgets/without_error_text_form_field.dart';
import 'package:qr/src/utils/exceptions.dart';

class AddNewInventoryPage extends StatefulWidget {
  static const nameRoute = routes.addNewInventory;

  static PageRoute<AddNewInventoryPage> buildPageRoute() {
    return MaterialPageRoute<AddNewInventoryPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddNewInventoryPagePresenter(),
      child: AddNewInventoryPage(),
    );
  }

  @override
  _AddNewInventoryPageState createState() => _AddNewInventoryPageState();
}

class _AddNewInventoryPageState extends State<AddNewInventoryPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formStateKey = GlobalKey<FormState>();

  AddNewInventoryPagePresenter _presenter;

  FocusNode _nameFieldFocusNode = FocusNode();
  FocusNode _descriptionFieldFocusNode = FocusNode();

  bool _isAddNewInventoryButtonActive = false;

  String _id;
  String _name;
  String _description;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<AddNewInventoryPagePresenter>(context);
    return GestureDetector(
      onTap: _resetFocusNode,
      child: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return  Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(qrLocale.addNewInventoryToDB),
      ),
      body: Center(
        child: ScrollConfiguration(
          behavior: NoOverScrollBehavior(),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 480.0,
                maxHeight: 500.0,
              ),
              margin: EdgeInsets.symmetric(vertical: 42.0),
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Form(
                key: _formStateKey,
                onChanged: _onFormChanged,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildIdFormField(),
                    _buildNameFormField(),
                    _buildDescriptionFormField(),
                    SizedBox(height: 32.0),
                    _buildInfoWidget(),
                    SizedBox(height: 16.0),
                    _buildAddNewInventoryButton()
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

  void _onFormChanged() {
    bool isFormFieldValidated = _formStateKey.currentState.validate();
    if (_isAddNewInventoryButtonActive != isFormFieldValidated) {
      setState(
            () => _isAddNewInventoryButtonActive = isFormFieldValidated,
      );
    }
  }

  final _charCount = 20;

  Widget _buildIdFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.id),
      maxLength: _charCount,
      validator: _validateId,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: _onIdSubmitted,
      onSaved: _onSavedId,
    );
  }

  String _validateId(String value) {
    if (value.length < _charCount) {
      return '';
    } else {
      return null;
    }
  }

  void _onIdSubmitted(_) {
    FocusScope.of(context).requestFocus(_nameFieldFocusNode);
  }

  void _onSavedId(String newValue) {
    _id = newValue;
  }

  Widget _buildNameFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.name.toLowerCase()),
      focusNode: _nameFieldFocusNode,
      validator: _validateIsEmpty,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: _onNameSubmitted,
      onSaved: _onSavedName,
    );
  }

  void _onNameSubmitted(_) {
    FocusScope.of(context).requestFocus(_descriptionFieldFocusNode);
  }

  void _onSavedName(String newValue) {
    _name = newValue;
  }

  Widget _buildDescriptionFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.description),
      focusNode: _descriptionFieldFocusNode,
      validator: _validateIsEmpty,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      onSaved: _onSavedDescription,
    );
  }

  void _onSavedDescription(String newValue) {
    _description = newValue;
  }

  String _validateIsEmpty(String value) {
    if (value.isEmpty) {
      return '';
    } else {
      return null;
    }
  }

  Widget _buildInfoWidget() {
    return Center(
      child: Text(
        qrLocale.checkInventoryData,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAddNewInventoryButton() {
    return ConfirmButton(
      title: qrLocale.addNewInventory,
      isButtonActive: _isAddNewInventoryButtonActive,
      onPressed: _addNewInventory,
    );
  }

  Future<void> _addNewInventory() async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
      try {
        await _presenter.addNewInventoryToDatabase(
          id: _id,
          name: _name,
          description: _description,
        );
        _formStateKey.currentState.reset();
        _resetFocusNode();
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(qrLocale.successfullyInventoryAdded),
          ),
        );
      } on InventoryAlreadyExist {
        await _errorDialog(qrLocale.inventoryAlreadyExist);
      } catch (e) {
        await _errorDialog('${qrLocale.unknownError}: ${e.runtimeType}');
      }
    }
  }

  Future<void> _errorDialog(String info) async {
    await _showErrorDialog(
      errorMessage: info,
      onPressed: _returnToAddInventoryScreen,
    );
  }

  void _returnToAddInventoryScreen() {
    Navigator.of(context).pop();
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

  @override
  void dispose() {
    _nameFieldFocusNode.dispose();
    _descriptionFieldFocusNode.dispose();
    super.dispose();
  }
}
