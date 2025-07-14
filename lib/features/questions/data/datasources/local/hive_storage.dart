import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer';
import '../../models/question_model.dart';
import 'local_storage.dart';

class HiveStorage implements LocalStorage {
  static const String _boxName = 'questions';

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(QuestionModelAdapter().typeId)) {
      Hive.registerAdapter(QuestionModelAdapter());
    }
    await Hive.openBox<QuestionModel>(_boxName);
  }

  @override
  Future<void> insertQuestion(QuestionModel question) async {
    final box = await Hive.openBox<QuestionModel>(_boxName);
    await box.put(question.id, question);
    log('📋 HiveStorage: تم إدراج سؤال ID: ${question.id}');
  }

  @override
  Future<List<QuestionModel>> getAllQuestions() async {
    final box = await Hive.openBox<QuestionModel>(_boxName);
    final questions = box.values.toList();
    log('📋 HiveStorage: جلب ${questions.length} سؤال من التخزين المحلي');
    return questions;
  }

  @override
  Future<void> clearQuestions() async {
    final box = await Hive.openBox<QuestionModel>(_boxName);
    await box.clear();
    log('📋 HiveStorage: تم مسح جميع الأسئلة');
  }

  @override
  Future<int> getQuestionCount() async {
    final box = await Hive.openBox<QuestionModel>(_boxName);
    final count = box.length;
    log('📋 HiveStorage: عدد الأسئلة: $count');
    return count;
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
      tags: (reader.readList() as List<dynamic>).cast<String>(),
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