import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/qr_reader_presenter.dart';
import 'package:qr/src/utils/firebase_endpoints.dart' as firebaseEndpoints;
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
    return ChangeNotifierProvider(
      create: (_) => QrReaderPagePresenter(),
      child: Builder(
        builder: _buildLayout,
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    final presenter = Provider.of<QrReaderPagePresenter>(context);
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
              child: Text(qrLocale.scan),
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
      if (barcode.startsWith(firebaseEndpoints.prefixInventoryId)) {
        setState(() {
          inventoryCode = barcode.replaceAll(firebaseEndpoints.prefixInventoryId, '').trim();
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
