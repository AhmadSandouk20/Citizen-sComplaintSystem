import 'package:equatable/equatable.dart';

sealed class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsIdle extends ReportsState {
  const ReportsIdle();
}

class ReportsDownloading extends ReportsState {
  const ReportsDownloading(this.kind);

  final String kind;

  @override
  List<Object?> get props => [kind];
}

class ReportsSuccess extends ReportsState {
  const ReportsSuccess(this.path);

  final String path;

  @override
  List<Object?> get props => [path];
}

class ReportsError extends ReportsState {
  const ReportsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
