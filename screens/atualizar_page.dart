// Importa pacotes necessários
import 'package:flutter/material.dart';
import '../database/app_database.dart';

class AtualizarPage extends StatefulWidget {
  @override
  _AtualizarPageState createState() => _AtualizarPageState();
}

class _AtualizarPageState extends State<AtualizarPage> {
  // Instancia o banco de dados
  final db = AppDatabase();
  // Controlador para o campo de edição de texto
  final _nomeController = TextEditingController();
  // Variável para armazenar qual cliente foi selecionado para edição
  Cliente? _clienteSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Atualizar Cliente')),
      body: Column(
        children: [
          // Parte de cima: Lista de clientes para selecionar
          Expanded(
            child: FutureBuilder<List<Cliente>>(
              future: db.listarClientes(), // Busca clientes do banco
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final c = snapshot.data![index];
                    return ListTile(
                      title: Text(c.nome), // Nome do cliente
                      trailing: Icon(Icons.edit), // Ícone de edição
                      onTap: () {
                        // Ao clicar, define o cliente selecionado e preenche o campo de texto
                        setState(() {
                          _clienteSelecionado = c;
                          _nomeController.text = c.nome;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          
          // Parte de baixo: Só aparece se um cliente for selecionado para editar
          if (_clienteSelecionado != null)
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.blue[50], // Cor de fundo leve para destacar a edição
              child: Column(
                children: [
                  Text('Editando: ${_clienteSelecionado!.nome}'), // Mostra quem está editando
                  TextField(
                    controller: _nomeController, // Campo para digitar o novo nome
                    decoration: InputDecoration(labelText: 'Novo Nome'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // Cria um novo objeto Cliente com o ID antigo mas o nome novo
                      final clienteAtualizado = Cliente(
                        id: _clienteSelecionado!.id,
                        nome: _nomeController.text,
                        cpf: _clienteSelecionado!.cpf,
                        telefone: _clienteSelecionado!.telefone,
                      );

                      // Chama o método atualizarCliente do seu AppDatabase
                      await db.atualizarCliente(clienteAtualizado);

                      // Limpa a seleção e o campo de texto
                      setState(() {
                        _clienteSelecionado = null;
                        _nomeController.clear();
                      });

                      // Mensagem de sucesso
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cliente atualizado com sucesso!')),
                      );
                    },
                    child: Text('Confirmar Alteração'), // Texto do botão
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}