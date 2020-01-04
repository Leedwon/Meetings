import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileEvent extends Equatable {}

class ProfileOpened extends ProfileEvent {

  @override
  List<Object> get props => Iterable.empty();

  @override
  String toString() => "ProfileOpened";
}
