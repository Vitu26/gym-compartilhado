class Professional {
  final String id;
  final String foto;
  final String nome;
  final String email;
  final String cpf;
  final String confef;
  final String cref;
  final String especialidade;
  final Endereco endereco;

  Professional({
    required this.id,
    required this.foto,
    required this.nome,
    required this.email,
    required this.cpf,
    required this.confef,
    required this.cref,
    required this.especialidade,
    required this.endereco,
  });

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      id: json['id'].toString(),
      foto: json['foto'] ?? '',  // Coloque um valor padrão ou uma URL vazia
      nome: json['nome'],
      email: json['email'],
      cpf: json['cpf'],
      confef: json['confef'],
      cref: json['cref'],
      especialidade: json['especialidade-do-personal'],
      endereco: Endereco.fromJson(json['endereco']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foto': foto,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'confef': confef,
      'cref': cref,
      'especialidade-do-personal': especialidade,
      'endereco': endereco.toJson(),
    };
  }
}

class Endereco {
  final String estado;
  final String cidade;
  final String bairro;
  final String rua;
  final String complemento;
  final String numero;

  Endereco({
    required this.estado,
    required this.cidade,
    required this.bairro,
    required this.rua,
    this.complemento = '',  // Opcional, com valor padrão
    required this.numero,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      estado: json['estado'],
      cidade: json['cidade'],
      bairro: json['bairro'],
      rua: json['rua'],
      complemento: json['complemento'] ?? '',  // Opcional
      numero: json['numero'].toString(),  // Convertendo para string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
      'cidade': cidade,
      'bairro': bairro,
      'rua': rua,
      'complemento': complemento,
      'numero': numero,
    };
  }
}
