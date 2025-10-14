class UserValidators {
  static String? validateNomeCompleto(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome completo é obrigatório';
    }

    if (value.trim().length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }

    if (!value.contains(' ')) {
      return 'Por favor, informe o nome completo (nome e sobrenome)';
    }

    final nomeRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
    if (!nomeRegex.hasMatch(value)) {
      return 'Nome deve conter apenas letras';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }

  static String? validateSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }

    return null;
  }

  static String? validateFotoUrl(String? value) {
    if (value == null || value.isEmpty) return null;

    final urlRegex = RegExp(
      r'^https?://.*\.(jpg|jpeg|png|gif|webp|svg)(\?.*)?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL da foto inválida. Formatos aceitos: jpg, jpeg, png, gif, webp, svg';
    }

    return null;
  }

  static Map<String, String> validateAll({
    required String? nomeCompleto,
    required String? email,
    String? senha,
    String? fotoUrl,
  }) {
    final errors = <String, String>{};

    final nomeError = validateNomeCompleto(nomeCompleto);
    if (nomeError != null) errors['nomeCompleto'] = nomeError;

    final emailError = validateEmail(email);
    if (emailError != null) errors['email'] = emailError;

    if (senha != null) {
      final senhaError = validateSenha(senha);
      if (senhaError != null) errors['senha'] = senhaError;
    }

    if (fotoUrl != null) {
      final fotoError = validateFotoUrl(fotoUrl);
      if (fotoError != null) errors['fotoUrl'] = fotoError;
    }

    return errors;
  }
}
