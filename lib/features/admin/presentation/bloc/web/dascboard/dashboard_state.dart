import 'package:equatable/equatable.dart';

enum DashboardNavItem { statistics, agencies, users, reports, profile }

class DashboardState extends Equatable {
  final DashboardNavItem selectedNavItem;
  final int? selectedAgencyId;

  const DashboardState({
    this.selectedNavItem = DashboardNavItem.agencies,
    this.selectedAgencyId,
  });

  DashboardState copyWith({
    DashboardNavItem? selectedNavItem,
    int? selectedAgencyId,
  }) {
    return DashboardState(
      selectedNavItem: selectedNavItem ?? this.selectedNavItem,
      selectedAgencyId: selectedAgencyId ?? this.selectedAgencyId,
    );
  }

  @override
  List<Object?> get props => [selectedNavItem, selectedAgencyId];
}
