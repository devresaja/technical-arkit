import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/services/local_storage_service.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState()) {
    on<UpdateThemeEvent>(_updateTheme);
  }

  Future<void> _updateTheme(
    UpdateThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await LocalStorageService.setIsBlueMode(event.isBlueMode);
    AppColor.updateTheme();
    emit(state.copyWith(isBlueMode: event.isBlueMode));
  }
}
