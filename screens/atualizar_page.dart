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
  // Controlador para gerenciar o texto que aparece dentro do campo (TextField)
  final _nomeController = TextEditingController();
  
  // O símbolo '?' significa que esta variável pode ser nula (começa vazia)
  // Usamos isso porque nenhum cliente está selecionado quando a tela abre
  Cliente? _clienteSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Atualizar Cliente')),
      body: Column(
        children: [
          // Expanded faz a lista ocupar todo o espaço disponível no topo
          Expanded(
            child: FutureBuilder<List<Cliente>>(
              future: db.listarClientes(), // Busca a lista atualizada no SQLite
              builder: (context, snapshot) {
                // Enquanto o banco não responde, mostra o círculo de carregamento
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                
                return ListView.builder(
                  // 'snapshot.data!' -> O '!' diz: "Dart, eu garanto que os dados chegaram, pode ler o tamanho da lista"
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // Pega o cliente específico da posição 'index'
                    final c = snapshot.data![index];
                    return ListTile(
                      title: Text(c.nome), // Mostra o nome na lista
                      trailing: Icon(Icons.edit), // Ícone de lápis à direita
                      onTap: () {
                        // setState avisa o Flutter para redesenhar a tela com novos dados
                        setState(() {
                          _clienteSelecionado = c; // Guarda o cliente clicado na variável
                          _nomeController.text = c.nome; // Coloca o nome dele no campo de texto
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          
          // 'if' dentro da lista: O formulário só aparece se existir um cliente selecionado
          if (_clienteSelecionado != null)
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.blue[50], // Fundo azul clarinho para destacar que é edição
              child: Column(
                children: [
                  // '_clienteSelecionado!' -> Como o 'if' acima já testou que não é nulo, 
                  // usamos o '!' para acessar a propriedade '.nome' com segurança.
                  Text('Editando: ${_clienteSelecionado!.nome}', 
                       style: TextStyle(fontWeight: FontWeight.bold)),
                  
                  TextField(
                    controller: _nomeController, // O texto digitado fica guardado aqui
                    decoration: InputDecoration(labelText: 'Novo Nome'),
                  ),
                  SizedBox(height: 10),
                  
                  ElevatedButton(
                    onPressed: () async {
                      // Criamos um novo objeto 'Cliente' com os dados atualizados
                      // Mas mantemos o mesmo 'id' para o banco saber qual registro alterar
                      final clienteAtualizado = Cliente(
                        id: _clienteSelecionado!.id, // '!' garante que temos o ID do selecionado
                        nome: _nomeController.text,  // Pega o que o usuário digitou agora
                        cpf: _clienteSelecionado!.cpf,
                        telefone: _clienteSelecionado!.telefone,
                      );

                      // Envia para o método 'replace' lá no AppDatabase
                      await db.atualizarCliente(clienteAtualizado);

                      // Após salvar, resetamos a tela
                      setState(() {
                        _clienteSelecionado = null; // Esconde o formulário de edição
                        _nomeController.clear();    // Limpa o campo de texto
                      });

                      // Feedback visual para o usuário
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cliente atualizado com sucesso!')),
                      );
                    },
                    child: Text('Confirmar Alteração'),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
