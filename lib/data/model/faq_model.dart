import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/question_model.dart';

class FaqModel{
  final String id;
  final String type;
  final List<Question> questions;

  FaqModel({
    required this.id,
    required this.type,
    required this.questions
  });

  FaqModel copyWith({String? id, String? type, List<Question>? questions})
    => FaqModel(
      id: id ?? this.id, 
      type: type ?? this.type, 
      questions: questions ?? this.questions
      );

  factory FaqModel.fromDoc(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return FaqModel(
      id: snap.id,
      type: data['type'], 
      questions: []
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
  };
}
