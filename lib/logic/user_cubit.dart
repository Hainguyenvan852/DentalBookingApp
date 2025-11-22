import 'package:dental_booking_app/data/model/user_model.dart';
import 'package:dental_booking_app/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserState{
  final UserModel? user;
  final bool loading;
  final bool reloading;
  final Object? error;

  UserState({this.user, required this.loading, required this.reloading, this.error});

  UserState copyWith({UserModel? user, bool? loading, bool? reloading, Object? error}){
    return UserState(
        user: user ?? this.user,
        loading: loading ?? this.loading,
        reloading: reloading ?? this.reloading,
        error: error ?? this.error
    );
  }
}

class UserCubit extends Cubit<UserState>{
  final UserRepository _userRepo;

  UserCubit(this._userRepo) : super(UserState(loading: false, reloading: false,));

  void loadUserInfo(String id) async{
    emit(state.copyWith(loading: true));

    try{
      final user = await _userRepo.getUser(id);
      emit(state.copyWith(user: user, loading: false, reloading: false));
    }catch(e){
      emit(state.copyWith(error: e, loading: false, reloading: false));
    }
  }

  void reload(String id){
    emit(state.copyWith(reloading: true));

    loadUserInfo(id);
  }

  void updateUser(BuildContext context, UserModel user) async{

    final result = await _userRepo.update(user);

    reload(user.uid);

    if(result == 'success'){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã cập nhật'), backgroundColor: Colors.blue.shade300,));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
    }
  }
}