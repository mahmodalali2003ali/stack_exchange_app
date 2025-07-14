import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:stack_exchange_app/features/questions/data/datasources/local/local_storage.dart';
import 'dart:developer';
import '../../models/question_model.dart';

class SqliteStorage implements LocalStorage {
  static Database? _db;

  @override
  Future<void> init() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'questions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE questions(
            id INTEGER PRIMARY KEY,
            title TEXT,
            body TEXT,
            score INTEGER,
            viewCount INTEGER,
            answerCount INTEGER,
            isAnswered INTEGER,
            creationDate TEXT,
            owner_name TEXT,
            owner_profile_image TEXT,
            tags TEXT,
            link TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<void> insertQuestion(QuestionModel question) async {
    final db = await database;
    await db.insert(
      'questions',
      question.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    log('📋 SqliteStorage: تم إدراج سؤال ID: ${question.id}');
  }

  @override
  Future<List<QuestionModel>> getAllQuestions() async {
    final db = await database;
    final maps = await db.query('questions');
    final questions = maps.map((map) => QuestionModel.fromJson(map)).toList();
    log('📋 SqliteStorage: جلب ${questions.length} سؤال من التخزين المحلي');
    return questions;
  }

  @override
  Future<void> clearQuestions() async {
    final db = await database;
    await db.delete('questions');
    log('📋 SqliteStorage: تم مسح جميع الأسئلة');
  }

  @override
  Future<int> getQuestionCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM questions');
    final count = Sqflite.firstIntValue(result) ?? 0;
    log('📋 SqliteStorage: عدد الأسئلة: $count');
    return count;
  }
}