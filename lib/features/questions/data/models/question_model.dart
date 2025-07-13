import '../../domain/entities/question.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.title,
    required super.body,
    required super.score,
    required super.ownerName,
    required super.ownerProfileImage,
    required super.link,
    required super.viewCount,
    required super.answerCount,
    required super.isAnswered,
    required super.creationDate,
    required super.tags,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    print('📋 QuestionModel: بدء تحويل JSON إلى QuestionModel');
    print('📋 QuestionModel: البيانات المستلمة: $json');

    final id = json['question_id'] ?? json['id'] ?? 0;
    final title = json['title'] ?? 'بدون عنوان';
    final body = json['body'] ?? '';
    final score = json['score'] ?? 0;
    final ownerName =
        json['owner']?['display_name'] ?? json['owner_name'] ?? 'غير معروف';
    final ownerProfileImage =
        json['owner']?['profile_image'] ?? json['owner_profile_image'] ?? '';
    final link = json['link'] ?? '';
    final viewCount = json['view_count'] ?? json['viewCount'] ?? 0;
    final answerCount = json['answer_count'] ?? json['answerCount'] ?? 0;
    final isAnswered = json['is_answered'] ?? json['isAnswered'] ?? false;

    final creationDate =
        json['creation_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['creation_date'] * 1000)
            : DateTime.tryParse(json['creationDate'] ?? '') ?? DateTime.now();

    final tags =
        (json['tags'] != null && json['tags'] is List)
            ? (json['tags'] as List).map((e) => e.toString()).toList()
            : (json['tags'] is String
                ? (json['tags'] as String).split(',')
                : []);

    print('📋 QuestionModel: تم استخراج البيانات - ID: $id, Title: $title');

    return QuestionModel(
      id: id,
      title: title,
      body: body,
      score: score,
      ownerName: ownerName,
      ownerProfileImage: ownerProfileImage,
      link: link,
      viewCount: viewCount,
      answerCount: answerCount,
      isAnswered: isAnswered,
      creationDate: creationDate,
      tags: tags.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'score': score,
      'viewCount': viewCount,
      'answerCount': answerCount,
      'isAnswered': isAnswered ? 1 : 0,
      'creationDate': creationDate.toIso8601String(),
      'owner_name': ownerName,
      'owner_profile_image': ownerProfileImage,
      'link': link,
      'tags': tags.join(','),
    };
  }
}
