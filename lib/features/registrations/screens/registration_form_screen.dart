import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cetis4/config/constants/constants.dart';
import 'package:cetis4/features/careers/providers/career_provider.dart';
import 'package:cetis4/features/grades/providers/grades_provider.dart';
import 'package:cetis4/features/groups/providers/groups_provider.dart';
import 'package:cetis4/features/profile/data/models/register.dart';
import 'package:cetis4/features/registrations/data/models/create_registration_model.dart';
import 'package:cetis4/features/registrations/providers/registration_provider.dart';
import 'package:cetis4/features/registrations/screens/success_registration_screen.dart';
import 'package:cetis4/features/turns/providers/turns_provider.dart';
import 'package:cetis4/utils/datamex_dropdown_widget.dart';
import 'package:cetis4/features/careers/data/models/careers.dart';
import 'package:cetis4/features/grades/data/models/grades.dart';
import 'package:cetis4/features/groups/data/models/groups.dart';
import 'package:cetis4/features/turns/data/models/turns.dart';
import 'package:cetis4/utils/datamex_form_button_widget.dart';
import 'package:cetis4/utils/datamex_photo_widget.dart';
import 'package:cetis4/utils/datamex_signature_widget.dart';
import 'package:cetis4/utils/textformfield_widget.dart';
import 'package:cetis4/utils/widgets/datamex_form_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_signature/signature.dart';

class RegistrationFormScreen extends ConsumerStatefulWidget {
  const RegistrationFormScreen({required this.curp, super.key});
  final String curp;

  @override
  RegistrationFormScreenState createState() => RegistrationFormScreenState();
}

class RegistrationFormScreenState
    extends ConsumerState<RegistrationFormScreen> {
  /* final formCurpKey = GlobalKey<FormBuilderState>(); */
  final formRegistrationKey = GlobalKey<FormState>();

  TextEditingController curpController = TextEditingController();
  TextEditingController namesController = TextEditingController();
  TextEditingController surnamesController = TextEditingController();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cellphoneController = TextEditingController();

  final HandSignatureControl signatureControl = HandSignatureControl(
      smoothRatio: 0.65, threshold: 3.0, velocityRange: 2.0);
  List<CareerModel> _careers = [];
  String _selectedCareer = '';
  List<GradesModel> _grades = [];
  String _selectedGrade = '';
  List<GroupsModel> _groups = [];
  String _selectedGroup = '';
  List<TurnsModel> _turns = [];
  String _selectedTurn = '';
  bool validCurp = false;
  String signatureId = '';
  String title = 'Nuevo registro';
  String _loadingStatusMessage = 'Cargando información';
  bool _formLoading = true;
  File?
      _selectedPhotoImageFile; // Variable para almacenar el archivo seleccionado
  File?
      _selectedVoucherImageFile; // Variable para almacenar el archivo seleccionado
  bool enabledSendButton = false;
  @override
  void initState() {
    super.initState();
    fillCatalogs();
  }

  fillCatalogs() async {
    final careers = await ref.read(careerRepositoryProvider).getCareers();
    final grades = await ref.read(gradeRepositoryProvider).getGrades();
    final groups = await ref.read(groupRepositoryProvider).getGroups();
    final turns = await ref.read(turnRepositoryProvider).getTurns();
    setState(() {
      _careers = careers;
      _grades = grades;
      _groups = groups;
      _turns = turns;
      curpController.text = widget.curp;
      validCurp = true;
      _formLoading = false;
    });
  }

  checkAcceptedInfo(bool checked) {
    setState(() {
      enabledSendButton = !checked;
    });
  }

  populateForm(Registration registration) {
    setState(() {
      curpController.text = widget.curp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(children: [
          SingleChildScrollView(
            child: registrationForm(),
          ),
          _formLoading
              ? DatamexLoaderWidget(
                  loadingStatusMessage: _loadingStatusMessage,
                )
              : const SizedBox()
        ]),
      ),
    );
  }

  Widget registrationForm() {
    return Form(
      key: formRegistrationKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          DatamexTextFormField(
            labelText: 'Nombres',
            boxHeight: 1,
            controller: namesController,
            validate: true,
          ),
          DatamexTextFormField(
            labelText: 'Apellidos',
            boxHeight: 1,
            controller: surnamesController,
            validate: true,
          ),
          DatamexTextFormField(
            labelText: 'C.U.R.P.',
            boxHeight: 1,
            enabled: false,
            controller: curpController,
            minLength: 18,
            maxLength: 18,
            validate: true,
          ),
          DatamexTextFormField(
            labelText: 'Matrícula',
            boxHeight: 1,
            controller: registrationNumberController,
          ),
          DatamexTextFormField(
            labelText: 'Correo',
            boxHeight: 1,
            validate: true,
            isEmail: true,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          DatamexTextFormField(
            labelText: 'Celular',
            boxHeight: 1,
            validate: true,
            minLength: 10,
            maxLength: 10,
            controller: cellphoneController,
            keyboardType: TextInputType.number,
          ),
          preregistrationSchoolData(),
          photoCaptureSection(),
          voucherCaptureSection(),
          signatureCaptureOrView(),
          acceptInfoWidget(),
          formButtons()
        ],
      ),
    );
  }

  Widget acceptInfoWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          tileColor: Colors.grey.shade300,
          activeColor: primaryColor,
          title: const FittedBox(
            fit: BoxFit.fill,
            child: Text(
                'ACEPTO QUE CON ESTA INFORMACIÓN SE \nIMPRIMA MI CREDENCIAL.'),
          ),
          value: enabledSendButton,
          onChanged: (value) => {
            setState(() {
              enabledSendButton = value!;
            })
          },
          controlAffinity: ListTileControlAffinity
              .leading, // Posiciona el checkbox a la izquierda del texto
        ),
      ],
    );
  }

  Widget formButtons() {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DatamexFormButton(
              color: Colors.green.shade800,
              icon: Icons.send_rounded,
              enabled: enabledSendButton,
              onPress: () {
                setLoading(true);
                setState(() {
                  _loadingStatusMessage = 'Espere un momento';
                });
                handleForm(context, formRegistrationKey);
              },
              label: 'Guardar',
            ),
            DatamexFormButton(
                color: Colors.red.shade800,
                onPress: () {
                  Navigator.of(context).pop();
                },
                label: 'Cancelar',
                icon: Icons.clear),
          ],
        ),
        const SizedBox(
          height: 70,
        )
      ],
    );
  }

  void notifyDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  goToSuccess() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SuccessRegistrationScreen()));
  }

  handleForm(BuildContext ctx, GlobalKey<FormState> frmKey) async {
    if (!signatureControl.isFilled) {
      resetLoaderStatus();
      return notifyDialog(ctx, 'Debe ingresar una firma para continuar');
    }
    if (_selectedPhotoImageFile == null) {
      resetLoaderStatus();
      return notifyDialog(
          ctx, 'Debe tomar una fotografía del alumno para continuar');
    }
    if (_selectedVoucherImageFile == null) {
      resetLoaderStatus();
      return notifyDialog(
          ctx, 'Debe tomar una fotografía del voucher para continuar');
    }
    var firma = await signatureControl.toImage(
        background: Colors.white,
        format: ImageByteFormat.png,
        maxStrokeWidth: 1.8,
        strokeWidth: 1.8); // _signatureController.toPngBytes();
    log('waaaa');

    if (formRegistrationKey.currentState!.validate()) {
      final names = namesController.text;
      final surnames = surnamesController.text;
      final curp = curpController.text;
      final registrationNumber = registrationNumberController.text;
      final email = emailController.text;
      final cellphone = cellphoneController.text;
      CreateRegistrationModel formData = CreateRegistrationModel(
          names: names,
          surnames: surnames,
          curp: curp,
          registrationNumber: registrationNumber,
          email: email,
          cellphone: cellphone,
          grade: _selectedGrade,
          group: _selectedGroup,
          turn: _selectedTurn,
          career: _selectedCareer,
          isReposition: '',
          registrationType: 'APP-NEW');

      final response = await ref
          .read(registrationRepositoryProvider)
          .insertRegistration(formData, _selectedPhotoImageFile,
              _selectedVoucherImageFile, firma);
      log('mi mi mi');

      setLoading(false);

      print(response);

      if (response != null && response is Map<String, dynamic>) {
        final registration = response['data']['registration'];
        final code = response['code'];
        if (code == 201 && registration != null) {
          // Acciones adicionales si es necesario
          goToSuccess(); // Llama a la función para navegar a la pantalla de éxito.
        }
      }
      return response;
    }
    resetLoaderStatus();
  }

  Widget signatureCaptureOrView() {
    return Column(
      children: [
        const Divider(),
        const Padding(padding: EdgeInsets.all(10)),
        const Text(
          'Firma',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        DatamexSignaturePad(controller: signatureControl)
      ],
    );
  }

  Widget preregistrationSchoolData() {
    return Column(children: [
      const Center(
        child: Text(
          'Información del plantel',
          style: TextStyle(fontSize: 20),
        ),
      ),
      DatamexDropDownMenuWidget<CareerModel>(
        items: _careers,
        labelText: 'Carrera',
        initialValue: _selectedCareer,
        onChanged: (selectedValue) {
          _selectedCareer = selectedValue.id;
        },
      ),
      DatamexDropDownMenuWidget<GradesModel>(
        items: _grades,
        labelText: 'Grado',
        initialValue: _selectedGrade,
        onChanged: (selectedValue) {
          _selectedGrade = selectedValue.id;
        },
      ),
      DatamexDropDownMenuWidget<GroupsModel>(
        items: _groups,
        labelText: 'Grupo',
        initialValue: _selectedGroup,
        onChanged: (selectedValue) {
          _selectedGroup = selectedValue.id;
        },
      ),
      DatamexDropDownMenuWidget<TurnsModel>(
        items: _turns,
        labelText: 'Turno',
        initialValue: _selectedTurn,
        onChanged: (selectedValue) {
          _selectedTurn = selectedValue.id;
        },
      ),
    ]);
  }

  void setLoading(bool load) {
    setState(() {
      _formLoading = load;
    });
  }

  void changeStatusMessage(String message) {
    setState(() {
      _loadingStatusMessage = message;
    });
  }

  void resetLoaderStatus() {
    setState(() {
      _formLoading = false;
      _loadingStatusMessage = 'Enviando datos!';
    });
  }

  void handlePhotoSelected(File? imageFile) async {
    setLoading(true);
    changeStatusMessage('Comprimiendo Foto');

    setState(() {
      _selectedPhotoImageFile = imageFile;
    });
    resetLoaderStatus();
  }

  void handleVoucherSelected(File? imageFile) {
    setState(() {
      _selectedVoucherImageFile = imageFile;
    });
  }

  Widget photoCaptureSection() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Foto del alumno',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        DatamexCameraWidget(
            onImageSelected: handlePhotoSelected,
            loadStatusCallback: setLoading,
            changeStatusMessageCallback: changeStatusMessage),
      ],
    );
  }

  Widget voucherCaptureSection() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Captura de voucher',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        DatamexCameraWidget(
          onImageSelected: handleVoucherSelected,
          loadStatusCallback: setLoading,
          changeStatusMessageCallback: changeStatusMessage,
        ),
      ],
    );
  }
}
