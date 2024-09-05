class Aluno {
  final String nome;
  final String email;
  final String cpf;
  final String foto;
  final String sexo;
  final DateTime dataDeNascimento;
  final int objetivoId;
  final int nivelAtividadeId;
  final int modalidadeAlunoId;
  final String telefone;

  Aluno({
    required this.nome,
    required this.email,
    required this.cpf,
    required this.foto,
    required this.sexo,
    required this.dataDeNascimento,
    required this.objetivoId,
    required this.nivelAtividadeId,
    required this.modalidadeAlunoId,
    required this.telefone,
  });

  // Método para converter JSON em Aluno
  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      nome: json['nome'],
      email: json['email'],
      cpf: json['cpf'],
      foto: json['foto'],
      sexo: json['informacoes-comuns']['sexo'],
      dataDeNascimento: DateTime.parse(json['informacoes-comuns']['data-de-nascimento']),
      objetivoId: json['informacoes-comuns']['objetivo_id'],
      nivelAtividadeId: json['informacoes-comuns']['nivel-atividade_id'],
      modalidadeAlunoId: json['informacoes-comuns']['modalidade-aluno_id'],
      telefone: json['informacoes-comuns']['telefone']['numero'],
    );
  }

  // Método para converter Aluno em JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'foto': foto,
      'informacoes-comuns': {
        'sexo': sexo,
        'data-de-nascimento': dataDeNascimento.toIso8601String(),
        'objetivo_id': objetivoId,
        'nivel-atividade_id': nivelAtividadeId,
        'modalidade-aluno_id': modalidadeAlunoId,
        'telefone': {'numero': telefone, 'tipo': 'celular'},
      },
    };
  }
}

class Personal {
  final int id;
  final String nome;
  final String email;
  final String cpf;
  final String? foto;
  final String sobre;
  final String confef;
  final String cref;
  final String especialidade;
  final Address? address;

  Personal({
    required this.id,
    required this.nome,
    required this.email,
    required this.cpf,
    this.foto,
    required this.sobre,
    required this.confef,
    required this.cref,
    required this.especialidade,
    this.address,
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      foto: json['foto'],  // Campo opcional, pode ser null
      sobre: json['sobre'] ?? '',
      confef: json['confef'] ?? '',
      cref: json['cref'] ?? '',
      especialidade: json['especialidade-do-personal'] ?? '',
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
    );
  }

  // Adicionando o método toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'foto': foto,
      'sobre': sobre,
      'confef': confef,
      'cref': cref,
      'especialidade-do-personal': especialidade,
      'address': address?.toJson(),  // Pode ser null, por isso o uso de ?
    };
  }
}

class Address {
  final int id;
  final String estado;
  final String cidade;
  final String bairro;
  final String rua;
  final String? complemento;
  final int numero;

  Address({
    required this.id,
    required this.estado,
    required this.cidade,
    required this.bairro,
    required this.rua,
    this.complemento,
    required this.numero,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      estado: json['estado'] ?? '',
      cidade: json['cidade'] ?? '',
      bairro: json['bairro'] ?? '',
      rua: json['rua'] ?? '',
      complemento: json['complemento'],
      numero: json['numero'] ?? 0,
    );
  }

  // Adicionando o método toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estado': estado,
      'cidade': cidade,
      'bairro': bairro,
      'rua': rua,
      'complemento': complemento,
      'numero': numero,
    };
  }
}


class Turma {
  final int id;
  final Personal personal;
  final List<Aluno> alunos;

  Turma({
    required this.id,
    required this.personal,
    required this.alunos,
  });

  factory Turma.fromJson(Map<String, dynamic> json) {
    return Turma(
      id: json['id'],
      personal: Personal.fromJson(json['personal']),
      alunos: (json['alunos'] as List).map((aluno) => Aluno.fromJson(aluno)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personal_id': personal.id, // Apenas o ID do personal, conforme esperado pela API
      'alunos': alunos.map((aluno) => aluno.toJson()).toList(),
    };
  }
}

