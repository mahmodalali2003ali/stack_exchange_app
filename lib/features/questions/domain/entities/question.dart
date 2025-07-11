import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final int questionId;
  final String title;
  final String body;
  final int score;
  final String ownerName;
  final String ownerProfileImage;
  final String link;

  const Question({
    required this.questionId,
    required this.title,
    required this.body,
    required this.score,
    required this.ownerName,
    required this.ownerProfileImage,
    required this.link,
  });

  @override
  List<Object?> get props => [questionId, title, body, score, ownerName, link];
}
