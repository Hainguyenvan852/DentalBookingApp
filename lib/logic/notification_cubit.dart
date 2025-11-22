import 'package:dental_booking_app/data/model/notification_model.dart';
import 'package:dental_booking_app/data/repository/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationState{
  final List<NotificationModel> notifications;
  final bool haveUnread;
  final Object? error;

  NotificationState({required this.notifications, required this.haveUnread, this.error});
  NotificationState copyWith({List<NotificationModel>? notifications, bool? haveUnread, Object? error}) =>
      NotificationState(
        notifications: notifications ?? this.notifications, 
        haveUnread: haveUnread ?? this.haveUnread, 
        error: error ?? this.error
      );
}

class NotificationCubit extends Cubit<NotificationState>{
  final notificationRepo = NotificationRepository();

  NotificationCubit() : super(NotificationState(notifications: [], haveUnread: false,));

  Future<void> load() async{

    try{
      final notifList = await notificationRepo.getAll();
      int tmp = 0;

      for (var i in notifList){
        if(!i.isRead){
          emit(state.copyWith(notifications: notifList, haveUnread: true));
          break;
        }
        tmp += 1;
      }
      
      if(tmp == notifList.length){
        emit(state.copyWith(notifications: notifList, haveUnread: false));
      }

    } catch(e){
      emit(state.copyWith(error: e));
    }
  }
}