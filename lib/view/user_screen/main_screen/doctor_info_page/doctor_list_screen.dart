import 'package:dental_booking_app/data/model/dentist_model.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/doctor_info_page/doctor_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../data/model/clinic_model.dart';
import '../../../../data/repository/clinic_repository.dart';
import '../../../../data/repository/dentist_repository.dart';


class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final _clinicRepo = ClinicRepository();
  final _dentistRepo = DentistRepository();
  late final Future<List<Clinic>> _clinicFuture;

  final List<Clinic> _tabs = [
  ];

  @override
  void initState() {
    _clinicFuture =  _clinicRepo.getAll();
    _clinicFuture.then((value) {
      setState(() {
        _tabs.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Danh sách Bác sĩ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16.0, top: 20),
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue[700],
                ),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.label,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                tabAlignment: TabAlignment.start,
                splashFactory: NoSplash.splashFactory,
                tabs: _tabs.map((clinic) {
                  return Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(clinic.name, style: const TextStyle(fontSize: 14)),
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: TabBarView(
                children: _tabs.map((clinic) {
                  return FutureBuilder(
                      future: _dentistRepo.getByClinic(clinic.id),
                      builder: (context, snap){
                        if(snap.connectionState == ConnectionState.waiting){
                          return Center(child: LoadingAnimationWidget.waveDots(color: Colors.blue, size: 30));
                        }
                        final doctors = snap.data;

                        if(doctors == null || doctors.isEmpty){
                          return Center(
                            child: Text("Không có bác sĩ nào trong phòng khám ${clinic.name}"),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            return DoctorListItem(doctor: doctors[index], clinic: clinic,);
                          },
                          separatorBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(height: 1, thickness: 0.5),
                            );
                          },
                        );
                      }
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorListItem extends StatelessWidget {
  final Dentist doctor;
  final Clinic clinic;

  const DoctorListItem({super.key, required this.doctor, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: doctor.sex ? const AssetImage('assets/images/men_doctor.png') : AssetImage('assets/images/women_doctor.png'),
                backgroundColor: Colors.grey[200],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'BS. ${doctor.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specializedToVietnamese(doctor.specialized),
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          OutlinedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorInfoScreen(dentist: doctor, clinic: clinic,)));
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.blue[50],
              foregroundColor: Colors.blue[700],
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Xem hồ sơ', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

String specializedToVietnamese(String specialized){
  if(specialized == 'general_dentist'){
    return 'Tổng quát';
  } else if(specialized == 'orthodontist'){
    return 'Chỉnh nha';
  } else if(specialized == 'oral_surgeon'){
    return 'Phẫu thuật hàm mặt';
  } else if(specialized == 'prosthodontist'){
    return 'Thẩm mỹ';
  } else if(specialized == 'periodontist'){
    return 'Nha nhu';
  } else{
    return 'Khác';
  }
}