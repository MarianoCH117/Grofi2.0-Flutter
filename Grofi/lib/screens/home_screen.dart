import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiendas/screens/screens.dart';
import 'package:tiendas/services/services.dart';
import 'package:tiendas/widgets/widgets.dart';

import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final serviceService = Provider.of<ServicioService>(context);
    if (serviceService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text("Servicios"),
      ),
      body: ListView.builder(
          itemCount: serviceService.servicios.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                serviceService.selectedServicio =
                    serviceService.servicios[index].copy();
                Navigator.pushNamed(context, 'service');
              },
              onLongPress: () async {
                final selection = await showMyDialogDelete(context);
                serviceService.selectedServicio =
                    serviceService.servicios[index].copy();
                (selection == 1)
                    ? await serviceService
                        .deleteServicio(serviceService.selectedServicio)
                    : null;
              },
              child: ServiciosCard(
                servicio: serviceService.servicios[index],
              ))),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          serviceService.selectedServicio = new Servicio(
              activo: false,
              diaP: 0,
              nombre: '',
              numPer: 0,
              precioP: 0,
              precioT: 0);
          Navigator.pushNamed(context, 'service');
        },
      ),
    );
  }
}
