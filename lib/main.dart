import 'package:consulta_cnpj_bloc/data/datasources/empresa_remote_datasource.dart';
import 'package:consulta_cnpj_bloc/data/repositories/empresa_repository_impl.dart';
import 'package:consulta_cnpj_bloc/presentation/pages/empresa_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final http.Client _client = http.Client();
  static final _datasource = EmpresaRemoteDatasourceImpl(_client);
  static final _repository = EmpresaRepositoryImpl(_datasource);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CNPJ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: EmpresaPage(repository: _repository),
    );
  }
}
