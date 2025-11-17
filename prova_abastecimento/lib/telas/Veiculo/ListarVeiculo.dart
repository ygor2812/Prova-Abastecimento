import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/veiculoProvider.dart';
import 'CadastroVeiculo.dart';

class TelaListaVeiculos extends StatelessWidget {
  const TelaListaVeiculos({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VeiculoProvider>();
    provider.carregar();

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
          children: [
            const SizedBox(height: 120),
            const Text("Meus Veículos", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: provider.veiculos.isEmpty
                  ? const Center(child: Text("Nenhum veículo cadastrado", style: TextStyle(color: Colors.white70)))
                  : ListView.builder(
                      itemCount: provider.veiculos.length,
                      itemBuilder: (_, i) {
                        final v = provider.veiculos[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text("${v.modelo} - ${v.placa}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            subtitle: Text("${v.marca} | ${v.ano} | ${v.tipoCombustivel}", style: const TextStyle(color: Colors.white70)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => TelaCadastroVeiculo(veiculo: v)),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor: Colors.deepPurple,
                                        title: const Text("Excluir?", style: TextStyle(color: Colors.white)),
                                        content: Text("Tem certeza que deseja excluir ${v.modelo}?", style: const TextStyle(color: Colors.white70)),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar", style: TextStyle(color: Colors.white))),
                                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Excluir", style: TextStyle(color: Colors.redAccent))),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await provider.deletar(v.id);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veículo excluído")));
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
                child: const Text("ADICIONAR VEÍCULO", style: TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w600)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaCadastroVeiculo())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}