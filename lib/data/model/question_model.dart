import 'package:cloud_firestore/cloud_firestore.dart';

class Question{
  final String id;
  final String question;
  final String answer;
  final bool single_answer;

  Question({
    required this.id,
    required this.question,
    required this.answer,
    required this.single_answer
  });

  Question copyWith({String? id, String? question, String? answer, bool? single_answer})
    => Question(
      id: id ?? this.id,
      question: question ?? this.question, 
      answer: answer ?? this.answer,
      single_answer: single_answer ?? this.single_answer
      );

  factory Question.fromDoc(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Question(
      id: snap.id,
      question: data['question'],
      answer: data['answer'],
      single_answer: data['single_answer']
    );
  }

  Map<String, dynamic> toMap() => {
    'question': question,
    'answer': answer,
    'single_answer' : single_answer
  };
}