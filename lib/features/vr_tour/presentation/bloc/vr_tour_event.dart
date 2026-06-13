import 'package:equatable/equatable.dart';

abstract class VRTourEvent extends Equatable {
  const VRTourEvent();

  @override
  List<Object?> get props => [];
}

class InitVRTour extends VRTourEvent {}

class NavigateToRoom extends VRTourEvent {
  final String roomId;

  const NavigateToRoom(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class AddCustomRoom extends VRTourEvent {
  final VRRoom room;

  const AddCustomRoom(this.room);

  @override
  List<Object?> get props => [room];
}
