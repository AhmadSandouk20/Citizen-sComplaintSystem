import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/local_keys.dart';
import '../../../locale/presentation/bloc/locale_cubit.dart';
import '../../../locale/presentation/bloc/locale_state.dart';
import '../../../theme/presentation/bloc/theme_cubit.dart';
import '../../../theme/presentation/bloc/theme_state.dart';

/// Language and theme controls.
///
/// These existed only on the old placeholder profile screen and were lost when
/// the real one replaced it, leaving a fully bilingual app with no way to
/// switch language. The profile screen is where a user looks for them, so
/// that is where they live now.
class AppSettingsCard extends StatelessWidget {
  const AppSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Column(
        children: [
          // Language. `toggleLanguage` updates both LocaleCubit and
          // EasyLocalization, which is what keeps MaterialApp's locale and
          // `.tr()` from drifting apart.
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              final isArabic = state.locale.languageCode == 'ar';
              return ListTile(
                leading: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.translate,
                    size: 19,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                title: Text(LocaleKeys.language.tr()),
                subtitle: Text(isArabic ? 'العربية' : 'English'),
                trailing: SegmentedButton<String>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                  segments: const [
                    ButtonSegment(value: 'ar', label: Text('ع')),
                    ButtonSegment(value: 'en', label: Text('EN')),
                  ],
                  selected: {isArabic ? 'ar' : 'en'},
                  onSelectionChanged: (selection) {
                    if (selection.first != state.locale.languageCode) {
                      context.read<LocaleCubit>().toggleLanguage(context);
                    }
                  },
                ),
              );
            },
          ),

          Divider(height: 1, color: scheme.outline),

          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final isDark = state.themeMode == ThemeMode.dark;
              return SwitchListTile(
                secondary: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    size: 19,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                title: Text(LocaleKeys.theme.tr()),
                subtitle: Text(
                  isDark ? LocaleKeys.dark.tr() : LocaleKeys.light.tr(),
                ),
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleThemeMode(),
              );
            },
          ),
        ],
      ),
    );
  }
}
