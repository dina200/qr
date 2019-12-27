import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/qr_drawer.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  String inventoryCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Page'),
      ),
      drawer: QrDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(onPressed: scan, child: Text('Scan')),
            Text(inventoryCode ?? ''),
          ],
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      print(barcode);
      if(barcode.startsWith('"id"'))
      {setState(() => inventoryCode = barcode);}
      else {
        throw Exception();
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showInfoDialog(
          context: context,
          errorMessage: 'The user did not grant the camera permission!',
          onPressed: () => Navigator.of(context).pop(),
        );
      } else {
        throw e;
      }
    } on FormatException {
      showInfoDialog(
        context: context,
        errorMessage:
            'User returned using the "back"-button before scanning anything. Result',
        onPressed: () => Navigator.of(context).pop(),
      );
    } catch (e) {
      showInfoDialog(
        context: context,
        errorMessage: 'Unknown error: $e',
        onPressed: () => Navigator.of(context).pop(),
      );
    }
  }
}
