import 'package:equatable/equatable.dart';
import '../../domain/entities/vr_room.dart';

abstract class VRTourState extends Equatable {
  const VRTourState();

  @override
  List<Object?> get props => [];
}

class VRTourInitial extends VRTourState {}

class VRTourLoading extends VRTourState {}

class VRTourLoaded extends VRTourState {
  final VRRoom currentRoom;
  final List<VRRoom> rooms;

  const VRTourLoaded(this.currentRoom, {this.rooms = const []});

  @override
  List<Object?> get props => [currentRoom, rooms];
}

class VRTourError extends VRTourState {
  final String message;

  const VRTourError(this.message);

  @override
  List<Object?> get props => [message];
}
