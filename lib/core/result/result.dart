sealed class Result<S, F> {
  const Result();

  factory Result.success(S data) => Ok(data);
  factory Result.failure(F error) => Err(error);

  bool get isSuccess => this is Ok<S, F>;
  bool get isFailure => this is Err<S, F>;
}

class Ok<S, F> extends Result<S, F> {
  final S value;
  const Ok(this.value);
}

class Err<S, F> extends Result<S, F> {
  final F error;
  const Err(this.error);
}
