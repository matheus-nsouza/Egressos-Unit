class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 8) {
      return 'Senha deve ter no mínimo 8 caracteres';
    }

    return null;
  }

  static String? cpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    // Remove formatação
    final cpfNumbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpfNumbers.length != 11) {
      return 'CPF inválido';
    }

    // TODO: Implementar validação completa de CPF

    return null;
  }

  static String? nomeCompleto(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome completo é obrigatório';
    }

    if (value.length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }

    if (!value.contains(' ')) {
      return 'Por favor, informe o nome completo';
    }

    return null;
  }

  static String? required(String? value, [String fieldName = 'Campo']) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }
}