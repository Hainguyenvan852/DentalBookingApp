import 'dart:async';
import 'package:dental_booking_app/view/main_ui/home_page/my_appointment_page/my_appointment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/clinic_model.dart';
import '../../model/service_model.dart';
import 'booking_bloc/booking_cubit.dart';
import 'booking_bloc/booking_wiring.dart';
import 'booking_bloc/firestore_repository.dart';
import 'booking_bloc/repository_interface.dart';
import 'component/branch_field.dart';
import 'component/date_field.dart';
import 'component/dentist_selection.dart';
import 'component/service_field.dart';
import 'component/time_slot_selections.dart';


class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.initService});
  final Service? initService;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final dateCtrl = TextEditingController();
  final branchCtrl = TextEditingController();
  final serviceCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  late final ClinicRepository clinicRepo;
  late final DentistRepository doctorRepo;
  late final ServiceRepository serviceRepo;
  late final AppointmentRepository apmRepo;


  BookingWiringExample? _wiring;

  @override
  void dispose() {
    _wiring?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    clinicRepo = FirestoreClinicRepository();
    doctorRepo = FirestoreDentistRepository();
    serviceRepo = FirestoreServiceRepository();
    apmRepo = FirestoreAppointmentRepository();
  }


  @override
  Widget build(BuildContext context) {

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ClinicRepository>.value(value: clinicRepo),
        RepositoryProvider<DentistRepository>.value(value: doctorRepo),
        RepositoryProvider<ServiceRepository>.value(value: serviceRepo),
        RepositoryProvider<AppointmentRepository>.value(value: apmRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => BranchCubit(clinicRepo)..load()),
          BlocProvider(create: (_) => ServiceCubit(serviceRepo)..load(widget.initService)),
          BlocProvider(create: (_) => DentistCubit(doctorRepo)),
          BlocProvider(create: (_) => DateCubit()),
          BlocProvider(create: (_) => ClinicConfigCubit()),
          BlocProvider(create: (_) => AppointmentCubit(apmRepo)),
          BlocProvider(create: (_) => TimeSlotCubit()),
          BlocProvider(create: (_) => BookingDraftCubit()),
          BlocProvider(create: (_) => NoteCubit()),
        ],
        child: Builder(
            builder:(context){

              _wiring ??= BookingWiringExample(
                branchCubit: context.read<BranchCubit>(),
                serviceCubit: context.read<ServiceCubit>(),
                dentistCubit: context.read<DentistCubit>(),
                dateCubit: context.read<DateCubit>(),
                clinicCfgCubit: context.read<ClinicConfigCubit>(),
                appointmentCubit: context.read<AppointmentCubit>(),
                timeSlotCubit: context.read<TimeSlotCubit>(),
                draftCubit: context.read<BookingDraftCubit>(),
                noteCubit: context.read<NoteCubit>(),
                auth: FirebaseAuth.instance
              );

              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, size: 22,)),
                    centerTitle: true,
                    title: const Text('Đặt lịch hẹn',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                              children: [
                                BranchField(controller: branchCtrl,),
                                SizedBox(height: 15,),
                                ServiceField(controller: serviceCtrl,),
                                SizedBox(height: 15,),
                                DentistSelection(),
                                SizedBox(height: 15,),
                                DateField(),
                                SizedBox(height: 15,),
                                TimeSlotSelections(),
                                SizedBox(height: 15,),
                                BlocBuilder<NoteCubit, NoteState>(
                                    builder: (context, state){
                                      return SizedBox(
                                        height: 170,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Nội dung', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                            SizedBox(height: 8,),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                    padding: EdgeInsets.only(left: 10, right: 5, ),
                                                    child: TextFormField(
                                                      cursorColor: Colors.black,
                                                      maxLines: 5,
                                                      controller: noteCtrl,
                                                      style: TextStyle(fontSize: 14, ),
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        contentPadding: EdgeInsets.only(top: 5),
                                                      ),
                                                      onChanged: (v)=>context.read<BookingDraftCubit>().setNotes(v),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                ),
                                SizedBox(height: 15,)
                              ]
                          ),
                        ),
                        BlocBuilder<BookingDraftCubit, BookingDraftState>(
                            builder: (context, st){
                              return ElevatedButton(
                                  onPressed: st.readyToSubmit && !st.submitting ? () async {
                                    final apmRepo = context.read<AppointmentRepository>();
                                    context.read<BookingDraftCubit>().setSubmitting(true);
                                    try{
                                      context.read<BookingDraftCubit>().setSubmitting(false);
                                      await submitBooking(draft: context.read<BookingDraftCubit>(), apmRepo: apmRepo, patientId: FirebaseAuth.instance.currentUser!.uid);
                                      _showSuccessSheet(context);
                                    } catch(e){
                                      context.read<BookingDraftCubit>().setSubmitting(false);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                                    }
                                    //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã đặt lịch')));
                                  } : null,
                                  style: ElevatedButton.styleFrom(
                                      maximumSize: Size(double.infinity, 100),
                                      minimumSize: Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      backgroundColor: Colors.blue[400]
                                  ),
                                  child: Text('Đặt lịch', style: TextStyle(fontSize: 16, color: Colors.white),)
                              );
                            })
                      ],
                    ),
                  )
              );
            }
        ),
      ),
    );
  }
}

Future<void> submitBooking({
  required BookingDraftCubit draft,
  required AppointmentRepository apmRepo,
  required String patientId,
}) async {
  final st = draft.state;
  if (!st.readyToSubmit) {
    throw StateError('Form chưa đủ dữ liệu.');
  }
  final service = st.service!;
  final slot = st.slot!;


  final end = slot.startAt.add(Duration(minutes: service.durationMinutes));


  final req = AppointmentCreateRequest(
    clinicId: st.clinic!.id,
    dentistId: st.dentist?.id ?? '',
    patientId: patientId,
    serviceId: service.id,
    startAt: slot.startAt,
    endAt: end,
    notes: st.notes,
  );
  await apmRepo.create(req);
}

void _showSuccessSheet(BuildContext context) {
  final draft = context.read<BookingDraftCubit>().state;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, size: 48),
            const SizedBox(height: 8),
            Text('Đặt lịch thành công', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text('${draft.clinic!.name} • ${draft.service!.name}\n${_fmtSlot(draft.slot!)}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppointmentPage()));
                },
                child: const Text('Xem lịch hẹn'),
              )),
              const SizedBox(width: 12),
              Expanded(child: FilledButton(
                onPressed: (){
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Về trang chủ'),
              )),
            ]),
            const SizedBox(height: 12),
          ]),
        );
      }
  );
}
String _fmtSlot(TimeSlot s) =>
    '${s.startAt.hour.toString().padLeft(2,'0')}:${s.startAt.minute.toString().padLeft(2,'0')}'
    ' - '
    '${s.endAt.hour.toString().padLeft(2,'0')}:${s.endAt.minute.toString().padLeft(2,'0')}';
