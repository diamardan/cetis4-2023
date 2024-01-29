import 'dart:async';
import 'dart:developer';

import 'package:cetis4/config/network/dio_exceptions.dart';
import 'package:cetis4/features/profile/data/models/register.dart';
import 'package:cetis4/features/registrations/providers/registration_provider.dart';
import 'package:cetis4/features/registrations/screens/registration_form_screen.dart';
import 'package:cetis4/features/repositions/screens/reposition_form_screen.dart';
import 'package:cetis4/utils/alert_dialog.dart';
import 'package:cetis4/utils/textformfield_widget.dart';
import 'package:cetis4/utils/widgets/datamex_form_loader_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FindCurpRegistrationScreen extends ConsumerStatefulWidget {
  const FindCurpRegistrationScreen({required this.type, super.key});
  final String type;
  @override
  FindCurpRegistrationScreenState createState() =>
      FindCurpRegistrationScreenState();
}

class FindCurpRegistrationScreenState
    extends ConsumerState<FindCurpRegistrationScreen> {
  final formCurpKey = GlobalKey<FormState>();
  TextEditingController curpController = TextEditingController();
  bool validCurp = false;
  bool isLoading = false;
  String loadingStatusMessage = 'Buscando';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Buscar C.U.R.P.')),
        body: Stack(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(child: curpForm())),
          isLoading
              ? DatamexLoaderWidget(loadingStatusMessage: loadingStatusMessage)
              : const SizedBox(),
        ]));
  }

  Widget curpForm() {
    return Form(
      key: formCurpKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            DatamexTextFormField(
              labelText: 'C.U.R.P',
              boxHeight: 1,
              controller: curpController,
              maxLength: 18,
              minLength: 18,
              validate: true,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton.icon(
                  label: const Text('Buscar'),
                  icon: const Icon(Icons.search),
                  onPressed: findRegistrationByCurp),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> showRegistrationAlertDialog(
      {String title = 'Titulo', String message = 'message'}) async {
    // Utiliza Completer para esperar la respuesta del usuario
    Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: FittedBox(child: Text(title)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Cierra el AlertDialog y completa con true
                Navigator.pop(context);
                completer.complete(true);
              },
              child: const Text("Aceptar"),
            ),
            TextButton(
              onPressed: () {
                // Cierra el AlertDialog y completa con false
                Navigator.pop(context);
                completer.complete(false);
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );

    // Devuelve el futuro que se completará con la respuesta del usuario
    return completer.future;
  }

  goRepositionForm(Registration registration) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RepositionFormScreen(
                  registration: registration,
                )));
  }

  goRegistrationForm() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrationFormScreen(
                  curp: curpController.text,
                )));
  }

  Future<void> findRegistrationByCurp() async {
    if (!formCurpKey.currentState!.validate()) {
      return; // Salir de la función si el formulario no es válido
    }
    try {
      setLoading(true);

      final registrations = ref.read(registrationRepositoryProvider);

      final registration =
          await registrations.findRegistration(curpController.text);
      setLoading(false);
      if (widget.type == "NEW") {
        if (registration.id != null) {
          bool accepted = await showRegistrationAlertDialog(
              title: 'Registro encontrado',
              message:
                  "El registro ya existe en la base de datos. \n Desea continuar el proceso como 'REPOSICIÓN' ?");
          if (accepted) {
            goRepositionForm(registration);
          }
        } else {
          goRegistrationForm();
        }
      }
      if (widget.type == "REPOSITION") {
        if (registration.id == null) {
          bool accepted = await showRegistrationAlertDialog(
              title: 'Registro no encontrado !',
              message: 'Debe comenzar el trámite de NUEVO REGISTRO');
          if (accepted) {
            Navigator.of(context).pop();
            /* goRegistrationForm(); */
          }
        } else {
          goRepositionForm(registration);
        }
      } /* else {
        if (widget.type == "NEW") {
          bool accepted = await showRegistrationAlertDialog(title: );
          if (accepted) {
            goRepositionForm(registration);
          }
        }
      } */
    } catch (e) {
      setLoading(false);
      // Si es un error de tiempo de espera, muestra el AlertDialog
      await NotifyUI.showBasic(
        context,
        "Timeout",
        "Se ha excedido el tiempo de espera del servidor.",
      );
    }
  }

  setLoading(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  showError(DioException e) {
    final dioError = DioExceptions.fromDioError(e);
    NotifyUI.showBasic(context, 'Alerta', dioError.toString());
  }
}
