class AuthValidators {
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

  static String? validateCpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    // Remove pontos e traços
    String cpf = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Validação dos dígitos verificadores
    List<int> numbers = cpf.split('').map((e) => int.parse(e)).toList();

    // Primeiro dígito
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += numbers[i] * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) firstDigit = 0;

    if (numbers[9] != firstDigit) {
      return 'CPF inválido';
    }

    // Segundo dígito
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += numbers[i] * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) secondDigit = 0;

    if (numbers[10] != secondDigit) {
      return 'CPF inválido';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }

    return null;
  }

  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 8) {
      return 'Senha deve ter no mínimo 8 caracteres';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Senha deve conter pelo menos uma letra maiúscula';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Senha deve conter pelo menos uma letra minúscula';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Senha deve conter pelo menos um número';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Senha deve conter pelo menos um caractere especial';
    }

    return null;
  }

  static String? validateNomeCompleto(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome completo é obrigatório';
    }

    if (value.trim().length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }

    if (!value.contains(' ')) {
      return 'Por favor, informe o nome completo';
    }

    return null;
  }

  static String? validatePasswordConfirmation(
      String? senha, String? confirmacao) {
    if (confirmacao == null || confirmacao.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (senha != confirmacao) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  static Map<String, String> validateLogin({
    required String? cpf,
    required String? senha,
  }) {
    final errors = <String, String>{};

    final cpfError = validateCpf(cpf);
    if (cpfError != null) errors['cpf'] = cpfError;

    final senhaError = validatePassword(senha);
    if (senhaError != null) errors['senha'] = senhaError;

    return errors;
  }

  static Map<String, String> validateRegister({
    required String? nomeCompleto,
    required String? email,
    required String? cpf,
    required String? senha,
    String? confirmacaoSenha,
  }) {
    final errors = <String, String>{};

    final nomeError = validateNomeCompleto(nomeCompleto);
    if (nomeError != null) errors['nomeCompleto'] = nomeError;

    final emailError = validateEmail(email);
    if (emailError != null) errors['email'] = emailError;

    final cpfError = validateCpf(cpf);
    if (cpfError != null) errors['cpf'] = cpfError;

    final senhaError = validatePassword(senha);
    if (senhaError != null) errors['senha'] = senhaError;

    if (confirmacaoSenha != null) {
      final confirmacaoError =
          validatePasswordConfirmation(senha, confirmacaoSenha);
      if (confirmacaoError != null)
        errors['confirmacaoSenha'] = confirmacaoError;
    }

    return errors;
  }
}
