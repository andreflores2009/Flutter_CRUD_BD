// Importa o pacote do Flutter para construir a interface
import 'package:flutter/material.dart';

// Importa a classe do banco de dados
import '../database/app_database.dart';

// Tela sem estado que exibe a lista de clientes cadastrados
class ListarPage extends StatelessWidget {
  // Cria uma instância do banco de dados Drift
  final db = AppDatabase();

  // Método que constrói a interface gráfica da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior da tela com título
      appBar: AppBar(title: Text('Lista de Clientes')),

      // Corpo da tela com carregamento assíncrono dos dados
      body: FutureBuilder(
        future: db.listarClientes(), // Chama o método para buscar os clientes do banco

        // Constrói os widgets de acordo com o estado do carregamento
        builder: (context, snapshot) {
          // Enquanto os dados ainda estão sendo carregados
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator()); // Mostra o círculo de carregamento
          }

          // Quando os dados forem carregados com sucesso
          final clientes = snapshot.data!; // Lista de clientes retornada

          // Cria uma lista visual com os clientes
          return ListView.builder(
            itemCount: clientes.length, // Quantidade de itens na lista

            // Função que monta cada item da lista
            itemBuilder: (context, index) {
              final cliente = clientes[index]; // Cliente atual da lista

              // Widget que representa visualmente um cliente na lista
              return ListTile(
                title: Text(cliente.nome), // Exibe o nome como título
                subtitle: Text(
                  'CPF: ${cliente.cpf} - Tel: ${cliente.telefone}', // Exibe CPF e telefone
                ),
              );
            },
          );
        },
      ),
    );
  }
}
