import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../services/current_user_service.dart';
import '../../../../../services/profile_service.dart';
import '../entities/user_profile.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String email;

  LoadProfile(this.email);
}

class UpdateProfile extends ProfileEvent {
  final String emailAtual;
  final String novoNome;
  final String novoEmail;

  UpdateProfile({
    required this.emailAtual,
    required this.novoNome,
    required this.novoEmail,
  });
}

class ClearProfileFeedback extends ProfileEvent {}

class ProfileState {
  final UserProfile? profile;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
    bool clearFeedback = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearFeedback ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearFeedback
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ClearProfileFeedback>(
      (event, emit) => emit(state.copyWith(clearFeedback: true)),
    );
  }

  final ProfileService _profileService = ProfileService();
  final CurrentUserService _currentUser = CurrentUserService.instance;

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearFeedback: true));

    try {
      final profile = await _profileService.obterPerfil(event.email);
      await _currentUser.setUser(
        email: profile.email,
        name: profile.nomeUsuario,
      );
      emit(state.copyWith(profile: profile, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Não foi possível carregar o perfil: $e',
        ),
      );
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, clearFeedback: true));

    try {
      final profile = await _profileService.editarPerfil(
        emailAtual: event.emailAtual,
        novoNome: event.novoNome,
        novoEmail: event.novoEmail,
      );

      await _currentUser.setUser(
        email: profile.email,
        name: profile.nomeUsuario,
      );

      emit(
        state.copyWith(
          profile: profile,
          isSaving: false,
          successMessage: 'Perfil atualizado com sucesso!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: 'Não foi possível atualizar o perfil: $e',
        ),
      );
    }
  }
}
