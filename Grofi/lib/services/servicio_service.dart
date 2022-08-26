import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiendas/models/models.dart';
import 'package:http/http.dart' as http;

class ServicioService extends ChangeNotifier {
  final String _baseUrl = 'flutter-grofi-default-rtdb.firebaseio.com';
  final List<Servicio> servicios = [];

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;
  late Servicio selectedServicio;

  ServicioService() {
    this.loadService();
  }

  Future<List<Servicio>> loadService() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'service.json');
    final resp = await http.get(url);

    final Map<String, dynamic> serviceMap = json.decode(resp.body);
    serviceMap.forEach((key, value) {
      final tempService = Servicio.fromMap(value);

      tempService.id = key;
      this.servicios.add(tempService);
    });

    this.isLoading = false;
    notifyListeners();

    return this.servicios;
  }

  Future saveOrCreateProduct(Servicio servicio) async {
    isSaving = true;
    notifyListeners();

    if (servicio.id == null) {
      //se crea
      await this.createService(servicio);
    } else {
      //Actualizar
      await this.updateService(servicio);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateService(Servicio servicio) async {
    final url = Uri.https(_baseUrl, 'service/${servicio.id}.json');
    final resp = await http.put(url, body: servicio.toJson());
    final decodeData = resp.body;

    final index =
        this.servicios.indexWhere((element) => element.id == servicio.id);
    this.servicios[index] = servicio;

    return servicio.id!;
  }

  Future<String> createService(Servicio servicio) async {
    final url = Uri.https(_baseUrl, 'service.json');
    final resp = await http.post(url, body: servicio.toJson());
    final decodeData = json.decode(resp.body);

    servicio.id = decodeData['name'];

    this.servicios.add(servicio);

    return "";
  }

  void updateSelectedServiceImage(String path) {
    this.selectedServicio.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dugkqzb49/image/upload?upload_preset=wsv4ii2s');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);

    final streamReponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamReponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) return null;

    this.newPictureFile = null;

    final decodeData = json.decode(resp.body);
    return decodeData['secure_url'];
  }

  Future<String> deleteServicio(Servicio servicio) async {
    isSaving = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'service/${servicio.id}.json');
    final resp = await http.delete(url);
    final decodeDate = json.decode(resp.body);

    final index =
        this.servicios.indexWhere((element) => element.id == servicio.id);
    this.servicios.removeAt(index);

    isSaving = false;
    notifyListeners();
    return servicio.id!;
  }
}
