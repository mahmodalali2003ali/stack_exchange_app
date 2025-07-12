import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final int id;
  final String title;
  final String? body;
  final int score;
  final int viewCount;
  final int answerCount;
  final bool isAnswered;
  final DateTime creationDate;
  final String ownerName;
  final String? ownerProfileImage;
  final List<String> tags;
  final String link;

  const Question({
    required this.id,
    required this.title,
    this.body,
    required this.score,
    required this.viewCount,
    required this.answerCount,
    required this.isAnswered,
    required this.creationDate,
    required this.ownerName,
    this.ownerProfileImage,
    required this.tags,
    required this.link,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        score,
        viewCount,
        answerCount,
        isAnswered,
        creationDate,
        ownerName,
        ownerProfileImage,
        tags,
        link,
      ];
}