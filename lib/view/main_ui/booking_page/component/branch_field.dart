import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/clinic_model.dart';
import '../../../../logic/branch_cubit.dart';


class BranchField extends StatelessWidget {
  const BranchField({super.key, required TextEditingController controller}) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchCubit, BranchState>(
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
              RichText(
                text: TextSpan(
                  text: 'Chi nhánh',
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
                      final Clinic? picked = await showDialog(context: context,
                          builder: (builder) => ClinicDialog(clinics: st.clinics,)
                      );

                      if(picked != null){
                        context.read<BranchCubit>().select(picked);
                        _controller.text = picked.name;
                      }
                    },
                    controller: _controller,
                    readOnly: true,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 5),
                        icon: Icon(Icons.location_on, size: 19, color: Colors.grey,)
                    ),
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


class ClinicDialog extends StatefulWidget {
  const ClinicDialog({super.key, required this.clinics,});
  final List<Clinic> clinics;

  @override
  State<ClinicDialog> createState() => _ClinicDialogState();
}

class _ClinicDialogState extends State<ClinicDialog> with SingleTickerProviderStateMixin{
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
              return ClinicComponent(clinic: widget.clinics[index], onTap: ()=> Navigator.pop(context, widget.clinics[index]),);
            },
            separatorBuilder: (context, index){
              return SizedBox(height: 4,);
            },
            itemCount: widget.clinics.length
        ),
      )
    );
  }
}

class ClinicComponent extends StatelessWidget {
  const ClinicComponent({super.key, required this.clinic, required this.onTap});
  final Clinic clinic;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10),
        height: 70,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Color.fromRGBO(227, 228, 230, 0.5),
                border: Border.all(color: Color.fromRGBO(227, 228, 230, 0.5)),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.image, size: 60, color: Colors.grey,)
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(clinic.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                  Text(clinic.address, style: TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


