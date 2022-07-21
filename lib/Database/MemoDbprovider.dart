import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import './memo_model.dart'; //import model class
import 'dart:io';
import 'dart:async';
class MemoDbProvider{
    
Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); 
    final path = join(directory.path,"memos.db"); 
      return await openDatabase( 
        path,
        version: 1,
        onCreate: (Database db,int version) async{
          await db.execute("""
          CREATE TABLE Memos(
          trackId INTEGER PRIMARY KEY AUTOINCREMENT,
          trackName TEXT,
          ArtistName TEXT,
          AlbumName TEXT)"""
      );
    });
  }
 
  Future<int> addItem(MemoModel item) async{ 
    
    final db = await init();
    
    return await db.insert("Memos", item.toMap(), 
    conflictAlgorithm: ConflictAlgorithm.ignore, 
    );
 }
 Future<List>query()async{
  final db = await init();
  return await db.query("Memos");
 }

 Future<int> deleteMemo(int id) async{ 
    final db = await init();
  
    int result = await db.delete(
      "Memos", 
      where: "id = ?",
      whereArgs: [id] 
    );
   

    return result;
  }
   deleteWholeRow()async{
      final db=await init();
      int result=await db.delete("Memos");
      return result;
      
    }
    
}