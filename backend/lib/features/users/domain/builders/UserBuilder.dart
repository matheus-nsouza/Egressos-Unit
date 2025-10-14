import 'package:backend/features/users/domain/user_model.dart';

class UserBuilder {
  UserBuilder();

  int? _id;
  String? _nomeCompleto;
  String? _email;
  String? _senhaHash;
  String? _fotoUrl;
  DateTime? _dataCadastro;
  DateTime? _dataAtualizacao;
  int? _idUsuarioCriador;
  int? _idUsuarioAtualizacao;

  UserBuilder setId(int? id) {
    _id = id;
    return this;
  }

  UserBuilder setNomeCompleto(String nomeCompleto) {
    _nomeCompleto = nomeCompleto;
    return this;
  }

  UserBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserBuilder setSenhaHash(String? senhaHash) {
    _senhaHash = senhaHash;
    return this;
  }

  UserBuilder setFotoUrl(String? fotoUrl) {
    _fotoUrl = fotoUrl;
    return this;
  }

  UserBuilder setDataCadastro(DateTime? dataCadastro) {
    _dataCadastro = dataCadastro;
    return this;
  }

  UserBuilder setDataAtualizacao(DateTime? dataAtualizacao) {
    _dataAtualizacao = dataAtualizacao;
    return this;
  }

  UserBuilder setIdUsuarioCriador(int? idUsuarioCriador) {
    _idUsuarioCriador = idUsuarioCriador;
    return this;
  }

  UserBuilder setIdUsuarioAtualizacao(int? idUsuarioAtualizacao) {
    _idUsuarioAtualizacao = idUsuarioAtualizacao;
    return this;
  }

  UserBuilder setAuditoriaCriacao(int? idUsuarioCriador) {
    _idUsuarioCriador = idUsuarioCriador;
    _dataCadastro = DateTime.now();
    return this;
  }

  UserBuilder setAuditoriaAtualizacao(int? idUsuarioAtualizacao) {
    _idUsuarioAtualizacao = idUsuarioAtualizacao;
    _dataAtualizacao = DateTime.now();
    return this;
  }

  UserModel build() {
    if (_nomeCompleto == null || _nomeCompleto!.trim().isEmpty) {
      throw ArgumentError('Nome completo é obrigatório');
    }

    if (_email == null || _email!.trim().isEmpty) {
      throw ArgumentError('Email é obrigatório');
    }

    return UserModel(
      id: _id,
      nomeCompleto: _nomeCompleto!,
      email: _email!,
      senhaHash: _senhaHash,
      fotoUrl: _fotoUrl,
      dataCadastro: _dataCadastro,
      dataAtualizacao: _dataAtualizacao,
      idUsuarioCriador: _idUsuarioCriador,
      idUsuarioAtualizacao: _idUsuarioAtualizacao,
    );
  }

  factory UserBuilder.fromUser(UserModel user) {
    return UserBuilder()
      ..setId(user.id)
      ..setNomeCompleto(user.nomeCompleto)
      ..setEmail(user.email)
      ..setSenhaHash(user.senhaHash)
      ..setFotoUrl(user.fotoUrl)
      ..setDataCadastro(user.dataCadastro)
      ..setDataAtualizacao(user.dataAtualizacao)
      ..setIdUsuarioCriador(user.idUsuarioCriador)
      ..setIdUsuarioAtualizacao(user.idUsuarioAtualizacao);
  }

  void reset() {
    _id = null;
    _nomeCompleto = null;
    _email = null;
    _senhaHash = null;
    _fotoUrl = null;
    _dataCadastro = null;
    _dataAtualizacao = null;
    _idUsuarioCriador = null;
    _idUsuarioAtualizacao = null;
  }
}
