import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/image_model.dart';
import 'package:dental_booking_app/data/repository/gallery_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryState{
  final List<ImageDoc> items;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocs;
  final bool initialLoading;
  final bool loadingMore;
  final bool refreshing;
  final String? error;

  GalleryState({
    this.items = const [],
    this.lastDocs,
    this.initialLoading = false,
    this.loadingMore = false,
    this.refreshing = false,
    this.error
  });

  GalleryState copyWith({
    List<ImageDoc>? items,
    DocumentSnapshot<Map<String, dynamic>>? lastDocs,
    bool? initialLoading,
    bool? loadingMore,
    bool? refreshing,
    String? error,
  }) {
    return GalleryState(
      items: items ?? this.items,
      lastDocs: lastDocs ?? this.lastDocs,
      initialLoading: initialLoading ?? this.initialLoading,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,
      error: error,
    );
  }
}

class GalleryCubit extends Cubit<GalleryState>{
  GalleryCubit({required this.repo, required this.userId}) : super(GalleryState());

  final GalleryRepository repo;
  final String userId;


  Future<void> loadFirst() async{
    emit(state.copyWith(initialLoading: true));

    try{
      final res = await repo.fetchPage(limit: 18, cursor: null, userId: userId);

      emit(state.copyWith(
        items: res.items,
        lastDocs: res.lastDoc,
        initialLoading: false
      ));
    } catch(e){
      emit(state.copyWith(initialLoading: false, error: e.toString()));
    }
  }

  Future<void> loadMore() async{

    if(state.loadingMore || state.lastDocs == null) return;

    emit(state.copyWith(loadingMore: true));

    try{
      final res = await repo.fetchPage(limit: 18, cursor: state.lastDocs, userId: userId);

      emit(state.copyWith(
          items: [...state.items, ...res.items],
          lastDocs: res.lastDoc,
          loadingMore: false
      ));
    } catch(e){
      emit(state.copyWith(loadingMore: false, error: e.toString()));
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(refreshing: true));

    try{
      final res = await repo.fetchPage(limit: 18, cursor: null, userId: userId);

      emit(state.copyWith(
        items: res.items,
        lastDocs: res.lastDoc,
        refreshing: false
      ));
    }catch(e){
      emit(state.copyWith(refreshing: false, error: e.toString()));
    }
  }
}