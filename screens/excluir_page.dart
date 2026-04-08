// Importa os componentes de interface do Flutter
import 'package:flutter/material.dart';
// Importa o arquivo do banco de dados para acessar os métodos de CRUD
import '../database/app_database.dart';

class ExcluirPage extends StatefulWidget {
  @override
  _ExcluirPageState createState() => _ExcluirPageState();
}

class _ExcluirPageState extends State<ExcluirPage> {
  // Instancia o banco de dados
  final db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excluir Clientes'), // Título da tela
      ),
      // FutureBuilder busca a lista de clientes uma vez ao carregar a tela
      body: FutureBuilder<List<Cliente>>(
        future: db.listarClientes(), // Chama o método de listagem do seu AppDatabase
        builder: (context, snapshot) {
          // Verifica se os dados ainda estão sendo carregados
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator()); // Mostra ícone de carregamento
          }

          // Armazena a lista de clientes retornada pelo banco
          final clientes = snapshot.data!;

          // Constrói uma lista rolável na tela
          return ListView.builder(
            itemCount: clientes.length, // Quantidade de itens na lista
            itemBuilder: (context, index) {
              final cliente = clientes[index]; // Pega o cliente da posição atual
              return ListTile(
                title: Text(cliente.nome), // Mostra o nome do cliente
                subtitle: Text('CPF: ${cliente.cpf}'), // Mostra o CPF abaixo do nome
                // Ícone de lixeira no lado direito do item
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red), // Ícone vermelho para indicar exclusão
                  onPressed: () async {
                    // Chama o método excluirCliente passando o ID (conforme seu AppDatabase)
                    await db.excluirCliente(cliente.id);
                    
                    // Mostra uma mensagem de confirmação na parte inferior
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cliente ${cliente.nome} removido!')),
                    );

                    // Recarrega a tela para atualizar a lista após a exclusão
                    setState(() {}); 
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}