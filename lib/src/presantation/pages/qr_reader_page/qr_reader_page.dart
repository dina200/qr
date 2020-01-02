import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';

class QrReaderPage extends StatefulWidget {
  @override
  _QrReaderPageState createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage> {
  String inventoryCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.qrReader),
      ),
      drawer: QrDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: scan,
              child: Text('Scan'),
            ),
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
      if (barcode.startsWith('QrHelper')) {
        setState(() {
          inventoryCode = barcode.replaceAll('QrHelper', '').trim();
        });
      } else {
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
    } on FormatException catch (e) {
      showInfoDialog(
        context: context,
        errorMessage: '$e',
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
