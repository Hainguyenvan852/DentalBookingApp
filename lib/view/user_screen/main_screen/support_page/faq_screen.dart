import 'package:dental_booking_app/data/model/faq_model.dart';
import 'package:dental_booking_app/data/repository/faq_repository.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF), 
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F3FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 19,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "FAQs",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: const FAQBody(),
    );
  }
}

class FAQBody extends StatefulWidget {
  const FAQBody({super.key});

  @override
  State<FAQBody> createState() => _FAQBodyState();
}

class _FAQBodyState extends State<FAQBody> with SingleTickerProviderStateMixin {
  late final FaqRepository _faqRepository;
  
  @override
  void initState() {
    super.initState();
    _faqRepository = FaqRepository();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _faqRepository.getAllFaq(), 
      builder: (context, snap){

        if(snap.connectionState == ConnectionState.waiting){
          return Center(
            child: LoadingAnimationWidget.waveDots(color: Colors.blue.shade400, size: 50),
          );
        }

        if(snap.hasError){
          return Center(
            child: Text('Error ${snap.error.toString()}'),
          );
        }

        final data = snap.data;
        
        if(data == null){
          return Center(
            child: Text('Không có dữ liệu'),
          );
        }

        List<Widget> views = [];
        for (var i in data){
          views.add(FaqTabPage(faq: i));
        }

        return DefaultTabController(
          length: data.length, 
          child: Column(
            children: [
              _buildTabBar(faqs: data),

              Expanded(
                child: TabBarView(
                  children: views,
                ),
              ),
            ],
          )
        );
      }
    );
  }

  Widget _buildTabBar({required List<FaqModel> faqs}) {

    List<Tab> tabs = [];

    for(var i in faqs){
      tabs.add(Tab(text: i.type,));
    }

    return Container(
      color: const Color(0xFFF5F3FF),
      child: TabBar(
        isScrollable: true,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 3.0,
          ),
          insets: const EdgeInsets.symmetric(horizontal: 0),
        ),
        tabAlignment: TabAlignment.start,
        tabs: tabs,
      ),
    );
  }
}


class FaqTabPage extends StatefulWidget {
  const FaqTabPage({super.key, required this.faq});
  final FaqModel faq;

  @override
  State<FaqTabPage> createState() => _FaqTabPageState();
}

class _FaqTabPageState extends State<FaqTabPage> {
  int openFaqIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemBuilder: (context, index){
          return _buildFaqItem(
            question: widget.faq.questions[index].question,
            answer: widget.faq.questions[index].answer,
            isExpanded: openFaqIndex == index,
            isSingle: widget.faq.questions[index].single_answer,
            onTap: () {
              setState(() {
                openFaqIndex = (openFaqIndex == index) ? -1 : index;
              });
            },
          );
        },
        itemCount: widget.faq.questions.length,
      )
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required bool isExpanded,
    required bool isSingle,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 213, 243, 250),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            height: isExpanded ? null : 0,
            margin: const EdgeInsets.only(top: 6.0, bottom: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: isExpanded
                ? isSingle ? _buildSingleAnswer(answer) : _buildNumberedList(answer)
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberedList(String text) {
    final List<String> items = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Text(item,
              style: TextStyle(
                  color: Colors.grey.shade600, fontSize: 14, height: 1.5));
      }).toList(),
    );
  }

  Widget _buildSingleAnswer(String text){
    return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
