// import 'dart:io';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:path/path.dart';
// import '../../models/question_model.dart';

// class QuestionsLocalDb {
//   static Database? _db;

//   QuestionsLocalDb() {
//     if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
//       databaseFactory = databaseFactoryFfi;
//     }
//   }

//   Future<Database> get database async {
//     if (_db != null) return _db!;
//     _db = await _initDb();
//     return _db!;
//   }

//   Future<Database> _initDb() async {
//     final path = join(await getDatabasesPath(), 'questions.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE questions(
//             id INTEGER PRIMARY KEY,
//             title TEXT,
//             body TEXT,
//             score INTEGER,
//             viewCount INTEGER,
//             answerCount INTEGER,
//             isAnswered INTEGER,
//             creationDate TEXT,
//             owner_name TEXT,
//             owner_profile_image TEXT,
//             tags TEXT,
//             link TEXT
//           )
//         ''');
//       },
//     );
//   }

//   Future<void> insertQuestion(QuestionModel question) async {
//     final db = await database;
//     await db.insert(
//       'questions',
//       question.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<QuestionModel>> getAllQuestions() async {
//     final db = await database;
//     final maps = await db.query('questions');
//     return maps.map((map) => QuestionModel.fromJson(map)).toList();
//   }

//   Future<void> clearQuestions() async {
//     final db = await database;
//     await db.delete('questions');
//   }

//   Future<int> getQuestionCount() async {
//     final db = await database;
//     final result = await db.rawQuery('SELECT COUNT(*) as count FROM questions');
//     return Sqflite.firstIntValue(result) ?? 0;
//   }
// }
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer';
import '../../models/question_model.dart';

class QuestionsLocalDb {
  static const String _boxName = 'questions';

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(QuestionModelAdapter().typeId)) {
      Hive.registerAdapter(QuestionModelAdapter());
    }
    await Hive.openBox<QuestionModel>(_boxName);
  }

  Future<void> insertQuestion(QuestionModel question) async {
    final box = await Hive.openBox<QuestionModel>(_boxName);
    await box.put(question.id, question);
    log('📋 QuestionsLocalDb: تم إدراج سؤال ID: ${question.id}');
  }

  Future<List<QuestionModel>> getAllQuestions() async {
    final box = await Hive.openBox<QuestionModel>(_boxName);
    final questions = box.values.toList();
    log('📋 QuestionsLocalDb: جلب ${questions.length} سؤال من التخزين المحلي');
    return questions;
  }

  Future<void> clearQuestions() async {
    final box = await Hive.openBox<QuestionModel>(_boxName);
    await box.clear();
    log('📋 QuestionsLocalDb: تم مسح جميع الأسئلة');
  }

  Future<int> getQuestionCount() async {
    final box = await Hive.openBox<QuestionModel>(_boxName);
    return box.length;
  }
}

class QuestionModelAdapter extends TypeAdapter<QuestionModel> {
  @override
  final int typeId = 0;

  @override
  QuestionModel read(BinaryReader reader) {
    return QuestionModel(
      id: reader.readInt(),
      title: reader.readString(),
      body: reader.readString(),
      score: reader.readInt(),
      viewCount: reader.readInt(),
      answerCount: reader.readInt(),
      isAnswered: reader.readBool(),
      creationDate: DateTime.parse(reader.readString()),
      ownerName: reader.readString(),
      ownerProfileImage: reader.readString(),
      tags: (reader.readList()).cast<String>(),
      link: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.body ?? '');
    writer.writeInt(obj.score);
    writer.writeInt(obj.viewCount);
    writer.writeInt(obj.answerCount);
    writer.writeBool(obj.isAnswered);
    writer.writeString(obj.creationDate.toIso8601String());
    writer.writeString(obj.ownerName);
    writer.writeString(obj.ownerProfileImage ?? '');
    writer.writeList(obj.tags);
    writer.writeString(obj.link);
  }
}
