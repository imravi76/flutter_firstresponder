import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'Models/rule.dart';

class DatabaseHelper{
  Future<Database> database() async{
    return openDatabase(
      join(await getDatabasesPath(), 'responder.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE rules(id INTEGER KEY PRIMARY KEY, status TEXT, received_msg TEXT, reply_message TEXT, reply_count TEXT, contacts TEXT, ignored_contacts TEXT)");
      },
      version: 1,
    );
  }

  Future<void> insertRule(Rule rule) async{
    //int ruleId = 0;
    Database db = await database();
    await db.insert('rules', rule.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      //ruleId = value;
    //});
    //return ruleId;
  }

  Future<List<Rule>> getRules() async{
    final db = await database();
    var res = await db.query("rules");
    List<Rule> ruleMap = res.map((c) => Rule.fromMap(c)).toList();
    return ruleMap ;
  }

  deleteRule(int id) async {
    final db = await database();
    return db.delete("rules", where: "id = ?", whereArgs: [id]);
  }

  updateRule(Rule rule) async {
    final db = await database();
    var response = await db.update("rules", rule.toMap(),
        where: "id = ?", whereArgs: [rule.id]);
    return response;
  }

  Future<Rule?> getRuleWithId(int id) async {
    final db = await database();
    var response = await db.query("rules", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Rule.fromMap(response.first) : null;
  }

  Future<Rule?> getRuleWithStatus(String status) async {
    final db = await database();
    var response = await db.query("rules", where: "status = ?", whereArgs: [status]);
    return response.isNotEmpty ? Rule.fromMap(response.first) : null;
  }

}