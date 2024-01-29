import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cetis4/config/constants/constants.dart';
import 'package:cetis4/features/careers/providers/career_provider.dart';
import 'package:cetis4/features/grades/providers/grades_provider.dart';
import 'package:cetis4/features/groups/providers/groups_provider.dart';
import 'package:cetis4/features/profile/data/models/register.dart';
import 'package:cetis4/features/registrations/data/models/create_registration_model.dart';
import 'package:cetis4/features/registrations/screens/success_registration_screen.dart';
import 'package:cetis4/features/repositions/providers/reposition_provider.dart';
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
import 'package:hand_signature/signature.dart';

class RepositionFormScreen extends ConsumerStatefulWidget {
  final Registration registration;

  const RepositionFormScreen({required this.registration, super.key});

  @override
  RepositionFormScreenState createState() => RepositionFormScreenState();
}

class RepositionFormScreenState extends ConsumerState<RepositionFormScreen> {
  final formRepositionKey = GlobalKey<FormState>();

  TextEditingController curpController = TextEditingController();
  TextEditingController namesController = TextEditingController();
  TextEditingController surnamesController = TextEditingController();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cellphoneController = TextEditingController();

  List<CareerModel> _careers = [];
  String _selectedCareer = '';
  List<GradesModel> _grades = [];
  String _selectedGrade = '';
  List<GroupsModel> _groups = [];
  String _selectedGroup = '';
  List<TurnsModel> _turns = [];
  String _selectedTurn = '';
  bool loaded = false;

  bool hasSign = false;
  String signatureId = '';
  String title = 'Reposición';
  String _loadingStatusMessage = 'Cargando información';
  bool _formLoading = true;
  File?
      _selectedPhotoImageFile; // Variable para almacenar el archivo seleccionado
  File?
      _selectedVoucherImageFile; // Variable para almacenar el archivo seleccionado
  bool searching = true;
  bool _isFormEditable = false;
  /*  final SignatureController _signatureController = SignatureController(
      exportBackgroundColor: Colors.white, penStrokeWidth: 4); */
  final HandSignatureControl signatureControl = HandSignatureControl(
      smoothRatio: 0.65, threshold: 3.0, velocityRange: 2.0);
  bool blockVerticalScroll = false;
  bool enabledSendButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fillCatalogs(widget.registration).then((_) {
      populateForm(widget.registration);
    });
    _selectedCareer = widget.registration.career!.id!;
    _selectedGrade = widget.registration.grade!.id!;
    _selectedGroup = widget.registration.group!.id!;
    _selectedTurn = widget.registration.turn!.id!;
    _isFormEditable =
        !["PAYMENT_VALIDATED", "PRINTED"].contains(widget.registration.status);
  }

  fillCatalogs(Registration registration) async {
    final careers = await ref.read(careerRepositoryProvider).getCareers();
    final grades = await ref.read(gradeRepositoryProvider).getGrades();
    final groups = await ref.read(groupRepositoryProvider).getGroups();
    final turns = await ref.read(turnRepositoryProvider).getTurns();
    setState(() {
      _careers = careers;
      _grades = grades;
      _groups = groups;
      _turns = turns;
      _formLoading = false;
    });
  }

  checkAcceptedInfo(bool checked) {
    log(checked.toString());
    setState(() {
      enabledSendButton = !checked;
    });
  }

  populateForm(Registration registration) async {
    log(_selectedCareer);
    setState(() {
      _selectedCareer = registration.career!.id!;
      namesController.text = registration.names!;
      surnamesController.text = registration.surnames!;
      emailController.text = registration.email!;
      cellphoneController.text = registration.cellphone!;
      curpController.text = registration.curp!;
      registrationNumberController.text = registration.registrationNumber!;
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(children: [
          SingleChildScrollView(child: registrationForm()),
          _formLoading
              ? DatamexLoaderWidget(
                  loadingStatusMessage: _loadingStatusMessage,
                )
              : const SizedBox()
        ]),
      ),
    );
  }

  Widget _showDisabledFormNotice() {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: primaryColor),
      child: const Center(
        child: Text(
          'Su credencial se encuentra en proceso de impresión, no es posible editar sus datos.',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget registrationForm() {
    return Form(
      key: formRepositionKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _isFormEditable ? const SizedBox.shrink() : _showDisabledFormNotice(),
          const SizedBox(
            height: 10,
          ),
          DatamexTextFormField(
            labelText: 'Nombres',
            boxHeight: 1,
            controller: namesController,
            validate: true,
            enabled: _isFormEditable,
          ),
          DatamexTextFormField(
            labelText: 'Apellidos',
            boxHeight: 1,
            controller: surnamesController,
            validate: true,
            enabled: _isFormEditable,
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
            enabled: _isFormEditable,
          ),
          DatamexTextFormField(
            labelText: 'Correo',
            boxHeight: 1,
            validate: true,
            isEmail: true,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: _isFormEditable,
          ),
          DatamexTextFormField(
            labelText: 'Celular',
            boxHeight: 1,
            validate: true,
            minLength: 10,
            maxLength: 10,
            controller: cellphoneController,
            keyboardType: TextInputType.number,
            enabled: _isFormEditable,
          ),
          loaded
              ? lateLoadingForm()
              : const SizedBox(
                  height: 1,
                ),
        ],
      ),
    );
  }

  Widget lateLoadingForm() {
    return Column(
      children: <Widget>[
        preregistrationSchoolData(),
        photoCaptureSection(),
        voucherCaptureSection(),
        signatureCaptureOrView(),
        acceptInfoWidget(),
        formButtons()
      ],
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
        isEnabled: _isFormEditable,
      ),
      DatamexDropDownMenuWidget<GradesModel>(
        items: _grades,
        labelText: 'Grado',
        initialValue: _selectedGrade,
        onChanged: (selectedValue) {
          _selectedGrade = selectedValue.id;
        },
        isEnabled: _isFormEditable,
      ),
      DatamexDropDownMenuWidget<GroupsModel>(
        items: _groups,
        labelText: 'Grupo',
        initialValue: _selectedGroup,
        onChanged: (selectedValue) {
          _selectedGroup = selectedValue.id;
        },
        isEnabled: _isFormEditable,
      ),
      DatamexDropDownMenuWidget<TurnsModel>(
        items: _turns,
        labelText: 'Turno',
        initialValue: _selectedTurn,
        onChanged: (selectedValue) {
          _selectedTurn = selectedValue.id;
        },
        isEnabled: _isFormEditable,
      ),
    ]);
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
        _isFormEditable
            ? DatamexSignaturePad(controller: signatureControl)
            : Image.network(
                'https://drive.google.com/uc?id=${widget.registration.studentSignaturePath}')
      ],
    );
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

  void handlePhotoSelected(File? imageFile) async {
    setLoading(true);
    changeStatusMessage('Comprimiendo Foto');

    setState(() {
      _selectedPhotoImageFile = imageFile;
    });
    resetLoaderStatus();
  }

  void resetLoaderStatus() {
    setState(() {
      _formLoading = false;
      _loadingStatusMessage = 'Enviando datos!';
    });
  }

  void handleVoucherSelected(File? imageFile) {
    setState(() {
      _selectedVoucherImageFile = imageFile;
    });
  }

  Widget photoCaptureSection() {
    return Column(
      children: [
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Foto del alumno',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DatamexCameraWidget(
          onImageSelected: handlePhotoSelected,
          loadStatusCallback: setLoading,
          changeStatusMessageCallback: changeStatusMessage,
          imageId: widget.registration.studentPhotoPath,
          enabled: _isFormEditable,
        ),
      ],
    );
  }

  Widget voucherCaptureSection() {
    return Column(
      children: [
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Captura de voucher',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DatamexCameraWidget(
          onImageSelected: handleVoucherSelected,
          loadStatusCallback: setLoading,
          changeStatusMessageCallback: changeStatusMessage,
          imageId:
              _isFormEditable ? null : widget.registration.studentVoucherPath,
          enabled: _isFormEditable,
        ),
      ],
    );
  }

  Widget formButtons() {
    return _isFormEditable
        ? Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DatamexFormButton(
                    color: Colors.green.shade800,
                    onPress: () {
                      setLoading(true);
                      setState(() {
                        _loadingStatusMessage = 'Espere un momento';
                      });
                      handleForm(context, formRepositionKey);
                    },
                    label: 'Guardar',
                    icon: Icons.send_rounded,
                    enabled: enabledSendButton,
                  ),
                  DatamexFormButton(
                    color: Colors.red.shade800,
                    onPress: () {
                      Navigator.of(context).pop();
                    },
                    label: 'Cancelar',
                    icon: Icons.clear,
                  ),
                ],
              ),
              const SizedBox(
                height: 70,
              )
            ],
          )
        : SizedBox.shrink();
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

  handleForm(BuildContext ctx, GlobalKey<FormState> frmKey) async {
    if (!signatureControl.isFilled) {
      resetLoaderStatus();
      return notifyDialog(ctx, 'Debe ingresar una firma para continuar');
    }
    if (_selectedPhotoImageFile == null &&
        widget.registration.studentPhotoPath == null) {
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
        strokeWidth: 1.8,
        maxStrokeWidth: 1.8,
        format: ImageByteFormat.png,
        background: Colors.white);

    if (formRepositionKey.currentState!.validate()) {
      final id = widget.registration.id;
      final names = namesController.text;
      final surnames = surnamesController.text;
      final curp = curpController.text;
      final registrationNumber = registrationNumberController.text;
      final email = emailController.text;
      final cellphone = cellphoneController.text;
      CreateRegistrationModel formData = CreateRegistrationModel(
          id: id,
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
          registrationType: 'APP-REPOSITION');

      final response = await ref
          .read(repositionRepositoryProvider)
          .insertReposition(formData, _selectedPhotoImageFile,
              _selectedVoucherImageFile, firma);

      setLoading(false);
      print(response);

      if (response != null) {
        // Acciones adicionales si es necesario
        goToSuccess(); // Llama a la función para navegar a la pantalla de éxito.
      }

      return response;
    }
    resetLoaderStatus();
  }

  goToSuccess() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SuccessRegistrationScreen()));
  }
}
