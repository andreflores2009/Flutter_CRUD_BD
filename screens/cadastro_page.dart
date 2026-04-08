// Importa os componentes principais do Flutter para construir a interface da tela
import 'package:flutter/material.dart';

// Importa o banco de dados e a tabela de clientes definidos com Drift
import '../database/app_database.dart';

// Importa a biblioteca Drift com alias 'drift' para evitar conflitos com widgets como Column
import 'package:drift/drift.dart' as drift;

// Define um widget com estado que representa a tela de cadastro
class CadastroPage extends StatefulWidget {
  // Cria o estado associado a essa tela
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

// Classe de estado associada à tela de cadastro
class _CadastroPageState extends State<CadastroPage> {
  // Chave global para controle e validação do formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para capturar os dados digitados pelo usuário
  final _nomeController = TextEditingController();     // Controla o campo Nome
  final _cpfController = TextEditingController();      // Controla o campo CPF
  final _telefoneController = TextEditingController(); // Controla o campo Telefone

  // Instância do banco de dados que será usada para salvar os dados
  final db = AppDatabase();

  // Método responsável por construir a interface da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Permite que a tela se ajuste quando o teclado estiver visível
      resizeToAvoidBottomInset: true,

      // Barra superior da tela com título
      appBar: AppBar(
        title: Text('Cadastrar Cliente'), // Título exibido no AppBar
      ),

      // Corpo principal da tela com rolagem para evitar problemas com teclado
      body: SingleChildScrollView(
        // Define espaçamento interno da tela
        padding: const EdgeInsets.all(16.0),

        // Formulário que agrupa os campos de entrada
        child: Form(
          key: _formKey, // Liga a chave do formulário para validação

          // Coluna vertical com os widgets de entrada e botões
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Altera o alinhamento para esticar os botões na largura total

            children: [
              // Campo de entrada de texto para o nome do cliente
              TextFormField(
                controller: _nomeController, // Liga ao controlador do nome
                decoration: InputDecoration(labelText: 'Nome'), // Define rótulo
                validator: (value) {
                  // Função de validação: verifica se o campo está vazio
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome'; // Mensagem de erro
                  }
                  return null; // Tudo certo
                },
              ),

              // Campo de entrada para CPF
              TextFormField(
                controller: _cpfController, // Liga ao controlador do CPF
                decoration: InputDecoration(labelText: 'CPF'), // Rótulo do campo
                keyboardType: TextInputType.number, // Define o teclado como numérico para facilitar o preenchimento
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o CPF';
                  }
                  return null;
                },
              ),

              // Campo de entrada para telefone
              TextFormField(
                controller: _telefoneController, // Liga ao controlador do telefone
                decoration: InputDecoration(labelText: 'Telefone'), // Rótulo
                keyboardType: TextInputType.phone, // Define o teclado para padrão de telefone
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o telefone';
                  }
                  return null;
                },
              ),

              // Espaçamento vertical entre os campos e o botão
              const SizedBox(height: 30), // Aumentado o espaço para 30 pixels para melhor visualização

              // Botão de salvar cliente no banco
              ElevatedButton(
                // Define um estilo para o botão de salvar
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15), // Adiciona preenchimento vertical interno no botão
                ),
                // Ação executada ao pressionar o botão
                onPressed: () async {
                  // Valida todos os campos do formulário
                  if (_formKey.currentState!.validate()) {
                    // Cria um objeto do tipo ClientesCompanion com os valores digitados
                    final cliente = ClientesCompanion(
                      nome: drift.Value(_nomeController.text),         // Nome digitado
                      cpf: drift.Value(_cpfController.text),           // CPF digitado
                      telefone: drift.Value(_telefoneController.text), // Telefone digitado
                    );

                    // Insere o cliente no banco de dados através do método definido no Drift
                    await db.inserirCliente(cliente);

                    // Exibe uma mensagem de confirmação com SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cliente salvo com sucesso!')),
                    );

                    // Limpa os campos após a inserção
                    _nomeController.clear();
                    _cpfController.clear();
                    _telefoneController.clear();
                  }
                },
                // Texto exibido no botão
                child: Text('SALVAR CLIENTE'), // Texto em caixa alta para destaque
              ),

              // Espaço entre os dois botões
              const SizedBox(height: 12), // Espaço de 12 pixels entre os botões principais

              // Botão com borda para navegar até a tela de listagem de clientes (Substituindo o antigo TextButton)
              OutlinedButton(
                // Define um estilo para o botão de contorno
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15), // Adiciona preenchimento vertical interno
                  side: BorderSide(color: Colors.blue), // Define a cor da borda do botão
                ),
                onPressed: () {
                  // Usa o Navigator para ir para a rota '/listar'
                  Navigator.pushNamed(context, '/listar');
                },
                // Texto do botão de navegação agora dentro de um botão visível
                child: Text('VER LISTA DE CLIENTES'), // Texto em destaque
              ),
            ],
          ),
        ),
      ),
    );
  }
}
