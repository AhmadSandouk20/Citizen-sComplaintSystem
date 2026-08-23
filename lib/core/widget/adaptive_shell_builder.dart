import 'package:final_flutter/core/shared/navigation_item.dart';
import 'package:final_flutter/core/widget/app_bottom_navigation_bar.dart';
import 'package:final_flutter/core/widget/app_navigation_rail.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:final_flutter/features/locale/presentation/bloc/locale_cubit.dart';
import 'package:final_flutter/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:final_flutter/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdaptiveShellBuilder extends StatelessWidget {
  const AdaptiveShellBuilder({
    super.key,
    required this.currentChild,
    required this.role,
  });
  final UserRole role;

  final Widget currentChild;

  @override
  Widget build(BuildContext context) {
    context.watch<LocaleCubit>();

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, notificationsState) {
        final navItems = getNavItemsForRole(
          role,
          unreadCount: notificationsState.unreadCount,
        );
        final currentLocation = GoRouterState.of(context).matchedLocation;

        final selectedIndex = navItems.indexWhere(
          (item) => currentLocation.startsWith(item.route),
        );
        final safeIndex = selectedIndex != -1 ? selectedIndex : 0;

        return LayoutBuilder(
          builder: (context, constr) {
            final isMobile = constr.maxWidth <= 600;
            return isMobile
                ? Scaffold(
                    body: currentChild,
                    bottomNavigationBar: AppBottomNavigationBar(
                      navItems: navItems,
                      currentIndex: safeIndex,
                      onTap: (index) {
                        context.go(navItems[index].route);
                      },
                    ),
                  )
                : Scaffold(
                    body: Row(
                      children: [
                        AppNavigationRail(
                          navItems: navItems,
                          selectedIndex: safeIndex,
                          onDestinationSelected: (index) {
                            context.go(navItems[index].route);
                          },
                        ),
                        Expanded(child: currentChild),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }
}
