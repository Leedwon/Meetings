import 'package:quiver/core.dart';

extension DynamicCasting on dynamic {
  T as<T>() => this is T ? this as T : null;
}

extension ToOptional on Object {
  Optional<T> toOptional<T>() {
    return this == null ? Optional.absent() : Optional.of(this);
  }
}
