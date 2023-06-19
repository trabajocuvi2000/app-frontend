import 'package:flutter/cupertino.dart';

class SpinnerStataus with ChangeNotifier {
  bool _spinnerStatus = true;

  bool get getSpinnerStatus => _spinnerStatus;

  Future<void> setSppinerStatus({required status}) async {
    _spinnerStatus = status;
    notifyListeners();
  }
}
