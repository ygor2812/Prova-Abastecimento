import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/abastecimentoProvider.dart';
import '../../models/abastecimento.dart';

class TelaCadastroAbastecimento extends StatefulWidget {
  final Abastecimento? abastecimento;
  final String veiculoId;
  const TelaCadastroAbastecimento({super.key, this.abastecimento, required this.veiculoId});

  @override
  State<TelaCadastroAbastecimento> createState() => _TelaCadastroAbastecimentoState();
}

class _TelaCadastroAbastecimentoState extends State<TelaCadastroAbastecimento> {
  late final litros = TextEditingController(text: widget.abastecimento?.litros.toString() ?? '');
  late final valorLitro = TextEditingController(text: widget.abastecimento?.valorLitro.toString() ?? '');
  late final data = TextEditingController(text: widget.abastecimento?.data.toLocal().toString().substring(0, 10) ?? DateTime.now().toIso8601String().substring(0, 10));

  @override
  void dispose() {
    litros.dispose();
    valorLitro.dispose();
    data.dispose();
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
        elevation: 10,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurple, Colors.blueAccent]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 120),
            Text(isEdit ? "Editar Abastecimento" : "Novo Abastecimento", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _campo("Litros", litros, tipo: TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 5),
            _campo("Valor por Litro", valorLitro, tipo: TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 5),
            _campo("DATA (AAAA-MM-DD)", data),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(17),
                color: Colors.greenAccent,
                onPressed: provider.carregando
                    ? null
                    : () async {
                        final l = double.tryParse(litros.text) ?? 0;
                        final v = double.tryParse(valorLitro.text) ?? 0;
                        final d = DateTime.tryParse(data.text) ?? DateTime.now();

                        if (l <= 0 || v <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PREENCHA OS CAMPOS CORRETAMENTE -_-")));
                          return;
                        }
                        final total = l * v;

                        if (isEdit) {
                          final a = widget.abastecimento!.copyWith(litros: l, valorLitro: v, valorTotal: total, data: d);
                          final ok = await provider.atualizar(widget.veiculoId, a);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? "ATUALIZADO" : "ERRO")));
                        } else {
                          final a = Abastecimento(id: '', litros: l, valorLitro: v, valorTotal: total, data: d);
                          final ok = await provider.adicionar(widget.veiculoId, a);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? "Salvo" : "ERRO")));
                        }
                        if (mounted) Navigator.pop(context);
                      },
                child: provider.carregando
                    ? const CupertinoActivityIndicator(color: Colors.black)
                    : Text(isEdit ? "ATUALIZAR" : "SALVAR", style: const TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.white70, width: 0.8), borderRadius: BorderRadius.circular(7)),
              child: CupertinoButton(
                child: const Text("CANCELAR", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo(String placeholder, TextEditingController controller, {TextInputType tipo = TextInputType.text}) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: tipo,
      cursorColor: Colors.white,
      padding: const EdgeInsets.all(15),
      placeholder: placeholder,
      placeholderStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: const BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.all(Radius.circular(7))),
    );
  }
}