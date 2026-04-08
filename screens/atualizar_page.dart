// Importa os pacotes fundamentais do Flutter para a interface
import 'package:flutter/material.dart';
// Importa o arquivo onde definimos a estrutura do banco e nossos métodos CRUD
import '../database/app_database.dart';

class AtualizarPage extends StatefulWidget {
  @override
  _AtualizarPageState createState() => _AtualizarPageState();
}

class _AtualizarPageState extends State<AtualizarPage> {
  // Instancia a conexão com o banco de dados
  final db = AppDatabase();
  
  // O TextEditingController serve para "ler" o que o usuário digita e também para "escrever"
  // texto dentro do campo programaticamente (usamos para carregar o nome atual do cliente).
  final _nomeController = TextEditingController();
  
  // Variável que guarda o objeto do cliente que clicamos na lista.
  // O símbolo '?' indica que ela pode ser NULA (vazia), o que é verdade até o usuário clicar em alguém.
  Cliente? _clienteSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Atualizar Cliente')),
      // Usamos Column para colocar a lista em cima e o formulário de edição embaixo
      body: Column(
        children: [
          // Expanded: Faz a lista ocupar todo o espaço que sobrar na tela.
          Expanded(
            child: FutureBuilder<List<Cliente>>(
              // Busca a lista de clientes para que o professor/aluno possa escolher quem editar
              future: db.listarClientes(), 
              builder: (context, snapshot) {
                // Enquanto o banco "pensa", mostramos a animação de carregamento
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                
                // 'snapshot.data!' -> O '!' força o Dart a aceitar que os dados existem.
                // Usamos isso após o 'if' acima garantir que 'hasData' é verdadeiro.
                final listaDeClientes = snapshot.data!;

                return ListView.builder(
                  itemCount: listaDeClientes.length,
                  itemBuilder: (context, index) {
                    final c = listaDeClientes[index];
                    return ListTile(
                      title: Text(c.nome), 
                      subtitle: Text('CPF: ${c.cpf}'),
                      trailing: Icon(Icons.edit, color: Colors.blue), // Ícone visual de edição
                      onTap: () {
                        // O 'setState' reconstrói a tela para mostrar o formulário de edição embaixo
                        setState(() {
                          _clienteSelecionado = c; // "Este é o cliente que eu quero mudar"
                          _nomeController.text = c.nome; // Já preenche o campo com o nome atual
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          
          // LÓGICA CONDICIONAL: O bloco abaixo só será "desenhado" se houver um cliente selecionado.
          // Se '_clienteSelecionado' for nulo, o Flutter pula todo este bloco de código.
          if (_clienteSelecionado != null)
            Container(
              padding: EdgeInsets.all(20),
              // Decoração para destacar a área de edição da lista comum
              decoration: BoxDecoration(
                color: Colors.blue[50], // Fundo azul bem claro
                border: Border(top: BorderSide(color: Colors.blue, width: 2)),
              ),
              child: Column(
                children: [
                  // O '!' aqui diz ao Dart: "Pode ler o .nome, eu já conferi que não é nulo no 'if' acima"
                  Text('Editando Dados de: ${_clienteSelecionado!.nome}', 
                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                  
                  const SizedBox(height: 10),

                  TextField(
                    controller: _nomeController, 
                    decoration: InputDecoration(
                      labelText: 'Digite o novo nome',
                      border: OutlineInputBorder(), // Dá um visual mais moderno ao campo
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  ElevatedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text('CONFIRMAR ALTERAÇÃO'),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                    onPressed: () async {
                      // Criamos um novo objeto com os dados que o usuário alterou.
                      // IMPORTANTE: Mantemos o ID original, senão o Drift não saberia qual linha atualizar.
                      final clienteAtualizado = Cliente(
                        id: _clienteSelecionado!.id, 
                        nome: _nomeController.text,  // Pegamos o novo nome do controlador
                        cpf: _clienteSelecionado!.cpf, // Mantemos o CPF antigo
                        telefone: _clienteSelecionado!.telefone, // Mantemos o telefone antigo
                      );

                      // O método 'atualizarCliente' (replace) procura no SQLite o ID correspondente
                      // e substitui todos os dados daquela linha pelos dados deste novo objeto.
                      await db.atualizarCliente(clienteAtualizado);

                      // Limpamos tudo para o app voltar ao estado original (apenas a lista aparecendo)
                      setState(() {
                        _clienteSelecionado = null; 
                        _nomeController.clear();
                      });

                      // Mensagem de sucesso (Feedback para o aluno)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Nome atualizado com sucesso!'), backgroundColor: Colors.green),
                      );
                    },
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
