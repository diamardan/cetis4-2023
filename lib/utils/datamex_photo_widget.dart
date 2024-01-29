import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DatamexCameraWidget extends StatefulWidget {
  const DatamexCameraWidget({
    Key? key,
    required this.onImageSelected,
    required this.loadStatusCallback,
    required this.changeStatusMessageCallback,
    this.imageId,
    this.enabled = true,
  }) : super(key: key);
  final Function(File?) onImageSelected;
  final Function(bool) loadStatusCallback;
  final Function(String) changeStatusMessageCallback;
  final String? imageId;
  final bool enabled;
  // Variable para mostrar el mensaje de progreso

  @override
  _DatamexCameraWidgetState createState() => _DatamexCameraWidgetState();
}

class _DatamexCameraWidgetState extends State<DatamexCameraWidget> {
  File? _selectedImageFile;
  bool showGoogleDriveImage = true;

  void _printImageSize(XFile? image, String label) {
    if (image != null) {
      final imageSize = File(image.path).lengthSync();
      print('$label: ${(imageSize / 1024).toStringAsFixed(2)} KB');
    }
  }

  Future<void> _takePhoto() async {
    widget.changeStatusMessageCallback('Abriendo cámara');
    widget.loadStatusCallback(true);
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    /* final image100 =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    final image50 =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final image25 =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    final image10 =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 10); */
    /* if (image100 != null &&
        image50 != null &&
        image25 != null &&
        image10 != null) {
      _printImageSize(image100, 'Image Quality 100');
      _printImageSize(image50, 'Image Quality 50');
      _printImageSize(image25, 'Image Quality 25');
      _printImageSize(image10, 'Image Quality 10');
    } */
    if (image != null) {
      widget.changeStatusMessageCallback('Comprimiendo imágen');
      // Realizar la compresión en segundo plano con un retraso mínimo para permitir la actualización de la interfaz de usuario
      await Future.delayed(const Duration(milliseconds: 100), () async {
        /* final compressedImageFile = await compressImage(XFile(image.path)); */
        setState(() {
          _selectedImageFile = File(image.path);
          showGoogleDriveImage = false;
        });
      });

      // Llama a la función de devolución de llamada con el archivo capturado
      widget.onImageSelected(_selectedImageFile);
      widget.loadStatusCallback(false);
    } else {
      widget.loadStatusCallback(
          false); // Finalizar la carga si no se capturó ninguna imagen
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
        showGoogleDriveImage = false;
      });

      // Llama a la función de devolución de llamada con el archivo seleccionado
      widget.onImageSelected(_selectedImageFile);
    }
  }

  Widget placeholder() {
    return Container(
      color: Colors.white54,
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: const Center(child: Text('No ha cargado imágen')),
    );
  }

  Widget imageGoogleDrivePreview() {
    return Stack(alignment: Alignment.bottomCenter, children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
              'https://drive.google.com/uc?id=${widget.imageId}')),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white54,
        ),
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: const Center(
            child: Text(
          'Foto almacenada',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
      )
    ]);
  }

  Widget choosePlaceHolder() {
    if (_selectedImageFile == null && widget.imageId == null) {
      return placeholder();
    }
    if (widget.imageId != null && showGoogleDriveImage) {
      return imageGoogleDrivePreview();
    }
    return const SizedBox.shrink();
  }

  Widget _buttons() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton.icon(
            onPressed: _takePhoto,
            icon: const Icon(Icons.camera),
            label: const Text('Tomar foto'),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.upload),
            label: const Text('Elegir imágen'),
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black12,
      child: Column(
        children: [
          choosePlaceHolder(),
          if (_selectedImageFile != null) Image.file(_selectedImageFile!),
          widget.enabled ? _buttons() : const SizedBox.shrink()
        ],
      ),
    );
  }
}
