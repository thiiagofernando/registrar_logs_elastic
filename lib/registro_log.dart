import 'dart:convert';

class RegistroLog {
  final String Mensagem;
  final String StackTrace;
  final String Nivel;
  RegistroLog({
    required this.Mensagem,
    required this.StackTrace,
    required this.Nivel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Mensagem': Mensagem,
      'StackTrace': StackTrace,
      'Nivel': Nivel,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(covariant RegistroLog other) {
    if (identical(this, other)) return true;

    return other.Mensagem == Mensagem && other.StackTrace == StackTrace && other.Nivel == Nivel;
  }

  @override
  int get hashCode {
    return Mensagem.hashCode ^ StackTrace.hashCode ^ Nivel.hashCode;
  }
}
