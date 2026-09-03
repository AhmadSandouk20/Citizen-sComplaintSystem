import 'package:equatable/equatable.dart';

/// State of the wide-screen agencies view: which agency is open in the
/// details pane.
///
/// This used to also carry a `DashboardNavItem` for an internal navigation
/// rail, but that rail duplicated the admin sidebar exactly — statistics,
/// agencies and users each had two entry points leading to different screens.
/// Navigation belongs to the shell; this view owns only its own selection.
class DashboardState extends Equatable {
  const DashboardState({this.selectedAgencyId});

  final int? selectedAgencyId;

  DashboardState copyWith({int? selectedAgencyId}) =>
      DashboardState(selectedAgencyId: selectedAgencyId ?? this.selectedAgencyId);

  @override
  List<Object?> get props => [selectedAgencyId];
}
