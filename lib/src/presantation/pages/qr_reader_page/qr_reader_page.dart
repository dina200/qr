import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/qr_localizations.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
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

  QrLocalizations get qrLocale => QrLocalizations.of(context);

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<QrReaderPagePresenter>(context);
    return GestureDetector(
      onTap: _resetFocusNode,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(qrLocale.qrHelper),
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
      ),
    );
  }

  void _resetFocusNode() => FocusScope.of(context).requestFocus(FocusNode());

  Widget _buildInfoWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          qrLocale.pressScanButton,
          textAlign: TextAlign.center,
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
          message: qrLocale.returnInventory,
          onOk: () async => await _return(),
          onCancel: _returnToQrScreen,
        );
      } else if (inventory.status == InventoryStatus.free) {
        _showChoiceDialog(
          message: qrLocale.takeInventory,
          onOk: () async => await _take(),
          onCancel: _returnToQrScreen,
        );
      } else if (inventory.status == InventoryStatus.lost) {
        _showErrorDialog(
          errorMessage: qrLocale.lostInventory,
          onPressed: _returnToQrScreen,
        );
      }
    }
  }

  Future<bool> _showChoiceDialog({
    @required String message,
    @required VoidCallback onOk,
    @required VoidCallback onCancel,
  }) async {
    assert(message != null);
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
    _returnToQrScreen();
    try {
      await _presenter.takeInventory();
      _presenter.clearInventoryInfo();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(qrLocale.successfullyTaken),
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

  Future<void> _return() async {
    _returnToQrScreen();
    try {
      await _presenter.returnInventory();
      _presenter.clearInventoryInfo();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(qrLocale.successfullyReturned),
        ),
      );
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      await _presenter.getInventoryInfo(barcode.trim());
      if (_presenter.inventory == null) {
        _showInventoryNotExistErrorDialog(barcode);
      }
    } on PlatformException catch (e) {
      if (e.code == 'error') {
        _showErrorDialog(
          errorMessage: qrLocale.invalidData,
          onPressed: _returnToQrScreen,
        );
      }
      else if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showErrorDialog(
          errorMessage: qrLocale.notGrantCameraPermission,
          onPressed: _returnToQrScreen,
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

  void _returnToQrScreen() {
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

  Future<void> _showInventoryNotExistErrorDialog(String scanInfo) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Text(
                '${qrLocale.unknownInfo} :',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle,
              ),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                ),
                controller: TextEditingController(text: scanInfo),
                readOnly: true,
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(qrLocale.ok),
              onPressed: _returnToQrScreen,
            ),
          ],
        );
      },
    );
  }

//  Future<void> scanTest() async {
//    String inventoryId = 'DqXZhRKVsdfs1fPhMkBoA9qO';
//    await _presenter.getInventoryInfo(inventoryId);
//    if (_presenter.inventory == null) {
//      _showInventoryNotExistErrorDialog(inventoryId);
//    }
//  }
}
