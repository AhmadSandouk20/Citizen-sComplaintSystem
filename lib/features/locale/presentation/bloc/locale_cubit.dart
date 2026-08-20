import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/features/locale/presentation/bloc/locale_state.dart';
import 'package:flutter/material.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(Locale('en')));
  void setLocale(Locale locale) {
    emit(LocaleState(locale));
  }

  void toggleLanguage(BuildContext context) {
    final Locale appLanguage = state.locale == Locale('en')
        ? Locale('ar')
        : Locale('en');
    emit(LocaleState(appLanguage));
    context.setLocale(appLanguage);
  }
}
