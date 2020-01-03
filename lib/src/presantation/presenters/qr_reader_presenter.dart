import 'package:flutter/widgets.dart';

class QrReaderPagePresenter with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
}
