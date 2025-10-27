import 'package:flutter_bloc/flutter_bloc.dart';

class NoteState{
  final String? content;

  NoteState({this.content});

  NoteState copyWith(String? content) => NoteState(
      content: content ?? this.content
  );
}

class NoteCubit extends Cubit<NoteState>{
  NoteCubit() : super(NoteState());

  void setContent(String ct){emit(state.copyWith(ct));}
}