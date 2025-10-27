import 'package:flutter_bloc/flutter_bloc.dart';

class DateState { final DateTime? selected; const DateState(this.selected); }
class DateCubit extends Cubit<DateState> { DateCubit(): super(DateState(DateTime.now()));

void select(DateTime d)=>emit(DateState(DateTime(d.year,d.month,d.day)));
}