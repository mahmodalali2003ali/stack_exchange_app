import '../domain/entities/question.dart';

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
    return QuestionModel(
      id: json['question_id'],
      title: json['title'],
      body: json['body'] ?? '',
      score: json['score'] ?? 0,
      ownerName: json['owner']?['display_name'] ?? 'Unknown',
      ownerProfileImage: json['owner']?['profile_image'] ?? '',
      link: json['link'] ?? '',
      viewCount: json['view_count'] ?? 0,
      answerCount: json['answer_count'] ?? 0,
      isAnswered: json['is_answered'] ?? false,
      creationDate: DateTime.fromMillisecondsSinceEpoch(
        (json['creation_date'] ?? 0) * 1000,
      ),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': id,
      'title': title,
      'body': body,
      'score': score,
      'view_count': viewCount,
      'answer_count': answerCount,
      'is_answered': isAnswered,
      'creation_date': creationDate.millisecondsSinceEpoch ~/ 1000,
      'owner_name': ownerName,
      'owner_profile_image': ownerProfileImage,
      'link': link,
      'tags': tags,
    };
  }
}
