import 'package:dental_booking_app/data/model/invoice_model.dart';
import 'package:dental_booking_app/data/repository/invoice_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceState{
  final Invoice? selected;
  final List<Invoice> invoices;
  final bool loading;
  final bool reloading;
  final Object? error;

  InvoiceState({this.selected, required this.loading, required this.reloading, this.error, required this.invoices});

  InvoiceState copyWith({Invoice? selected, bool? loading, bool? reloading, Object? error, List<Invoice>? invoices}){
    return InvoiceState(
        selected: selected ?? this.selected,
        loading: loading ?? this.loading,
        reloading: reloading ?? this.reloading,
        error: error ?? this.error,
        invoices: invoices ?? this.invoices
    );
  }
}

class InvoiceCubit extends Cubit<InvoiceState>{
  final InvoiceRepository _invoiceRepo;

  InvoiceCubit(this._invoiceRepo) : super(InvoiceState(loading: false, reloading: false, invoices: [],));

  void loadInvoiceInfo(String id) async{
    emit(state.copyWith(loading: true));

    try{
      final invoice = await _invoiceRepo.getById(id);
      emit(state.copyWith(selected: invoice, loading: false, reloading: false));
    }catch(e){
      emit(state.copyWith(error: e, loading: false, reloading: false));
    }
  }

  void loadAll() async{
    emit(state.copyWith(loading: true));

    try{
      final invoices = await _invoiceRepo.getAll('fjG3DhpLVtMKXE0eP27w0O3SbYB2');
      emit(state.copyWith(invoices: invoices, loading: false, reloading: false));
    }catch(e){
      emit(state.copyWith(error: e, loading: false, reloading: false));
    }
  }

  void select(Invoice inv){
    emit(state.copyWith(selected: inv));
  }

  void reload(String id){
    emit(state.copyWith(reloading: true));

    loadInvoiceInfo(id);
  }

  void updateInvoice(BuildContext context, Invoice invoice) async{

    final result = await _invoiceRepo.updateInvoice(invoice);

    reload(invoice.id);

    if(result == 'success'){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã cập nhật'), backgroundColor: Colors.blue.shade300,));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
    }
  }
}