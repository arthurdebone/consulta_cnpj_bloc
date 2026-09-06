// 1. Classe base selada que define o grupo de eventos de busca de cnpj
sealed class EmpresaEvent {}

// 2. Evento disparado quando o usuário tenta fazer uma busca de um cnpj
final class BuscarEmpresaEvent extends EmpresaEvent {
  final String cnpj;

  BuscarEmpresaEvent({required this.cnpj});
}

//3. Outras classes para cada tipo de evento que o app poderia fazer
