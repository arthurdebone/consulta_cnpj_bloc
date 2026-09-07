class Mascaras {
  static String mascaraCnpj(String cnpj) {
    final cnpjLimpo = cnpj.replaceAll(RegExp(r'[^A-Z0-9]'), '').toUpperCase();

    if (cnpjLimpo.length != 14) return cnpj;

    return '${cnpjLimpo.substring(0, 2)}.${cnpjLimpo.substring(2, 5)}.${cnpjLimpo.substring(5, 8)}/${cnpjLimpo.substring(8, 12)}-${cnpjLimpo.substring(12, 14)}';
  }
}
