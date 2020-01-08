import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/qr_reader_presenter.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';

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
      body: Center(
        child: Column(
          children: <Widget>[
            Text(_presenter.inventory != null
                ? _presenter.inventory.toString()
                : ''),
            RaisedButton(
              onPressed: scan,
              child: Text(qrLocale.scan),
            ),
            RaisedButton(
              onPressed: testReturnAndTakeInventory,
              child: Text('TEST'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> testReturnAndTakeInventory() async {
    final inventory = _presenter.inventory;

    if (inventory != null) {
      if (inventory.status == InventoryStatus.taken) {
        showChoiceDialog(
          context: context,
          message: qrLocale.returnInventory,
          onOk: () async => await _return(inventory),
          onCancel: _returnToSignUpScreen,
        );
      } else if (inventory.status == InventoryStatus.free) {
        showChoiceDialog(
          context: context,
          message: qrLocale.takeInventory,
          onOk: () async => await _take(inventory),
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

  Future<void> _return(Inventory inventory) async {
    try {
      await _presenter.returnInventory(inventory.id);
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    } finally {
      _returnToSignUpScreen();
    }
  }

  Future<void> _take(Inventory inventory) async {
    try {
      await _presenter.takeInventory(inventory.id);
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    } finally {
      _returnToSignUpScreen();
    }
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

  void _returnToSignUpScreen() {
    Navigator.of(context).pop();
  }

//  Future<void> removeStat() async {
//    await _presenter.removeInventoryStatistic('DqXZhRKV1fPhMkBoA9qO');
//  }
//
//  Future<void> addUserToAdmin() async {
//    await _presenter.addUserToAdmins('BfsZ8OoOQ9Ob6RU9gDsx4OCQVsM2');
//  }
//
//  Future<void> removeUserFromAdmin() async {
//    await _presenter.removeUserFromAdmins('BfsZ8OoOQ9Ob6RU9gDsx4OCQVsM2');
//  }

//  Future<void> changeInvStat() async {
//    await _presenter.setInventoryStatus(
//
//       'rFkPWZEmku9Phhjrn4ln', InventoryStatus.lost,
//    );
//  }

//  Future<void> removeInv() async {
//    await _presenter.removeInventoryFromDatabase(
//       'ITwdG5lWoiIjQwWmmdzF',
//    );
//  }

//  Future<void> addInv() async {
//    await _presenter.addNewInventoryToDatabase(
//        id: 'ITwdG5lWoiIjQwWmmdzF',
//        name: 'Button',
//        info: 'NEW BUTTON',
//    );
//  }

//  Future<void> testUserHistory() async {
////    await _presenter.getUserHistory('r7V3zNSeSYPUKAtL5mfcMXqwz8H2');
//    await _presenter.getTakenInventoriesByUser('r7V3zNSeSYPUKAtL5mfcMXqwz8H2');
//    await _presenter.getAllInventoriesInfo();
//    print(_presenter.inventories);
//  }

//  Future<void> testUser() async {
//    try {
//      await _presenter.getUserInfo('BfsZ8OoOQ9Ob6RU9gDsx4OCQVsM2');
//      print(_presenter.anotherUser);
//    } catch (e) {
//      _scaffoldKey.currentState.showSnackBar(SnackBar(
//        content: Text(e.toString()),
//      ));
//    }
//  }

//  Future<void> testUsers() async {
//  await _presenter.getAllUser();
//    print(_presenter.users);
//  }

//  Future<void> testInvs() async {
////   await _presenter.getCurrentUserHistory();
//   await _presenter.getCurrentUserTakenInventories();
//
//    print(_presenter.inventories);
//  }

//  Future<void> testUser() async {
//    final user = _presenter.user;
//
//    print(user);
//  }

//  Future scanTest() async {
//    try {
//      String inventoryId = 'DqXZhRKV1fPhMkBoA9qO';
//
//      await _presenter.getInventoryInfo(inventoryId);
//    } on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        showErrorDialog(
//          context: context,
//          errorMessage: 'The user did not grant the camera permission!',
//          onPressed: _returnToSignUpScreen,
//        );
//      } else {
//        throw e;
//      }
//    } on FormatException catch (e) {
//      showErrorDialog(
//        context: context,
//        errorMessage: '$e',
//        onPressed: _returnToSignUpScreen,
//      );
//    } catch (e) {
//      showErrorDialog(
//        context: context,
//        errorMessage: 'Unknown error: $e',
//        onPressed: _returnToSignUpScreen,
//      );
//    }
//  }
//
}
