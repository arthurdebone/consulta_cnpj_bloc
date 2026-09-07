import 'package:consulta_cnpj_bloc/core/utils/mascaras.dart';
import 'package:consulta_cnpj_bloc/core/utils/validacao_cnpj.dart';
import 'package:consulta_cnpj_bloc/domain/entities/empresa.dart';
import 'package:consulta_cnpj_bloc/domain/repositories/empresa_repository.dart';
import 'package:consulta_cnpj_bloc/presentation/bloc/empresa_bloc.dart';
import 'package:consulta_cnpj_bloc/presentation/bloc/empresa_event.dart';
import 'package:consulta_cnpj_bloc/presentation/bloc/empresa_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EmpresaPage extends StatelessWidget {
  final EmpresaRepository repository;

  const EmpresaPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => EmpresaBloc(repository), child: _EmpresaConteudo());
  }
}

class _EmpresaConteudo extends StatefulWidget {
  const _EmpresaConteudo();

  @override
  State<_EmpresaConteudo> createState() => _EmpresaConteudoState();
}

class _EmpresaConteudoState extends State<_EmpresaConteudo> {
  final _formKey = GlobalKey<FormState>();
  final _validator = ValidacaoCnpj();
  late final TextEditingController _cnpjController;

  final _cnpjMaskFormatter = MaskTextInputFormatter(
    mask: 'AA.AAA.AAA/AAAA-00',
    filter: {"A": RegExp(r'[a-zA-Z0-9]'), "0": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _cnpjController = TextEditingController();
  }

  @override
  void dispose() {
    _cnpjController.dispose();
    super.dispose();
  }

  void _consultar() {
    if (_formKey.currentState?.validate() ?? false) {
      final cnpjUnmask = _cnpjMaskFormatter.getUnmaskedText();
      context.read<EmpresaBloc>().add(BuscarEmpresaEvent(cnpj: cnpjUnmask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar CNPJ'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cnpjController,
                    inputFormatters: [_cnpjMaskFormatter],
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'CNPJ',
                      hintText: 'A1.B2C.3D4/E5F6-00',
                      border: const OutlineInputBorder(),
                      helperText: 'O novo formato do CNPJ aceita letras e números',
                      suffixIcon: IconButton(onPressed: _consultar, icon: const Icon(Icons.search)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o CNPJ';
                      }
                      if (!_validator.validacaoCnpj(value)) {
                        return 'O CNPJ digitado é invalido!';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _consultar,
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar CNPJ'),
                    ),
                  ),

                  BlocBuilder<EmpresaBloc, EmpresaState>(
                    builder: (context, state) {
                      return switch (state) {
                        EmpresaInitial() => const Text('Nada buscado ainda.'),
                        EmpresaLoading() => const CircularProgressIndicator(),
                        EmpresaSuccess(empresa: final empresa) => _DetalhesEmpresaCard(empresa),
                        EmpresaError(failure: final failure) => Text('Erro: $failure'),
                      };
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetalhesEmpresaCard extends StatelessWidget {
  final Empresa empresa;

  const _DetalhesEmpresaCard(this.empresa);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //RAZÃO SOCIAL
            Text(
              empresa.razaoSocial,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            //NOME FANTASIA
            SizedBox(height: 4),
            if (empresa.nomeFantasia != null && empresa.nomeFantasia!.isNotEmpty) ...[
              Text(empresa.nomeFantasia!, style: Theme.of(context).textTheme.bodyMedium),
            ],

            //IFORMAÇÕES DA EMPRESA
            const Divider(height: 24),
            _infoRow('CNPJ', empresa.cnpj),
            if (empresa.dataAtualzacao != null && empresa.dataAtualzacao!.toString().isNotEmpty)
              _infoRow('Data de Atualização', DateFormat('dd/MM/yyyy').format(empresa.dataAtualzacao!)),
            _infoRow('Situação Cadastral', empresa.situacao),
            _infoRow('Atividade Principal', empresa.atividadePrincipal),
            _infoRow(
              'Endereço',
              '${empresa.tipoLogradouro ?? ''} ${empresa.logradouro}, ${empresa.numero}, ${empresa.bairro}, ${empresa.cidade} - ${empresa.pais}, ${empresa.cep}',
            ),
            if (empresa.capitalSocial != null && empresa.capitalSocial!.isNotEmpty)
              _infoRow('Capital Social', empresa.capitalSocial!),
            _infoRow('Porte', empresa.porte),
            _infoRow('Natureza Jurídica', empresa.naturezaJuridica),

            //INSCRIÇÕES ESTADUAIS
            if (empresa.inscricaoEstaduais != null && empresa.inscricaoEstaduais!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Inscrições Estaduais', style: TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 4),
              ...empresa.inscricaoEstaduais!.map(
                (ie) => Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                  child: Text('• ${ie.inscricaoEstadual} (${ie.estado}) - ${ie.situacao}'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: Mascaras.mascaraCnpj(value)),
          ],
        ),
      ),
    );
  }
}
