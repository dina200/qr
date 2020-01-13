import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/qr_reader_page_presenter.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';
import 'package:qr/src/presantation/widgets/inventory_table.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';

class QrReaderPage extends StatefulWidget {
  static const nameRoute = routes.qrReader;

  static PageRoute<QrReaderPage> buildPageRoute() {
    return MaterialPageRoute<QrReaderPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QrReaderPagePresenter(),
      child: QrReaderPage(),
    );
  }

  @override
  _QrReaderPageState createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  QrReaderPagePresenter _presenter;
  String _barcode = '';

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<QrReaderPagePresenter>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(qrLocale.qrReader),
      ),
      drawer: QrDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(qrLocale.scan.toUpperCase()),
        onPressed: scan,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: Container(
          alignment: Alignment.center,
          child: _presenter.inventory != null
              ? _buildInventoryInfoTable()
              : _buildInfoWidget(),
        ),
      ),
    );
  }

  Widget _buildInfoWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (_barcode.isNotEmpty)
          Text(
            '${qrLocale.unknownInfo} :\n $_barcode',
            textAlign: TextAlign.center,
          ),
        if (_barcode.isNotEmpty) SizedBox(height: 16.0),
        Text(
          qrLocale.pressScanButton,
        ),
      ],
    );
  }

  Widget _buildInventoryInfoTable() {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16.0,
      children: <Widget>[
        InventoryTable(inventory: _presenter.inventory),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildActionButton() {
    final inventory = _presenter.inventory;
    if (inventory.status == InventoryStatus.lost) {
      return Text(qrLocale.lostInventory);
    } else if (inventory.status == InventoryStatus.taken &&
        inventory.statistic.last.userId != _presenter.user.id) {
      return Text(qrLocale.takenInventory);
    }

    String nameButton = '';
    if (inventory.status == InventoryStatus.taken) {
      nameButton = qrLocale.retrieve;
    } else if (inventory.status == InventoryStatus.free) {
      nameButton = qrLocale.take;
    }
    return RaisedButton(
      onPressed: _takeOrReturnInventory,
      child: Text(nameButton),
    );
  }

  Future<void> _takeOrReturnInventory() async {
    final inventory = _presenter.inventory;

    if (inventory != null) {
      if (inventory.status == InventoryStatus.taken) {
        _showChoiceDialog(
          context: context,
          message: qrLocale.returnInventory,
          onOk: () async => await _return(),
          onCancel: _returnToSignUpScreen,
        );
      } else if (inventory.status == InventoryStatus.free) {
        _showChoiceDialog(
          context: context,
          message: qrLocale.takeInventory,
          onOk: () async => await _take(),
          onCancel: _returnToSignUpScreen,
        );
      } else if (inventory.status == InventoryStatus.lost) {
        _showErrorDialog(
          context: context,
          errorMessage: qrLocale.lostInventory,
          onPressed: _returnToSignUpScreen,
        );
      }
    }
  }

  Future<bool> _showChoiceDialog({
    @required BuildContext context,
    @required String message,
    @required VoidCallback onOk,
    @required VoidCallback onCancel,
  }) async {
    assert(context != null || message != null);
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

  Future<void> _take() async {
    _returnToSignUpScreen();
    try {
      await _presenter.takeInventory();
      _presenter.clearInventoryInfo();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(qrLocale.successfullyTaken),
        ),
      );
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _return() async {
    _returnToSignUpScreen();
    try {
      await _presenter.returnInventory();
      _presenter.clearInventoryInfo();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(qrLocale.successfullyReturned),
        ),
      );
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  void _returnToSignUpScreen() {
    Navigator.of(context).pop();
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();

      await _presenter.getInventoryInfo(barcode.trim());

      if (_barcode.isNotEmpty) {
        setState(() {
          _barcode = _presenter.inventory == null ? barcode : '';
        });
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showErrorDialog(
          context: context,
          errorMessage: qrLocale.notGrantCameraPermission,
          onPressed: _returnToSignUpScreen,
        );
      } else {
        throw e;
      }
    } on FormatException catch (e) {
      print('QrReaderPage, FormatException: $e');
    } catch (e) {
      print('QrReaderPage, Unknown error: $e');
    }
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

//  Future<void> scanTest() async {
//    try {
//      String inventoryId = 'DqXZhRKV1fPhMkBoA9qO';//
//      await _presenter.getInventoryInfo(inventoryId);
//    } on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        _showErrorDialog(
//          context: context,
//          errorMessage: 'The user did not grant the camera permission!',
//          onPressed: _returnToSignUpScreen,
//        );
//      } else {
//        throw e;
//      }
//    } on FormatException catch (e) {
//      _showErrorDialog(
//        context: context,
//        errorMessage: '$e',
//        onPressed: _returnToSignUpScreen,
//      );
//    } catch (e) {
//      _showErrorDialog(
//        context: context,
//        errorMessage: 'Unknown error: $e',
//        onPressed: _returnToSignUpScreen,
//      );
//    }
//  }
}
