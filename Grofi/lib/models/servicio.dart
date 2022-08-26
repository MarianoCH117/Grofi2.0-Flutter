// To parse this JSON data, do
//
//     final servicio = servicioFromMap(jsonString);

import 'dart:convert';

class Servicio {
  Servicio(
      {required this.activo,
      required this.diaP,
      required this.nombre,
      required this.numPer,
      this.picture,
      required this.precioP,
      required this.precioT,
      this.id});

  bool activo;
  int diaP;
  String nombre;
  int numPer;
  String? picture;
  double precioP;
  double precioT;
  String? id;

  factory Servicio.fromJson(String str) => Servicio.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Servicio.fromMap(Map<String, dynamic> json) => Servicio(
        activo: json["activo"],
        diaP: json["diaP"],
        nombre: json["nombre"],
        numPer: json["numPer"],
        picture: json["picture"],
        precioP: json["precioP"].toDouble(),
        precioT: json["precioT"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "activo": activo,
        "diaP": diaP,
        "nombre": nombre,
        "numPer": numPer,
        "picture": picture,
        "precioP": precioP,
        "precioT": precioT,
      };

  Servicio copy() => Servicio(
        activo: this.activo,
        diaP: this.diaP,
        nombre: this.nombre,
        numPer: this.numPer,
        picture: this.picture,
        precioP: this.precioP,
        precioT: this.precioT,
        id: this.id,
      );
}
