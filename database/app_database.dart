// Importações principais do Drift
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// Parte gerada automaticamente (com build_runner) iremos gerar com o comando:
//flutter pub run build_runner build
//Ele faz isso a partir do que definimos aqui nesta classe
part 'app_database.g.dart';

// Definição da tabela de clientes
class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()(); // Chave primária
  TextColumn get nome => text()();                // Nome obrigatório
  TextColumn get cpf => text()();                 // CPF obrigatório
  TextColumn get telefone => text()();            // Telefone obrigatório
}

// Classe principal do banco (DriftDatabase)
@DriftDatabase(tables: [Clientes])
class AppDatabase extends _$AppDatabase {
  // Construtor chamando a função que abre o banco
  AppDatabase() : super(_abrirConexao());

  // Versão do schema do banco
  @override
  int get schemaVersion => 1;

  // CRUD: inserir cliente
  Future<int> inserirCliente(ClientesCompanion cliente) =>
      into(clientes).insert(cliente);

  // Listar todos os clientes
  Future<List<Cliente>> listarClientes() =>
      select(clientes).get();

  // Atualizar cliente existente
  Future<bool> atualizarCliente(Cliente cliente) =>
      update(clientes).replace(cliente);

  // Excluir cliente por ID
  Future<int> excluirCliente(int id) =>
      (delete(clientes)..where((t) => t.id.equals(id))).go();
}

//Future - Significa que a operação é assíncrona (vai acontecer no futuro).
//No Flutter (e no Dart em geral), todas as operações de banco de dados, rede, disco etc. são assíncronas para não travar a interface do usuário.

// Função que cria e retorna a instância do banco
LazyDatabase _abrirConexao() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory(); // pasta local do app
    final path = p.join(dir.path, 'clientes.db');         // nome do arquivo do banco
    return NativeDatabase(File(path));                    // retorna o banco SQLite nativo
  });
}
