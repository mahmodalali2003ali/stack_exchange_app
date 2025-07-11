
import '../domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required super.questionId,
    required super.title,
    required super.body,
    required super.score,
    required super.ownerName,
    required super.ownerProfileImage,
    required super.link,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json['question_id'],
      title: json['title'],
      body: json['body'] ?? '',
      score: json['score'] ?? 0,
      ownerName: json['owner']?['display_name'] ?? 'Unknown',
      ownerProfileImage: json['owner']?['profile_image'] ?? '',
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'title': title,
      'body': body,
      'score': score,
      'owner_name': ownerName,
      'owner_profile_image': ownerProfileImage,
      'link': link,
    };
  }
}
