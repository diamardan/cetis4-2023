abstract class CommonResponse {
  String get id;
  String get name;
  int? get position;
}

class IndividualResponse extends CommonResponse {
  @override
  String get id => '1';

  @override
  String get name => 'INDIVIDUAL';

  @override
  int? get position => 1;
}

class ConFiltrosResponse extends CommonResponse {
  @override
  String get id => '2';

  @override
  String get name => 'CON FILTROS';

  @override
  int? get position => 2;
}

class MasivoResponse extends CommonResponse {
  @override
  String get id => '3';

  @override
  String get name => 'MASIVO';

  @override
  int? get position => 3;
}
