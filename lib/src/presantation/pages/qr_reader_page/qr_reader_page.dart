import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/qr_reader_presenter.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';

class QrReaderPage extends StatefulWidget {
  @override
  _QrReaderPageState createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  QrReaderPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QrReaderPagePresenter(),
      child: Builder(
        builder: _buildLayout,
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    _presenter = Provider.of<QrReaderPagePresenter>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(qrLocale.qrReader),
      ),
      drawer: QrDrawer(),
      body: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: Container(
          alignment: Alignment.center,
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16.0,
            children: <Widget>[
              RaisedButton(
                onPressed: scanTest,
                child: Text(qrLocale.scan),
              ),
              if (_presenter.inventory != null)
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  border:
                      TableBorder.all(color: Theme.of(context).dividerColor),
                  columnWidths: {
                    0: IntrinsicColumnWidth(),
                    1: FixedColumnWidth(200.0)
                  },
                  children: [
                    _buildTableRow(qrLocale.id, _presenter.inventory.id),
                    _buildTableRow(
                        qrLocale.name.toLowerCase(), _presenter.inventory.name),
                    _buildTableRow(qrLocale.info, _presenter.inventory.info),
                    _buildTableRow(qrLocale.status,
                        '${_presenter.inventory.status.status}'),
                  ],
                ),
              if (_presenter.inventory != null) _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String name, String value) {
    return TableRow(
      children: [
        _buildTableRowPadding(Text(name)),
        _buildTableRowPadding(Text(value)),
      ],
    );
  }

  Widget _buildTableRowPadding(Widget child) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: child);
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
        showChoiceDialog(
          context: context,
          message: qrLocale.returnInventory,
          onOk: () async => await _return(),
          onCancel: _returnToSignUpScreen,
        );
      } else if (inventory.status == InventoryStatus.free) {
        showChoiceDialog(
          context: context,
          message: qrLocale.takeInventory,
          onOk: () async => await _take(),
          onCancel: _returnToSignUpScreen,
        );
      } else if (inventory.status == InventoryStatus.lost) {
        showErrorDialog(
          context: context,
          errorMessage: qrLocale.lostInventory,
          onPressed: _returnToSignUpScreen,
        );
      }
    }
  }

  Future<void> _take() async {
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
    } finally {
      _returnToSignUpScreen();
    }
  }

  Future<void> _return() async {
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
    } finally {
      _returnToSignUpScreen();
    }
  }

  void _returnToSignUpScreen() {
    Navigator.of(context).pop();
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      print(barcode);
      var firebaseEndpoints;
      if (barcode.startsWith(firebaseEndpoints.prefixInventoryId)) {
        final inventoryId =
            barcode.replaceAll(firebaseEndpoints.prefixInventoryId, '').trim();

        await _presenter.getInventoryInfo(inventoryId);
      } else {
        throw Exception();
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showErrorDialog(
          context: context,
          errorMessage: 'The user did not grant the camera permission!',
          onPressed: _returnToSignUpScreen,
        );
      } else {
        throw e;
      }
    } on FormatException catch (e) {
      showErrorDialog(
        context: context,
        errorMessage: '$e',
        onPressed: _returnToSignUpScreen,
      );
    } catch (e) {
      showErrorDialog(
        context: context,
        errorMessage: 'Unknown error: $e',
        onPressed: _returnToSignUpScreen,
      );
    }
  }

  Future<void> scanTest() async {
    try {
      String inventoryId = 'DqXZhRKV1fPhMkBoA9qO';

      await _presenter.getInventoryInfo(inventoryId);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showErrorDialog(
          context: context,
          errorMessage: 'The user did not grant the camera permission!',
          onPressed: _returnToSignUpScreen,
        );
      } else {
        throw e;
      }
    } on FormatException catch (e) {
      showErrorDialog(
        context: context,
        errorMessage: '$e',
        onPressed: _returnToSignUpScreen,
      );
    } catch (e) {
      showErrorDialog(
        context: context,
        errorMessage: 'Unknown error: $e',
        onPressed: _returnToSignUpScreen,
      );
    }
  }
}
