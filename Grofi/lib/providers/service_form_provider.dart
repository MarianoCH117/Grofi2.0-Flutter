import 'package:flutter/material.dart';
import 'package:tiendas/models/models.dart';

class ServiceFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Servicio servicio;

  ServiceFromProvider(this.servicio);

  updateAvailability(bool value) {
    print(value);
    this.servicio.activo = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
