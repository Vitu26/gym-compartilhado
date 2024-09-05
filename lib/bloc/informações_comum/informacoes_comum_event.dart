import 'package:equatable/equatable.dart';

abstract class InformacoesComunsEvent extends Equatable {
  const InformacoesComunsEvent();

  @override
  List<Object> get props => [];
}

class FetchInformacoesComuns extends InformacoesComunsEvent {
  final int id;

  const FetchInformacoesComuns(this.id);

  @override
  List<Object> get props => [id];
}

class CreateInformacoesComuns extends InformacoesComunsEvent {
  final Map<String, dynamic> informacoesComunsData;

  const CreateInformacoesComuns(this.informacoesComunsData);

  @override
  List<Object> get props => [informacoesComunsData];
}

class UpdateInformacoesComuns extends InformacoesComunsEvent {
  final int id;
  final Map<String, dynamic> informacoesComunsData;

  const UpdateInformacoesComuns(this.id, this.informacoesComunsData);

  @override
  List<Object> get props => [id, informacoesComunsData];
}

class DeleteInformacoesComuns extends InformacoesComunsEvent {
  final int id;

  const DeleteInformacoesComuns(this.id);

  @override
  List<Object> get props => [id];
}
