import 'package:backend/features/users/domain/user_model.dart';

extension UserModelExtensions on UserModel {
  bool get temFoto => fotoUrl != null && fotoUrl!.isNotEmpty;

  String get iniciais {
    final partes = nomeCompleto.split(' ');
    if (partes.isEmpty) return '';
    if (partes.length == 1) return partes[0][0].toUpperCase();
    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }

  String get primeiroNome {
    return nomeCompleto.split(' ').first;
  }

  String get ultimoNome {
    final partes = nomeCompleto.split(' ');
    return partes.length > 1 ? partes.last : '';
  }

  bool get ehNovo {
    if (dataCadastro == null) return false;
    return DateTime.now().difference(dataCadastro!).inHours < 24;
  }

  bool get foiAtualizadoRecentemente {
    if (dataAtualizacao == null) return false;
    return DateTime.now().difference(dataAtualizacao!).inHours < 24;
  }

  String fotoUrlOuPlaceholder() {
    if (temFoto) return fotoUrl!;
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(nomeCompleto)}&size=200&background=random';
  }

  String get emailOfuscado {
    final partes = email.split('@');
    if (partes.length != 2) return email;

    final usuario = partes[0];
    final dominio = partes[1];

    if (usuario.length <= 2) return email;

    final primeiraLetra = usuario[0];
    final asteriscos = '*' * (usuario.length - 1);

    return '$primeiraLetra$asteriscos@$dominio';
  }

  String get tempoDesdeRegistro {
    if (dataCadastro == null) return 'Desconhecido';

    final diferenca = DateTime.now().difference(dataCadastro!);

    if (diferenca.inDays > 365) {
      final anos = (diferenca.inDays / 365).floor();
      return '$anos ${anos == 1 ? "ano" : "anos"}';
    } else if (diferenca.inDays > 30) {
      final meses = (diferenca.inDays / 30).floor();
      return '$meses ${meses == 1 ? "mês" : "meses"}';
    } else if (diferenca.inDays > 0) {
      return '${diferenca.inDays} ${diferenca.inDays == 1 ? "dia" : "dias"}';
    } else if (diferenca.inHours > 0) {
      return '${diferenca.inHours} ${diferenca.inHours == 1 ? "hora" : "horas"}';
    } else {
      return '${diferenca.inMinutes} ${diferenca.inMinutes == 1 ? "minuto" : "minutos"}';
    }
  }

  Map<String, dynamic> toSummary() {
    return {
      'id': id,
      'nomeCompleto': nomeCompleto,
      'primeiroNome': primeiroNome,
      'email': email,
      'iniciais': iniciais,
      'fotoUrl': fotoUrlOuPlaceholder(),
      'ehNovo': ehNovo,
    };
  }
}
