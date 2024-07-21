import 'package:tugasuprak/model/model_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // inisialisasi beberapa variabel yang dibutuhkan
  final String tableName = 'tbl_keuangan';
  final String columnId = 'id';
  final String columnTipe = 'tipe';
  final String columnKet = 'keterangan';
  final String columnJmlUang = 'jml_uang';
  final String columnTgl = 'tanggal';

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  // Cek apakah ada database
  Future<Database?> get checkDB async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'keuangan.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Membuat tabel dan field -fieldnya
  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, "
        "$columnTipe TEXT, "
        "$columnKet TEXT, "
        "$columnJmlUang TEXT,"
        "$columnTgl TEXT)";
    await db.execute(sql);
  }

  // Insert ke database
  Future<int?> saveData(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.insert(tableName, modelDatabase.toMap());
  }

  // Read data pemasukan
  Future<List?> getDataPemasukan() async {
    var dbClient = await checkDB;
    var result = await dbClient!.rawQuery(
        'SELECT * FROM $tableName WHERE $columnTipe = ?', ['pemasukan']);
    return result.toList();
  }

  // Read data pengeluaran
  Future<List?> getDataPengeluaran() async {
    var dbClient = await checkDB;
    var result = await dbClient!.rawQuery(
        'SELECT * FROM $tableName WHERE $columnTipe = ?', ['pengeluaran']);
    return result.toList();
  }

  // Read data jumlah pemasukan
  Future<int> getJmlPemasukan() async {
    var dbClient = await checkDB;
    var queryResult = await dbClient!.rawQuery(
        'SELECT SUM(jml_uang) AS TOTAL from $tableName WHERE $columnTipe = ?',
        ['pemasukan']);
    int total = int.parse(queryResult[0]['TOTAL'].toString());
    return total;
  }

  // Read data jumlah pengeluaran
  Future<int> getJmlPengeluaran() async {
    var dbClient = await checkDB;
    var queryResult = await dbClient!.rawQuery(
        'SELECT SUM(jml_uang) AS TOTAL from $tableName WHERE $columnTipe = ?',
        ['pengeluaran']);
    int total = int.parse(queryResult[0]['TOTAL'].toString());
    return total;
  }

  // Update database pemasukan
  Future<int?> updateDataPemasukan(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.update(tableName, modelDatabase.toMap(),
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [modelDatabase.id, 'pemasukan']);
  }

  // Update database pengeluaran
  Future<int?> updateDataPengeluaran(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.update(tableName, modelDatabase.toMap(),
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [modelDatabase.id, 'pengeluaran']);
  }

  // Cek database pemasukan
  Future<int?> cekDataPemasukan() async {
    var dbClient = await checkDB;
    return Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE $columnTipe = ?',
        ['pemasukan']));
  }

  // Cek database pengeluaran
  Future<int?> cekDataPengeluaran() async {
    var dbClient = await checkDB;
    return Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE $columnTipe = ?',
        ['pengeluaran']));
  }

  // Hapus database pemasukan
  Future<int?> deletePemasukan(int id) async {
    var dbClient = await checkDB;
    return await dbClient!.delete(tableName,
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [id, 'pemasukan']);
  }

  // Hapus database pemasukan
  Future<int?> deletePengeluaran(int id) async {
    var dbClient = await checkDB;
    return await dbClient!.delete(tableName,
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [id, 'pengeluaran']);
  }
}
