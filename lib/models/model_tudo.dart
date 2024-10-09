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
      dataDeNascimento:
          DateTime.parse(json['informacoes-comuns']['data-de-nascimento']),
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
  final String? password;
  final String cpf;
  final String? foto;
  final String? genero;
  final String tipoAtendimento;
  final String? experimentalGratuita;
  final Address endereco;
  final String confef;
  final String cref;
  final String especialidadeDoPersonal;
  final int seguidores;
  final List<Treino> treinos;
  final List<Comentario> comentarios;

  Personal({
    required this.id,
    required this.nome,
    required this.email,
    this.password,
    required this.cpf,
    this.foto,
    this.genero,
    required this.tipoAtendimento,
    this.experimentalGratuita,
    required this.endereco,
    required this.confef,
    required this.cref,
    required this.especialidadeDoPersonal,
    required this.seguidores,
    required this.treinos,
    required this.comentarios,
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] as String?,
      cpf: json['cpf']?.toString() ?? '',
      foto: json['foto'] as String?,
      genero: json['genero'] as String?,
      tipoAtendimento: json['tipo_atendimento'] ?? '',
      experimentalGratuita: json['experimental_gratuita']?.toString(),
      endereco: Address.fromJson(json['endereco'] ?? {}),
      confef: json['confef']?.toString() ?? '',
      cref: json['cref']?.toString() ?? '',
      especialidadeDoPersonal:
          json['especialidade-do-personal']?.toString() ?? '',
      seguidores: json['seguidores'] ?? 0,

      // Verifique se 'treinos' existe e não é null, se for null, defina uma lista vazia
      treinos: json['treinos'] != null
          ? (json['treinos'] as List).map((t) => Treino.fromJson(t)).toList()
          : [],

      // Verifique se 'comentarios' existe e não é null, se for null, defina uma lista vazia
      comentarios: json['comentarios'] != null
          ? (json['comentarios'] as List)
              .map((c) => Comentario.fromJson(c))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'password': password,
      'cpf': cpf,
      'foto': foto,
      'genero': genero,
      'tipo_atendimento': tipoAtendimento,
      'experimental_gratuita': experimentalGratuita,
      'endereco': endereco.toJson(),
      'confef': confef,
      'cref': cref,
      'especialidade-do-personal': especialidadeDoPersonal,
      'seguidores': seguidores,
      'treinos': treinos.map((t) => t.toJson()).toList(),
      'comentarios': comentarios.map((c) => c.toJson()).toList(),
    };
  }
}

class Treino {
  final String titulo;
  final String duracao;
  final String nivel;

  Treino({
    required this.titulo,
    required this.duracao,
    required this.nivel,
  });

  factory Treino.fromJson(Map<String, dynamic> json) {
    return Treino(
      titulo: json['titulo'] ?? '',
      duracao: json['duracao'] ?? '',
      nivel: json['nivel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'duracao': duracao,
      'nivel': nivel,
    };
  }
}

class Comentario {
  final String autor;
  final String comentario;
  final double nota;

  Comentario({
    required this.autor,
    required this.comentario,
    required this.nota,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      autor: json['autor'] ?? '',
      comentario: json['comentario'] ?? '',
      nota: double.parse(json['nota'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autor': autor,
      'comentario': comentario,
      'nota': nota,
    };
  }
}

class Address {
  final String estado;
  final String cidade;
  final String bairro;
  final String rua;
  final String? complemento; // Pode ser null
  final String numero;

  Address({
    required this.estado,
    required this.cidade,
    required this.bairro,
    required this.rua,
    this.complemento, // Campo opcional
    required this.numero,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      estado: json['estado'] ?? '', // Tratar como String, mesmo se for null
      cidade: json['cidade'] ?? '', // Tratar como String, mesmo se for null
      bairro: json['bairro'] ?? '', // Tratar como String, mesmo se for null
      rua: json['rua'] ?? '', // Tratar como String, mesmo se for null
      complemento: json['complemento'] as String?, // Opcional, pode ser null
      numero: json['numero']?.toString() ??
          '', // Garantir que seja tratado como String
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
      alunos: (json['alunos'] as List)
          .map((aluno) => Aluno.fromJson(aluno))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personal_id':
          personal.id, // Apenas o ID do personal, conforme esperado pela API
      'alunos': alunos.map((aluno) => aluno.toJson()).toList(),
    };
  }
}



// class Personal {
//   final String id;
//   final String nome;
//   final String email;
//   final String cpf;
//   final String? foto;
//   final String sobre;
//   final String confef;
//   final String cref;
//   final String especialidade;
//   final String tipoAtendimento;
//   final String? genero;
//   final String? experimentalGratuita;
//   final Address? endereco;

//   Personal({
//     required this.id,
//     required this.nome,
//     required this.email,
//     required this.cpf,
//     this.foto,
//     required this.sobre,
//     required this.confef,
//     required this.cref,
//     required this.especialidade,
//     required this.tipoAtendimento,
//     this.genero,
//     this.experimentalGratuita,
//     this.endereco,
//   });

//   factory Personal.fromJson(Map<String, dynamic> json) {
//     return Personal(
//       id: json['id'] ?? '',
//       nome: json['nome'] ?? '',
//       email: json['email'] ?? '',
//       cpf: json['cpf'] ?? '',
//       foto: json['foto'], // Campo opcional, pode ser null
//       sobre: json['sobre'] ?? '',
//       confef: json['confef'] ?? '',
//       cref: json['cref'] ?? '',
//       especialidade: json['especialidade-do-personal'] ?? '',
//       tipoAtendimento: json['tipo_atendimento'] ?? '',
//       genero: json['genero'],
//       experimentalGratuita: json['experimental_gratuita'],
//       endereco:
//           json['endereco'] != null ? Address.fromJson(json['endereco']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'nome': nome,
//       'email': email,
//       'cpf': cpf,
//       'foto': foto,
//       'sobre': sobre,
//       'confef': confef,
//       'cref': cref,
//       'especialidade-do-personal': especialidade,
//       'tipo_atendimento': tipoAtendimento,
//       'genero': genero,
//       'experimental_gratuita': experimentalGratuita,
//       'endereco': endereco?.toJson(),
//     };
//   }
// }

// class Address {
//   final String estado;
//   final String cidade;
//   final String bairro;
//   final String rua;
//   final String numero;
//   final String? complemento;

//   Address({
//     required this.estado,
//     required this.cidade,
//     required this.bairro,
//     required this.rua,
//     required this.numero,
//     this.complemento,
//   });

//   factory Address.fromJson(Map<String, dynamic> json) {
//     return Address(
//       estado: json['estado'] ?? '',
//       cidade: json['cidade'] ?? '',
//       bairro: json['bairro'] ?? '',
//       rua: json['rua'] ?? '',
//       numero: json['numero'] ?? '',
//       complemento: json['complemento'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'estado': estado,
//       'cidade': cidade,
//       'bairro': bairro,
//       'rua': rua,
//       'numero': numero,
//       'complemento': complemento,
//     };
//   }
// }