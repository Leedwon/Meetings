import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MapEvent extends Equatable {}

class MapOpened extends MapEvent {
  @override
  String toString() => 'MapOpened';

  @override
  List<Object> get props => Iterable.empty();
}
