class Curso {
  final int? id;
  final String nombre;
  final String docente;
  final int creditos;
  final String ciclo;
  final String colorHex;
  final String horario;

  const Curso({
    this.id,
    required this.nombre,
    required this.docente,
    required this.creditos,
    required this.ciclo,
    this.colorHex = '#1A365D',
    required this.horario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'docente': docente,
      'creditos': creditos,
      'ciclo': ciclo,
      'colorHex': colorHex,
      'horario': horario,
    };
  }

  factory Curso.fromMap(Map<String, dynamic> map) {
    return Curso(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      docente: map['docente'] as String,
      creditos: map['creditos'] as int,
      ciclo: map['ciclo'] as String,
      colorHex: map['colorHex'] as String? ?? '#1A365D',
      horario: map['horario'] as String,
    );
  }

  Curso copyWith({
    int? id,
    String? nombre,
    String? docente,
    int? creditos,
    String? ciclo,
    String? colorHex,
    String? horario,
  }) {
    return Curso(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      docente: docente ?? this.docente,
      creditos: creditos ?? this.creditos,
      ciclo: ciclo ?? this.ciclo,
      colorHex: colorHex ?? this.colorHex,
      horario: horario ?? this.horario,
    );
  }
}
