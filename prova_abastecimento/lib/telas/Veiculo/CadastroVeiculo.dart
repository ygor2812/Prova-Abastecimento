import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/veiculoProvider.dart';
import '../../models/veiculo.dart';


class TelaCadastroVeiculo extends StatefulWidget {
  final Veiculo? veiculo;
  const TelaCadastroVeiculo({super.key, this.veiculo});

  @override
  State<TelaCadastroVeiculo> createState() => _TelaCadastroVeiculoState();
}

class _TelaCadastroVeiculoState extends State<TelaCadastroVeiculo> {
  late final modelo = TextEditingController(text: widget.veiculo?.modelo ?? '');
  late final marca = TextEditingController(text: widget.veiculo?.marca ?? '');
  late final placa = TextEditingController(text: widget.veiculo?.placa ?? '');
  late final ano = TextEditingController(text: widget.veiculo?.ano.toString() ?? '');
  late final tipo = TextEditingController(text: widget.veiculo?.tipoCombustivel ?? '');

  @override
  void dispose() {
    modelo.dispose();
    marca.dispose();
    placa.dispose();
    ano.dispose();
    tipo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VeiculoProvider>();
    final isEdit = widget.veiculo != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
          "assets/imagem/posto.jpg",
          width: 300,
          height: 150,
        ),
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
            Text(
              isEdit ? "Editar Veículo" : "Novo Veículo",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            _campo("Modelo", modelo),
            const SizedBox(height: 5),
            _campo("Marca", marca),
            const SizedBox(height: 5),
            _campo("Placa", placa),
            const SizedBox(height: 5),
            _campo("Ano", ano, tipo: TextInputType.number),
            const SizedBox(height: 5),
            _campo("Combustível", tipo),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(17),
                backgroundColor: Colors.greenAccent,
                foregroundColor:Colors.black87,
                ),
                onPressed: provider.carregando
                    ? null
                    : () async {
                        if ([modelo, marca, placa, ano, tipo]
                            .any((c) => c.text.trim().isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Preencha todos os campos")),
                          );
                          return;
                        }

                        final anoInt = int.tryParse(ano.text) ?? 0;

                        if (isEdit) {
                          final v = widget.veiculo!.copyWith(
                            modelo: modelo.text,
                            marca: marca.text,
                            placa: placa.text,
                            ano: anoInt,
                            tipoCombustivel: tipo.text,
                          );
                          final ok = await provider.atualizar(v);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(ok
                                  ? "Veículo atualizado"
                                  : (provider.erro ?? "Erro")),
                            ),
                          );
                        } else {
                          final novoVeiculo = Veiculo(
                            id: '',
                            modelo: modelo.text,
                            marca: marca.text,
                            placa: placa.text,
                            ano: anoInt,
                            tipoCombustivel: tipo.text,
                          );
                          final ok = await provider.adicionar(novoVeiculo);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(ok
                                  ? "Veículo salvo"
                                  : (provider.erro ?? "Erro")),
                            ),
                          );
                        }

                        if (mounted) Navigator.pop(context);
                      },
                child: provider.carregando
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                        isEdit ? "ATUALIZAR" : "SALVAR",
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 0.8),
                borderRadius: BorderRadius.circular(7),
              ),
              child: ElevatedButton(
                child: const Text(
                  "CANCELAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo(
    String placeholder,
    TextEditingController controller, {
    TextInputType tipo = TextInputType.text,
  }) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: tipo,
      cursorColor: Colors.white,
      padding: const EdgeInsets.all(15),
      placeholder: placeholder,
      placeholderStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: const BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
    );
  }
}