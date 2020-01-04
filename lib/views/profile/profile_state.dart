import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileState extends Equatable {
  ProfileState([List props = const <dynamic>[]]) : super();
}

class ProfileLoading extends ProfileState {
  @override
  List<Object> get props => Iterable.empty();

  @override
  String toString() => "Profile Loading";
}

class ProfileLoaded extends ProfileState {
  final String pseudonym;
  final String email;


  ProfileLoaded(this.pseudonym, this.email);

  @override
  List<Object> get props => [pseudonym, email];

  @override
  String toString() => "Profile Loaded";
}


