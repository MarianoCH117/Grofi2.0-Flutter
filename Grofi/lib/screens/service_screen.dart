import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tiendas/providers/service_form_provider.dart';
import 'package:tiendas/services/services.dart';
import 'package:tiendas/ui/input_decorations.dart';
import 'package:tiendas/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final serviceService = Provider.of<ServicioService>(context);
    return ChangeNotifierProvider(
      create: (_) => ServiceFromProvider(serviceService.selectedServicio),
      child: _ServiceScreenBody(serviceService: serviceService),
    );
  }
}

class _ServiceScreenBody extends StatelessWidget {
  const _ServiceScreenBody({
    Key? key,
    required this.serviceService,
  }) : super(key: key);

  final ServicioService serviceService;

  @override
  Widget build(BuildContext context) {
    final serviceForm = Provider.of<ServiceFromProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
          //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
        children: [
          Stack(
            children: [
              ServiceImage(
                url: serviceService.selectedServicio.picture,
              ),
              Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final selection = await showMyDialogCam(context);
                      final picker = new ImagePicker();
                      final PickedFile? pickedFile = await picker.getImage(
                          source: (selection == 1)
                              ? ImageSource.camera
                              : ImageSource.gallery,
                          imageQuality: 100);
                      if (pickedFile == null) {
                        return;
                      }
                      serviceService
                          .updateSelectedServiceImage(pickedFile.path);
                    },
                  )),
            ],
          ),
          _ServiceFrom(),
          SizedBox(
            height: 100,
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
          child: serviceService.isSaving
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Icon(Icons.save_as_outlined),
          onPressed: serviceService.isSaving
              ? null
              : () async {
                  if (!serviceForm.isValidForm()) {
                    return;
                  }
                  final String? imageUrl = await serviceService.uploadImage();

                  if (imageUrl != null) serviceForm.servicio.picture = imageUrl;

                  await serviceService
                      .saveOrCreateProduct(serviceForm.servicio);

                  Navigator.of(context).pop();
                }),
    );
  }
}

class _ServiceFrom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final serviceFrom = Provider.of<ServiceFromProvider>(context);
    final servicio = serviceFrom.servicio;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: serviceFrom.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    initialValue: servicio.nombre,
                    onChanged: (value) => servicio.nombre = value,
                    validator: (value) {
                      if (value == null || value.length < 1)
                        return 'El nombre es obligatorio';
                    },
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre del servicio', labelText: 'Nombre:')),
                SizedBox(height: 30),
                TextFormField(
                    initialValue: '${servicio.precioT}',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        servicio.precioT = 0;
                      } else {
                        servicio.precioT = double.parse(value);
                        servicio.precioP = servicio.precioT / servicio.numPer;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: '\$\$\$', labelText: 'Precio del servicio:')),
                SizedBox(height: 30),
                TextFormField(
                    initialValue: '${servicio.numPer}',
                    onChanged: (value) {
                      if (int.tryParse(value) == null) {
                        servicio.numPer = 0;
                      } else {
                        servicio.numPer = int.parse(value);
                        servicio.precioP = servicio.precioT / servicio.numPer;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: '###', labelText: 'Numero de personas:')),
                SizedBox(height: 30),
                TextFormField(
                    initialValue: '${servicio.diaP}',
                    onChanged: (value) {
                      if (int.tryParse(value) == null) {
                        servicio.diaP = 0;
                      } else {
                        servicio.diaP = int.parse(value);
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: '###', labelText: 'Dia de pago:')),
                SizedBox(height: 30),
                SwitchListTile.adaptive(
                    value: servicio.activo,
                    title: Text('Activo'),
                    onChanged: serviceFrom.updateAvailability),
                SizedBox(
                  height: 30,
                )
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
                blurRadius: 5)
          ]);
}
