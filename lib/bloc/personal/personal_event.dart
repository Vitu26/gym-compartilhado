import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';


abstract class PersonalEvent extends Equatable {
  const PersonalEvent();

  @override
  List<Object> get props => [];
}

// Evento para login de um personal
class PersonalLogin extends PersonalEvent {
  final String email;
  final String password;

  const PersonalLogin(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// Evento para cadastro de um novo personal
class PersonalCadastro extends PersonalEvent {
  final Map<String, dynamic> personalData;

  // Remover a segunda declaração de `personalData`
  const PersonalCadastro(this.personalData);

  @override
  List<Object> get props => [personalData];
}

// Evento para recuperar todos os personal trainers com possíveis filtros
class GetAllPersonais extends PersonalEvent {
  final String? professionalType;
  final String? gender;
  final String? attendanceType;
  final List<String>? modalities;
  final bool? freeTrial;

  const GetAllPersonais({
    this.professionalType,
    this.gender,
    this.attendanceType,
    this.modalities,
    this.freeTrial,
  });

  @override
  List<Object> get props => [
        professionalType ?? '', 
        gender ?? '', 
        attendanceType ?? '', 
        modalities ?? [], 
        freeTrial ?? false,
      ];
}

// Evento para recuperar os dados de um personal específico pelo ID
class GetPersonal extends PersonalEvent {
  final String id;

  const GetPersonal(this.id);

  @override
  List<Object> get props => [id];
}

// Evento para atualizar os dados de um personal específico pelo ID
class UpdatePersonal extends PersonalEvent {
  final String id;
  final Map<String, dynamic> personalData;
  final XFile? image;

  const UpdatePersonal(this.id, this.personalData, this.image,);

  @override
  List<Object> get props => [id, personalData];
}

// Evento para deletar um personal específico pelo ID
class DeletePersonal extends PersonalEvent {
  final String id;

  const DeletePersonal(this.id);

  @override
  List<Object> get props => [id];
}

class GetPersonalPassword extends PersonalEvent {}

// Event to update the password
class UpdatePersonalPassword extends PersonalEvent {
  final String currentPassword;
  final String newPassword;

  UpdatePersonalPassword({required this.currentPassword, required this.newPassword});

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class UpdatePersonalProfile extends PersonalEvent {
  final Map<String, dynamic> updatedData;
  final XFile? image;

  UpdatePersonalProfile({required this.updatedData, this.image});

  @override
  List<Object> get props => [updatedData, image ?? ''];
}
class FetchTopPersonais extends PersonalEvent {}

