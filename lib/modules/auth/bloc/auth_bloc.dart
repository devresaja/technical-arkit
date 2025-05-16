import 'package:technical_artkit/modules/auth/data/auth_api.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:technical_artkit/shared/model/user_data.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _api = AuthApi();

  AuthBloc() : super(AuthInitial()) {
    on<LogoutEvent>(_logout);
    on<LoginByGoogleEvent>(_loginByGoogle);
  }

  _logout(AuthEvent event, Emitter<AuthState> emit) async {
    emit(LogoutLoadingState());

    try {
      final response = await _api.logout();

      response.fold(
        (left) => emit(LogoutFailedState(response.left.toString())),
        (right) => emit(LogoutLoadedState()),
      );
    } catch (e) {
      emit(LogoutFailedState(e.toString()));
    }
  }

  _loginByGoogle(AuthEvent event, Emitter<AuthState> emit) async {
    emit(LoginByGoogleLoadingState());

    try {
      final loginResponse = await _api.loginByGoogle();

      await loginResponse.fold(
        (error) async {
          if (error == null) {
            emit(AuthInitial());
          } else {
            emit(LoginByGoogleFailedState(error));
          }
        },
        (userData) async {
          final updateResponse = await _api.updateUserData(
            userData.userId!,
            userData.toJson(),
          );

          updateResponse.fold(
            (error) => emit(LoginByGoogleFailedState(error)),
            (_) => emit(LoginByGoogleLoadedState(userData: userData)),
          );
        },
      );
    } catch (e) {
      emit(LoginByGoogleFailedState(e.toString()));
    }
  }
}
