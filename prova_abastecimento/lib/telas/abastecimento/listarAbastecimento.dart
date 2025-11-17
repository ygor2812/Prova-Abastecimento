import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/abastecimentoProvider.dart';
import 'cadastroAbastecimento.dart';

class TelaListarAbastecimento extends StatefulWidget {
  final String veiculoId;
  const TelaListarAbastecimento({super.key, required this.veiculoId});

  @override
  State<TelaListarAbastecimento> createState() => _TelaListarAbastecimentoState();
}

class _TelaListarAbastecimentoState extends State<TelaListarAbastecimento> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AbastecimentoProvider>().carregar(widget.veiculoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AbastecimentoProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
          "assets/imagem/marcas-de-carros-de-luxo-lamborghini.jpg",
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
          children: [
            const SizedBox(height: 120),
            const Text(
              "Abastecimentos",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: provider.lista.isEmpty
                  ? const Center(
                      child: Text("Nenhum abastecimento", style: TextStyle(color: Colors.white70)),
                    )
                  : ListView.builder(
                      itemCount: provider.lista.length,
                      itemBuilder: (_, i) {
                        final a = provider.lista[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              "${a.litros}L × R\$${a.valorLitro.toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              "Total: R\$${a.valorTotal.toStringAsFixed(2)} | ${a.data.toLocal().toString().substring(0, 16)}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TelaCadastroAbastecimento(
                                          abastecimento: a,
                                          veiculoId: widget.veiculoId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor: Colors.deepPurple[800],
                                        title: const Text("Excluir?", style: TextStyle(color: Colors.white)),
                                        content: const Text("Tem certeza?", style: TextStyle(color: Colors.white70)),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text("Cancelar"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text("Excluir", style: TextStyle(color: Colors.redAccent)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await provider.deletar(widget.veiculoId, a.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Excluído")),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(17),
                color: Colors.greenAccent,
                child: const Text(
                  "NOVO ABASTECIMENTO",
                  style: TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TelaCadastroAbastecimento(veiculoId: widget.veiculoId),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}