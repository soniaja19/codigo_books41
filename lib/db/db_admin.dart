import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBAdmin {
  Database? _myDatabase;

  static final DBAdmin _instance = DBAdmin._mandarina();
  DBAdmin._mandarina(); //se coloca el _ con el nombre mandarina, no es necesario colocar ese nombre.
  factory DBAdmin() {
    return _instance;
  }
  Future<Database?> _checkDatabase() async {
    _myDatabase ??= await _initDataBase();
    return _myDatabase;
  }

  //Creando base dedatos
  Future<Database> _initDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    // esto es para revisar en que carpeta se encuentra la BD print(directory);
    String pahtDatabase = join(directory.path, "BDBooks.db");
    return await openDatabase(
      pahtDatabase,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE BOOK(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, description TEXT, image TEXT)");
      },
    );
  }

  //Consultas
// para obtener la información de la bd
  getBooksRaw() async {
    Database? db = await _checkDatabase();
    //List data = await db!.rawQuery("SELECT * FROM Book");
    List data = await db!.rawQuery("SELECT id, title * FROM Book WHERE id = 3");
    for (var element in data) {
      print(element);
    }

//////////Otra manera de imprimir la base de
    // data.forEach ((element) {
    //  print(element);
    //)};
  }

//segunda opcion para obtener la información de bd
  getBooks() async {
    Database? db = await _checkDatabase();
    // List data = await db!.query("Book"); //Para conocer toda la base de datos
    //Para conocer las columnas que deseo mostrar
    List data = await db!.query("Book", columns: ["id", "author"]);
    // await db!.query("Book", columns: ["id", "author"], where: "id = 3");
    print(data);
  }

  //Inserciones
  inserbookRaw() async {
    Database? db = await _checkDatabase();
    db!.rawInsert(
        "INSERT INTO BOOK(title, author, description, image) VALUES ('El mundo es ancho y ajeno','Ciro Alegría','Lorem ipsum','https://......')");
  }

  //Inserciones, otro ejemplo de insercción
  insertBooks() async {
    Database? db = await _checkDatabase();
    db!.insert(
      "BOOK",
      {
        "title": "Yawar Fiesta",
        "author": "Jose María Arguedas",
        "description": "Lorem ipsum",
        "image": "https://......",
      },
    );
  }

  //Actualizaciones
  //Primera opción para actualizar
  updateBookRaw() async {
    Database? db = await _checkDatabase();
    int value = await db!
        .rawUpdate("UPDATE Book set title = 'Aves sin nido' WHERE id = 4");
    print(value);
  }

  //Segunda opción para actualizar
  updateBook() async {
    Database? db = await _checkDatabase();
    int value = await db!.update(
      "Book",
      {
        "title": "1992",
      },
      where:
          "id = 3", //es importante colocar esta sentencia si se desea actualizar solo un dato.
    );
  }

  //Eliminar
  //Primera opción para eliminar
  deleteBookRaw() async {
    Database? db = await _checkDatabase();
    int value = await db!.rawDelete("DELATE FROM Book WHERE id = 11");
    print(value);
  }

  //Segundo opción para eliminar
  deleteBook() async {
    Database? db = await _checkDatabase();
    int value = await db!.delete("Book", where: "id=11");
    print(value);
  }
}