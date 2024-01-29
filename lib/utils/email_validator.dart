bool isEmailValid(String email) {
  // Expresión regular para verificar el formato de un correo electrónico
  final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

  return emailRegExp.hasMatch(email);
}
