///O algoritmo de validação de CNPJ usa o cálculo do módulo 11 sobre os 14 caracteres do documento (que podem incluir
///letras no novo formato alfanumérico). Multiplica-se cada posição por pesos de 2 a 9 da direita para a esquerda,
///acha-se o resto da divisão por 11 e verifica-se se os dois dígitos conferem.
///
///Regras Principais do CálculoEstrutura:
/// - 14 posições totais (8 da raiz, 4 de ordem matriz/filial e 2 dígitos verificadores).
/// - Formato Alfanumérico: Letras são convertidas para valores numéricos subtraindo 48 do seu código ASCII
/// (ex: 'A' = 65 - 48 = 17).
/// - Pesos (Multiplicadores): Sequência de 2 até 9, reiniciando em 2 após o oitavo dígito, aplicados da direita para a esquerda.
/// - Dígito Verificador (DV): Se o resto da divisão da soma por 11 for menor que 2, o dígito é 0; caso contrário, é 11
/// menos o resto.
///
///Etapas da Validação
///- Converter letras maiúsculas para valores decimais se for o padrão alfanumérico novo.
///- Calcular o primeiro dígito verificador usando os primeiros 12 caracteres.
///- Calcular o segundo dígito verificador usando os 13 caracteres já com o primeiro dígito incluso.
///- Comparar os dois dígitos calculados com os dois últimos dígitos reais do CNPJ
library;

class ValidacaoCnpj {
  bool validacaoCnpj(String cnpj) {
    // Remove qualquer caractere que não seja letra ou número
    final String cnpjNum = cnpj.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // Evita erro de índice se a string for menor que 14
    if (cnpjNum.length != 14) return false;

    // Evita falsos positivos com dígitos todos iguais (Ex: 00000000000000)
    if (RegExp(r'^([A-Z0-9])\1*$').hasMatch(cnpjNum)) return false;

    //Calculo dos Digitos Verificadores
    int digiVerif1 = _calculaDigiVerificador(cnpjNum, 12);
    int digiVerif2 = _calculaDigiVerificador(cnpjNum, 13);

    return digiVerif1 == int.tryParse(cnpjNum[12]) && digiVerif2 == int.tryParse(cnpjNum[13]);
  }

  int _calculaDigiVerificador(String cnpjNum, int num) {
    int soma = 0;
    int pesoInicial = num == 12 ? 5 : 6;

    for (int i = 0; i < num; i++) {
      // Regra Oficial: Valor decimal do caractere na tabela ASCII menos 48
      int valorCaractere = cnpjNum.codeUnitAt(i) - 48;

      // Define o peso dinamicamente simulando a regressão (5,4,3,2,9,8...)
      int peso = pesoInicial - i;
      if (peso < 2) {
        peso = peso + 8;
      }
      soma += valorCaractere * peso;
    }

    int resto = soma % 11;
    return (resto < 2) ? 0 : (11 - resto);
  }
}
