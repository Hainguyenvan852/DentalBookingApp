import 'package:dental_booking_app/view/main_ui/booking_page/booking_bloc/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/service_model.dart';



class ServiceField extends StatelessWidget {
  const ServiceField({super.key, required TextEditingController controller}) : _controller = controller;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, st){
          if (st.loading) {
            return Container(
              alignment: Alignment.center,
              height: 65,
              child: const LinearProgressIndicator()
            );
          }
          if (st.selected != null){
            _controller.text = st.selected!.name;
          }
          return SizedBox(
            height: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(
                    text: 'Dịch vụ',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
                    children: [
                      TextSpan(text: '  *', style: TextStyle(color: Colors.red))
                    ]
                ),
                ),
                Container(
                  height: 43,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(219, 217, 217, 1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 5, ),
                    child: TextFormField(
                        onTap: () async {
                          final Service? picked = await showDialog(context: context,
                              builder: (builder) => ServiceDialog(services: st.services,)
                          );

                          if (picked != null) {
                            _controller.text = picked.name;
                            context.read<ServiceCubit>().select(picked);
                          }
                        },
                        readOnly: true,
                        controller: _controller,
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            hintText: 'Chọn dịch vụ',
                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                            icon: SvgPicture.asset('assets/icons/tooth.svg', width: 19, color: Colors.grey,)
                        )
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}

class ServiceDialog extends StatefulWidget {
  const ServiceDialog({super.key, required this.services,});
  final List<Service> services;

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset(0,0.1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _animation,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            shape: UnderlineInputBorder(borderSide: BorderSide(width: 0.5, color: Colors.grey)),
            title: Text('Chọn chi nhánh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            centerTitle: true,
            toolbarHeight: 50,
            leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.cancel_rounded, size: 18,)),
          ),
          body: ListView.separated(
              itemBuilder: (context, index){
                return ServiceComponent(service: widget.services[index], onTap: ()=> Navigator.pop(context, widget.services[index]),);
              },
              separatorBuilder: (context, index){
                return SizedBox(height: 4,);
              },
              itemCount: widget.services.length
          )
        ),
    );
  }
}

class ServiceComponent extends StatelessWidget {
  const ServiceComponent({super.key, required this.service, required this.onTap});
  final Service service;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        color: Colors.white,
        child: SizedBox(
          height: 80,
          width: double.infinity,
          child: Row(
              children: [
                SizedBox(width: 10,),
                Image.network(service.imageUrl, width: 65, height: 65, fit: BoxFit.cover,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(service.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                    Text(service.description, style: TextStyle(fontSize: 12))
                  ],
                )
              ],
            ),
          )
      )
    );
  }
}
