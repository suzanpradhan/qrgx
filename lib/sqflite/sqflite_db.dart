import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


Future<Database> get database async{
  return await dbSqflite();
}

dbSqflite() async{
  return  await openDatabase(
  join(await getDatabasesPath(),"qrcodes.db"),

  onCreate: (db, version){
    return db.execute(
      "CREATE TABLE qrcodesTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, base64 TEXT)"
    );
    
  },
  version: 1
);

}

Future<void> insertQR(String base) async{

  final Database db = await database;

  await db.insert("qrcodesTable", 
  {
    "base64" : base

  }
  
  );
}

Future<List> viewQR() async{
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query("qrcodesTable");

    return List.generate(maps.length, (i){

      return {
        "id": maps[i]["id"],
        "base64": maps[i]["base64"]
      };

    });
}