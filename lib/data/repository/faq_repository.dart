import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/faq_model.dart';
import 'package:dental_booking_app/data/model/question_model.dart';

class FaqRepository{

  late final FirebaseFirestore _db;
  late final CollectionReference<FaqModel> _faqRef;

  FaqRepository(){
    _db = FirebaseFirestore.instance;
    _faqRef = _db
        .collection('faqs')
        .withConverter(
        fromFirestore: (snap, _) => FaqModel.fromDoc(snap),
        toFirestore: (faq, _) => faq.toMap()
    );
  }

  Future<List<FaqModel>> getAllFaq() async {
    final snapshot = await _faqRef
        .get();

    final faqs = snapshot.docs.map((docs) => docs.data()).toList();
    List<FaqModel> updateFaqs = [];

    for(int i=0; i< faqs.length; i++){
      final ques = await getAllQuestion(faqs[i].id);
      
      updateFaqs.add(faqs[i].copyWith(questions: ques));
    }

    return updateFaqs;
  }

  Future<List<Question>> getAllQuestion(String faqId) async {
    final snapshot = await _db
        .collection('faqs')
        .doc(faqId)
        .collection('questions')
        .withConverter(
          fromFirestore: (snap, _) => Question.fromDoc(snap), 
          toFirestore: (question, _) => question.toMap()
          )
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }
}