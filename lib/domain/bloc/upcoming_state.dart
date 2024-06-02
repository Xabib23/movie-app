part of 'upcoming_bloc.dart';

sealed class UpcomingState extends Equatable {
  const UpcomingState();

  @override
  List<Object> get props => [];
}

final class UpcomingInitial extends UpcomingState {
  const UpcomingInitial();
}

final class UpcomingLoaded extends UpcomingState {
  final UpcomingModel data;

  const UpcomingLoaded({required this.data});

  @override
  List<Object> get props => [data];
}
