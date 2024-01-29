import 'package:cetis4/config/constants/constants.dart';
import 'package:cetis4/utils/datamex_form_button_widget.dart';
import 'package:flutter/material.dart';

class SuccessRegistrationScreen extends StatelessWidget {
  const SuccessRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 60, 20, 0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: const Icon(
                  Icons.check_circle,
                  size: 120,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                            /* 'FINALIZASTE TU REGISTRO CON ÉXITO, FAVOR DE PASAR A PLANTEL PARA ENTREGA DE LA CREDENCIAL DESPUÉS DE 3 DÍAS HABILES PRESENTANDO TU VOUCHER ORIGINAL DE PAGO.' */
                            '¡FELICIDADES! TU REGISTRO FUÉ CONCLUIDO.\n\nTU CREDENCIAL SE ENVIARÁ A PLANTEL.\n\nUN CODIGO QR SE ENVIARA AL CORREO QUE REGISTRASTE PARA QUE PUEDAS INGRESAR A LA APP.'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DatamexFormButton(
                          color: primaryColor,
                          onPress: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          label: 'Salir',
                          icon: Icons.exit_to_app,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 120,
              )
            ],
          ),
        ),
      ),
    );
  }
}
