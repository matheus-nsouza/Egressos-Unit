class DocumentoCarteirinhaModel {
  final int? id;
  final int? idEgresso;
  final int? idCarteirinha;
  final String? nomeOriginal;
  final String? tipoDocumento;
  final int? tamanhoBytes;
  final String? mimeType;
  final String? arquivoUrl;
  final bool? processado;
  final String? status;
  final String? motivoReprovacao;
  final int? idAprovacao;
  final DateTime? dataUpload;
  final DateTime? dataAprovacao;
  final DateTime? dataCadastro;
  final DateTime? dataAtualizacao;

  DocumentoCarteirinhaModel({
    this.id,
    this.idEgresso,
    this.idCarteirinha,
    this.nomeOriginal,
    this.tipoDocumento,
    this.tamanhoBytes,
    this.mimeType,
    this.arquivoUrl,
    this.processado,
    this.status,
    this.motivoReprovacao,
    this.idAprovacao,
    this.dataUpload,
    this.dataAprovacao,
    this.dataCadastro,
    this.dataAtualizacao,
  });

  factory DocumentoCarteirinhaModel.fromMap(Map<String, dynamic> map) {
    return DocumentoCarteirinhaModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      idEgresso: map['id_egresso'] is int
          ? map['id_egresso'] as int
          : int.tryParse(map['id_egresso']?.toString() ?? ''),
      idCarteirinha: map['id_carteirinha'] is int
          ? map['id_carteirinha'] as int
          : int.tryParse(map['id_carteirinha']?.toString() ?? ''),
      nomeOriginal: map['nome_original']?.toString(),
      tipoDocumento: map['tipo_documento']?.toString(),
      tamanhoBytes: map['tamanho_bytes'] is int
          ? map['tamanho_bytes'] as int
          : int.tryParse(map['tamanho_bytes']?.toString() ?? ''),
      mimeType: map['mime_type']?.toString(),
      arquivoUrl: map['arquivo_url']?.toString(),
      processado: map['processado'] as bool?,
      status: map['status']?.toString(),
      motivoReprovacao: map['motivo_reprovacao']?.toString(),
      idAprovacao: map['id_aprovacao'] is int
          ? map['id_aprovacao'] as int
          : int.tryParse(map['id_aprovacao']?.toString() ?? ''),
      dataUpload: map['data_upload'] != null
          ? DateTime.parse(map['data_upload'].toString())
          : null,
      dataAprovacao: map['data_aprovacao'] != null
          ? DateTime.parse(map['data_aprovacao'].toString())
          : null,
      dataCadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_egresso': idEgresso,
      'id_carteirinha': idCarteirinha,
      'nome_original': nomeOriginal,
      'tipo_documento': tipoDocumento,
      'tamanho_bytes': tamanhoBytes,
      'mime_type': mimeType,
      'arquivo_url': arquivoUrl,
      'processado': processado,
      'status': status,
      'motivo_reprovacao': motivoReprovacao,
      'id_aprovacao': idAprovacao,
      'data_upload': dataUpload?.toIso8601String(),
      'data_aprovacao': dataAprovacao?.toIso8601String(),
      'data_cadastro': dataCadastro?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idEgresso': idEgresso,
      'idCarteirinha': idCarteirinha,
      'nomeOriginal': nomeOriginal,
      'tipoDocumento': tipoDocumento,
      'tamanhoBytes': tamanhoBytes,
      'mimeType': mimeType,
      'arquivoUrl': arquivoUrl,
      'processado': processado,
      'status': status,
      'motivoReprovacao': motivoReprovacao,
      'idAprovacao': idAprovacao,
      'dataUpload': dataUpload?.toIso8601String(),
      'dataAprovacao': dataAprovacao?.toIso8601String(),
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  DocumentoCarteirinhaModel copyWith({
    int? id,
    int? idEgresso,
    int? idCarteirinha,
    String? nomeOriginal,
    String? tipoDocumento,
    int? tamanhoBytes,
    String? mimeType,
    String? arquivoUrl,
    bool? processado,
    String? status,
    String? motivoReprovacao,
    int? idAprovacao,
    DateTime? dataUpload,
    DateTime? dataAprovacao,
    DateTime? dataCadastro,
    DateTime? dataAtualizacao,
  }) {
    return DocumentoCarteirinhaModel(
      id: id ?? this.id,
      idEgresso: idEgresso ?? this.idEgresso,
      idCarteirinha: idCarteirinha ?? this.idCarteirinha,
      nomeOriginal: nomeOriginal ?? this.nomeOriginal,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,
      mimeType: mimeType ?? this.mimeType,
      arquivoUrl: arquivoUrl ?? this.arquivoUrl,
      processado: processado ?? this.processado,
      status: status ?? this.status,
      motivoReprovacao: motivoReprovacao ?? this.motivoReprovacao,
      idAprovacao: idAprovacao ?? this.idAprovacao,
      dataUpload: dataUpload ?? this.dataUpload,
      dataAprovacao: dataAprovacao ?? this.dataAprovacao,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
