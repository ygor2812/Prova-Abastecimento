import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../provider/abastecimentoProvider.dart';
import '../../models/abastecimento.dart';

class TelaCadastroAbastecimento extends StatefulWidget {
  final Abastecimento? abastecimento;
  final String veiculoId;

  const TelaCadastroAbastecimento({
    super.key,
    this.abastecimento,
    required this.veiculoId,
  });

  @override
  State<TelaCadastroAbastecimento> createState() => _TelaCadastroAbastecimentoState();
}

class _TelaCadastroAbastecimentoState extends State<TelaCadastroAbastecimento> {
  late final _litrosCtrl = TextEditingController(text: widget.abastecimento?.litros.toString() ?? '');
  late final _valorLitroCtrl = TextEditingController(text: widget.abastecimento?.valorLitro.toString() ?? '');
  late final _quilometragemCtrl = TextEditingController(text: widget.abastecimento?.quilometragem.toStringAsFixed(0) ?? '');
  late final _consumoCtrl = TextEditingController(text: widget.abastecimento?.consumo.toStringAsFixed(1) ?? '');
  late final _observacaoCtrl = TextEditingController(text: widget.abastecimento?.observacao ?? '');

  DateTime _dataSelecionada = DateTime.now();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.abastecimento != null) {
      _dataSelecionada = widget.abastecimento!.data;
    }
  }

  @override
  void dispose() {
    _litrosCtrl.dispose();
    _valorLitroCtrl.dispose();
    _quilometragemCtrl.dispose();
    _consumoCtrl.dispose();
    _observacaoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AbastecimentoProvider>();
    final isEdit = widget.abastecimento != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset("assets/imagem/marcas-de-carros-de-luxo-lamborghini.jpg", width: 300, height: 150),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurple, Colors.blueAccent]),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 120),
              Text(
                isEdit ? "Editar Abastecimento" : "Novo Abastecimento",
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              _campo("Litros", _litrosCtrl, tipo: TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 12),

              _campo("Valor por litro (R\$)", _valorLitroCtrl, tipo: TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 12),

              _campo("Quilometragem atual (km)", _quilometragemCtrl, tipo: TextInputType.number),
              const SizedBox(height: 12),

              _campo("Consumo (km/l) - opcional", _consumoCtrl, tipo: TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 12),

              CupertinoButton(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(7)),
                  child: Text(
                    "Data: ${_dateFormat.format(_dataSelecionada)}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                onPressed: () async {
                  final novaData = await showDatePicker(
                    context: context,
                    initialDate: _dataSelecionada,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
                  );
                  if (novaData != null) setState(() => _dataSelecionada = novaData);
                },
              ),
              const SizedBox(height: 12),

              CupertinoTextField(
                controller: _observacaoCtrl,
                maxLines: 3,
                padding: const EdgeInsets.all(15),
                placeholder: "Observação (opcional)",
                placeholderStyle: const TextStyle(color: Colors.white70),
                style: const TextStyle(color: Colors.white),
                decoration: const BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.all(Radius.circular(7))),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(17),
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black87,
                  ),
                  onPressed: provider.carregando ? null : () async {
                    final litros = double.tryParse(_litrosCtrl.text.replaceAll(',', '.')) ?? 0.0;
                    final valorLitro = double.tryParse(_valorLitroCtrl.text.replaceAll(',', '.')) ?? 0.0;
                    final quilometragem = double.tryParse(_quilometragemCtrl.text) ?? 0.0;
                    final consumo = double.tryParse(_consumoCtrl.text.replaceAll(',', '.')) ?? 0.0;

                    if (litros <= 0 || valorLitro <= 0 || quilometragem <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Preencha litros, valor e quilometragem corretamente")),
                      );
                      return;
                    }

                    final novo = Abastecimento(
                      id: isEdit ? widget.abastecimento!.id : '',
                      litros: litros,
                      valorLitro: valorLitro,
                      valorTotal: litros * valorLitro,
                      data: _dataSelecionada,
                      quilometragem: quilometragem,
                      consumo: consumo,
                      observacao: _observacaoCtrl.text,
                    );

                    final sucesso = isEdit
                        ? await provider.atualizar(widget.veiculoId, novo)
                        : await provider.adicionar(widget.veiculoId, novo);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(sucesso ? "Salvo com sucesso!" : "Erro ao salvar")),
                    );

                    if (sucesso && mounted) Navigator.pop(context);
                  },
                  child: provider.carregando
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(isEdit ? "ATUALIZAR" : "SALVAR", style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white70)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("CANCELAR", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController controller, {required TextInputType tipo}) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: tipo,
      padding: const EdgeInsets.all(15),
      placeholder: label,
      placeholderStyle: const TextStyle(color: Colors.white70),
      style: const TextStyle(color: Colors.white),
      decoration: const BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.all(Radius.circular(7))),
    );
  }
}