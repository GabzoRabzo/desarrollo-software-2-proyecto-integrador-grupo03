class Tarea {
  final int? id;
  final int cursoId;
  final String titulo;
  final String descripcion;
  final DateTime fechaEntrega;
  final String prioridad; // 'Alta', 'Media', 'Baja'
  final bool completada;
  final int horasEstimadas;
  final String? evidenciaPath;

  const Tarea({
    this.id,
    required this.cursoId,
    required this.titulo,
    required this.descripcion,
    required this.fechaEntrega,
    this.prioridad = 'Media',
    this.completada = false,
    this.horasEstimadas = 2,
    this.evidenciaPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cursoId': cursoId,
      'titulo': titulo,
      'descripcion': descripcion,
      'fechaEntrega': fechaEntrega.toIso8601String(),
      'prioridad': prioridad,
      'completada': completada ? 1 : 0,
      'horasEstimadas': horasEstimadas,
      'evidenciaPath': evidenciaPath,
    };
  }

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'] as int?,
      cursoId: map['cursoId'] as int,
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      fechaEntrega: DateTime.parse(map['fechaEntrega'] as String),
      prioridad: map['prioridad'] as String? ?? 'Media',
      completada: (map['completada'] as int) == 1,
      horasEstimadas: map['horasEstimadas'] as int? ?? 2,
      evidenciaPath: map['evidenciaPath'] as String?,
    );
  }

  Tarea copyWith({
    int? id,
    int? cursoId,
    String? titulo,
    String? descripcion,
    DateTime? fechaEntrega,
    String? prioridad,
    bool? completada,
    int? horasEstimadas,
    String? evidenciaPath,
  }) {
    return Tarea(
      id: id ?? this.id,
      cursoId: cursoId ?? this.cursoId,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      prioridad: prioridad ?? this.prioridad,
      completada: completada ?? this.completada,
      horasEstimadas: horasEstimadas ?? this.horasEstimadas,
      evidenciaPath: evidenciaPath ?? this.evidenciaPath,
    );
  }
}
