import 'package:arbenn/components/snack_bar.dart';
import 'package:arbenn/utils/errors/exceptions.dart';
import 'package:flutter/material.dart';

/// Utility class that simplifies handling errors.
///
/// Return a [Result] from a function to indicate success or failure.
///
/// A [Result] is either an [Ok] with a value of type [T]
/// or an [Error] with an [Exception].
///
/// Use [Result.ok] to create a successful result with a value of type [T].
/// Use [Result.error] to create an error result with an [Exception].
sealed class Result<T> {
  const Result();

  /// Creates an instance of Result containing a value
  factory Result.ok(T value) => Ok(value);

  /// Create an instance of Result containing an error
  factory Result.error(ArbennException error) => Err(error);

  void showError(BuildContext context) {
    if (isErr()) {
      showErrorSnackBar(
          context: context, text: (this as Err).error.debug.toString());
    }
  }

  Result<Q> map<Q>(Q Function(T) f) {
    return switch (this) {
      Ok() => Ok(f((this as Ok).value)),
      Err() => Err((this as Err).error),
    };
  }

  Result<Q> bind<Q>(Result<Q> Function(T) f) {
    return switch (this) {
      Ok() => f((this as Ok).value),
      Err() => Err((this as Err).error),
    };
  }

  Future<Result<T>> iter<R>(R Function(T) f) async {
    this.map((value) => f(value));
    return this;
  }

  Future<Result<T>> futureIter<R>(Future<R> Function(T) f) async {
    await this.futureMap((value) => f(value));
    return this;
  }

  Future<Result<Q>> futureMap<Q>(Future<Q> Function(T) f) {
    return switch (this) {
      Ok() => f((this as Ok).value).then((value) => Ok(value)),
      Err() => Future.value(Err((this as Err).error)),
    };
  }

  Future<Result<Q>> futureBind<Q>(Future<Result<Q>> Function(T) f) {
    return switch (this) {
      Ok() => f((this as Ok).value),
      Err() => Future.value(Err((this as Err).error)),
    };
  }

  T unwrap() {
    if (this is Error) {
      throw Exception('Result is [Error].\n');
    }
    return (this as Ok).value;
  }

  /// Return the value
  T unwrapOr(T def) {
    return switch (this) {
      Ok() => (this as Ok).value,
      Err() => def,
    };
  }

  bool isErr() {
    return switch (this) {
      Ok() => false,
      Err() => true,
    };
  }

  bool isOk() {
    return switch (this) {
      Ok() => true,
      Err() => false,
    };
  }

  T? toOption() {
    return switch (this) {
      Ok() => (this as Ok).value,
      Err() => Null,
    };
  }
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  /// Returned value in result
  final T value;
}

/// Subclass of Result for errors
final class Err<T> extends Result<T> {
  const Err(this.error);

  /// Returned error in result
  final ArbennException error;
}

extension FutureResultExtensions<T> on Future<Result<T>> {
  Future<void> showError(BuildContext context) {
    then((result) => result.showError(context));
    return Future.value();
  }

  Future<Result<R>> map<R>(R Function(T) f) {
    return then((result) => result.map(f));
  }

  Future<Result<R>> futureMap<R>(Future<R> Function(T) f) {
    return then((result) async {
      switch (result) {
        case Ok():
          {
            R res = await f((result as Ok).value);
            return Ok(res);
          }
        case Err():
          return Err((this as Err).error);
      }
    });
  }

  Future<Result<T>> iter<R>(R Function(T) f) {
    return then((value) => value.iter(f)).onError(
      (error, stack) =>
          Err(ArbennException("[Future<Result<T>>::iter] $error")),
    );
  }

  Future<Result<T>> futureIter<R>(Future<R> Function(T) f) {
    return then((value) async {
      await value.futureMap((value) => f(value));
      return value;
    }).onError(
      (error, stack) => Err(ArbennException("[Future<Result<T>>] $error")),
    );
  }

  Future<Result<R>> futureBind<R>(Future<Result<R>> Function(T) f) {
    return then((result) async => switch (result) {
          Ok() => f((result as Ok).value),
          Err() => Future.value(Err((this as Err).error)),
        });
  }

  Future<Result<R>> bind<R>(Result<R> Function(T) f) {
    return then((result) async => switch (result) {
          Ok() => f((result as Ok).value),
          Err() => Err((this as Err).error),
        });
  }

  Future<T?> toOption() {
    return then((result) => switch (result) {
          Ok() => (this as Ok).value,
          Err() => Null,
        });
  }

  Future<T> unwrap() {
    return then((result) => result.unwrap());
  }

  Future<bool> isErr() {
    return then((value) => switch (value) {
          Ok() => false,
          Err() => true,
        });
  }

  Future<bool> isOk() {
    return then((value) => switch (value) {
          Ok() => true,
          Err() => false,
        });
  }
}
