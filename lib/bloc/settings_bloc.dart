import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/settings_event.dart';
import 'package:weather_app/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(isFahrenheit: false)) {
    on<ToggleUnitEvent>((event, emit) {
      emit(SettingsState(isFahrenheit: !state.isFahrenheit));
    });
  }
}
