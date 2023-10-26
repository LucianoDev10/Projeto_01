import 'package:flutter/material.dart';
import 'package:projeto_01_teste/utils/navs.dart';

alerta(BuildContext context, String msg, {Widget? page}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text("Aviso"),
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Ok"),
              onPressed: () {
                if (page != null) {
                  push(context, page);
                } else {
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      );
    },
  );
}
