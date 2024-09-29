class AuthException implements Exception {
  final String key;

  static const Map<String, String> err = {
    'EMAIL_EXISTS': 'E-mail ja existe!',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente, tente mais tarde',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado!',
    'INVALID_PASSWORD': 'Senha informada não confere!',
    'USER_DISABLED': 'A conta do usuário foi desabilitada!',
  };

  AuthException(this.key);

  @override
  String toString() {
    // TODO: implement toString
    return err[key] ?? 'Ocorreu um erro no processo de autenticação!';
  }
}
