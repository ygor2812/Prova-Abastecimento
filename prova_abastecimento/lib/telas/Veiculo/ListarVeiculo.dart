import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/veiculoProvider.dart';
import 'CadastroVeiculo.dart';
import 'package:flutter/cupertino.dart';



class TelaListarVeiculos extends StatefulWidget {
  const TelaListarVeiculos({super.key});

  @override
  State<TelaListarVeiculos> createState() => _TelaListarVeiculosState();
}

class _TelaListarVeiculosState extends State<TelaListarVeiculos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VeiculoProvider>().carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VeiculoProvider>();

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
          children: [
            const SizedBox(height: 120),
            const Text(
              "Meus Veículos",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: provider.lista.isEmpty
                  ? const Center(child: Text("Nenhum veículo", style: TextStyle(color: Colors.white70)))
                  : ListView.builder(
                      itemCount: provider.lista.length,
                      itemBuilder: (_, i) {
                        final v = provider.lista[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(v.modelo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            subtitle: Text("${v.marca} | ${v.ano}", style: const TextStyle(color: Colors.white70)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.black),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/editar-veiculo', arguments: v);
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
                                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
                                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Excluir", style: TextStyle(color: Colors.redAccent))),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await provider.deletar(v.id);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Excluído")));
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.local_gas_station, color: Colors.greenAccent),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/abastecimentos', arguments: v.id);
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
              child: ElevatedButton(
                style:ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(17),
                ),
                child: const Text("NOVO VEÍCULO", style: TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w600)),
                onPressed: () => Navigator.pushNamed(context, '/novo-veiculo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}