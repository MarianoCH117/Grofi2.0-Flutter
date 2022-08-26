import 'package:flutter/material.dart';

dynamic showMyDialogDelete(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        title: Text('Esta seguro de querer eliminar el servicio'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar',
                style: TextStyle(fontSize: 17, color: Colors.indigoAccent)),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
          TextButton(
            child: const Text('Eliminar',
                style: TextStyle(fontSize: 17, color: Colors.indigo)),
            onPressed: () {
              Navigator.of(context).pop(1);
            },
          ),
        ],
      );
    },
  );
}
