import 'package:cetis4/config/constants/constants.dart';
import 'package:cetis4/features/registrations/screens/registration_form_screen.dart';
import 'package:cetis4/features/repositions/screens/reposition_form_screen.dart';
import 'package:cetis4/utils/screens/credential_process_find_curp_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CredentialProcessScreen extends StatefulWidget {
  const CredentialProcessScreen({super.key});

  @override
  State<CredentialProcessScreen> createState() =>
      _CredentialProcessScreenState();
}

class _CredentialProcessScreenState extends State<CredentialProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _button(
                    label: 'Nuevo registro',
                    icon: Icons.new_label,
                    backgroundColor: Colors.blue,
                    route: 'new'),
                _button(
                    label: 'Reposición', icon: Icons.redo, route: 'reposition')
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _button(
      {String label = '',
      IconData icon = Icons.abc,
      Color backgroundColor = primaryColor,
      String route = 'new'}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
          onPressed: () {
            switch (route) {
              case 'new':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FindCurpRegistrationScreen(
                              type: 'NEW',
                            )));
                break;
              case 'reposition':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FindCurpRegistrationScreen(
                              type: 'REPOSITION',
                            )));
                break;
            }
          },
          icon: Icon(icon),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white),
          )),
    );
  }
}
