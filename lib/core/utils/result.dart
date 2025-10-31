sealed class Result<T, E> {
  const Result();

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(E error) onFailure,
  }) {
    if (this is Success<T, E>) {
      return onSuccess((this as Success<T, E>).value);
    } else {
      return onFailure((this as Failure<T, E>).error);
    }
  }
}

final class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

final class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}