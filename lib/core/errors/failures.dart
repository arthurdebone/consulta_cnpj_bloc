abstract class Failures {
  final String message;
  const Failures(this.message);

  @override
  String toString() => message;
}

class FalhaServidor extends Failures {
  final int? statusCode;
  const FalhaServidor(super.message, {this.statusCode});
}

class FalhaConexao extends Failures {
  const FalhaConexao(super.message);
}

class FalhaCache extends Failures {
  const FalhaCache(super.message);
}

class FalhaDesconhecida extends Failures {
  const FalhaDesconhecida(super.message);
}
