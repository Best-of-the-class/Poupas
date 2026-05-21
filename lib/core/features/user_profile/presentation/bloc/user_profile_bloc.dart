import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomo/core/features/user_profile/presentation/entities/user_profile_data.dart';
import 'package:pomo/services/profile_service.dart';

class UserProfileState {
  final UserProfileData? profile;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final int errorId;

  const UserProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.errorId = 0,
  });

  bool get hasProfile => profile != null;

  UserProfileState copyWith({
    UserProfileData? profile,
    bool useExistingProfile = true,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UserProfileState(
      profile: useExistingProfile ? (profile ?? this.profile) : profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorId: errorMessage != null
          ? DateTime.now().microsecondsSinceEpoch
          : this.errorId,
    );
  }
}

class UserProfileBloc extends Cubit<UserProfileState> {
  final ProfileService _profileService;

  UserProfileBloc(this._profileService) : super(const UserProfileState());

  Future<void> loadProfile({bool force = false}) async {
    if (state.isLoading) {
      return;
    }

    if (!force && state.profile != null) {
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final profile = await _profileService.fetchProfile();
      emit(
        state.copyWith(
          profile: profile,
          isLoading: false,
          isSaving: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<bool> updateProfile({
    required String currentEmail,
    required String newName,
    required String newEmail,
    required int avatarId,
  }) async {
    emit(state.copyWith(isSaving: true, clearError: true));

    try {
      final profile = await _profileService.updateProfile(
        currentEmail: currentEmail,
        newName: newName,
        newEmail: newEmail,
        avatarId: avatarId,
      );

      emit(state.copyWith(profile: profile, isSaving: false, clearError: true));

      return true;
    } catch (error) {
      emit(state.copyWith(isSaving: false, errorMessage: error.toString()));

      return false;
    }
  }

  void clear() {
    emit(const UserProfileState());
  }
}
