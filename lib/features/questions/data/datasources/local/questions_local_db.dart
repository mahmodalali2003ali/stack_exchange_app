import '../../models/question_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuestionsLocalDb {
  static Database? _db;

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

  Future<void> insertQuestion(QuestionModel question) async {
    final db = await database;
    await db.insert(
      'questions',
      question.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QuestionModel>> getAllQuestions() async {
    final db = await database;
    final maps = await db.query('questions');
    return maps.map((map) => QuestionModel.fromJson(map)).toList();
  }

  Future<void> clearQuestions() async {
    final db = await database;
    await db.delete('questions');
  }
}
