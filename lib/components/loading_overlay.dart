import 'package:flutter/material.dart';

class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Navigator.of(_context, rootNavigator: true).pop();
  }

  void show() {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (_) => _FullScreenLoader());
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
            child: Center(child: CircularProgressIndicator())));
  }
}
