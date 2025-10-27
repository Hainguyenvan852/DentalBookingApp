

import 'package:flutter/material.dart';

class GeneralExamPage extends StatelessWidget {
  const GeneralExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: CustomScrollView(
        slivers: [
          _HeroAppBar(color: color),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _IntroCard(),
                  SizedBox(height: 16),
                  _KPIStats(),
                  SizedBox(height: 16),
                  _SectionTitle(title: 'Vì sao nên khám tổng quát tại chúng tôi?'),
                  SizedBox(height: 8),
                  _BenefitsGrid(),
                  SizedBox(height: 16),
                  _SectionTitle(title: 'Quy trình thực hiện'),
                  SizedBox(height: 8),
                  _StepsTimeline(),
                  SizedBox(height: 16),
                  _SectionTitle(title: 'Gói dịch vụ & Chi phí'),
                  SizedBox(height: 8),
                  _PricingScroller(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroAppBar extends StatelessWidget {
  const _HeroAppBar({required this.color});
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new, size: 19,color: Colors.white,)),
      pinned: true,
      expandedHeight: 240,
      backgroundColor: Colors.lightBlue.shade200,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/general_exam.png',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bảo vệ sức khoẻ răng miệng toàn diện cùng chuyên gia',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Khám tổng quát giúp phát hiện sớm các bệnh lý răng miệng, đánh giá tình trạng nướu, men răng và đề xuất hướng điều trị phù hợp.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

          ],
        ),
      ),
    );
  }
}

class _KPIStats extends StatelessWidget {
  const _KPIStats();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: color.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: const [
          Expanded(child: _KPIItem(number: '95%', label: 'Hài lòng')),
          Expanded(child: _KPIItem(number: '10.000+', label: 'Ca khám định kỳ')),
          Expanded(child: _KPIItem(number: '15+', label: 'Năm kinh nghiệm')),
        ],
      ),
    );
  }
}

class _KPIItem extends StatelessWidget {
  const _KPIItem({required this.number, required this.label});
  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(number, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _BenefitsGrid extends StatelessWidget {
  const _BenefitsGrid();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _Benefit(icon: Icons.health_and_safety_rounded, title: 'Phát hiện sớm vấn đề', desc: 'Ngăn ngừa sâu răng, viêm nướu, nha chu.'),
      _Benefit(icon: Icons.favorite_rounded, title: 'Chăm sóc định kỳ', desc: 'Giữ răng miệng khoẻ mạnh, hơi thở thơm mát.'),
      _Benefit(icon: Icons.tips_and_updates_rounded, title: 'Tư vấn chuyên sâu', desc: 'Lộ trình điều trị cá nhân hoá.'),
      _Benefit(icon: Icons.star_rate_rounded, title: 'Công nghệ hiện đại', desc: 'Thiết bị X-quang, nội soi, máy làm sạch tiên tiến.'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, i) => items[i],
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.title, required this.desc});
  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(desc, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _StepsTimeline extends StatelessWidget {
  const _StepsTimeline();


  @override
  Widget build(BuildContext context) {
    final steps = const [
      ('Đăng ký & tiếp nhận', 'Khách hàng điền thông tin và được hướng dẫn ban đầu.'),
      ('Khám lâm sàng & X-quang', 'Đánh giá tổng quan răng, nướu, khớp cắn.'),
      ('Tư vấn & lập kế hoạch', 'Giải thích kết quả, tư vấn hướng điều trị.'),
      ('Vệ sinh & chăm sóc', 'Làm sạch răng, hướng dẫn chăm sóc tại nhà.'),
      ('Đặt lịch tái khám', 'Theo dõi định kỳ, cập nhật tình trạng răng miệng.'),
    ];


    return Column(
      children: [
        for (int i = 0; i < steps.length; i++) _StepTile(index: i + 1, title: steps[i].$1, desc: steps[i].$2),
      ],
    );
  }
}


class _StepTile extends StatelessWidget {
  const _StepTile({required this.index, required this.title, required this.desc});
  final int index;
  final String title;
  final String desc;


  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _Dot(index: index, color: color),
            if (index < 5) Container(width: 2, height: 36, color: color.outlineVariant),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(desc, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.index, required this.color});
  final int index;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.lightBlue.shade200,
      ),
      child: Text('$index', style: TextStyle(color: color.onPrimary, fontWeight: FontWeight.w700)),
    );
  }
}


class _PricingScroller extends StatelessWidget {
  const _PricingScroller();

  @override
  Widget build(BuildContext context) {
    final cards = const [
      _PriceCard(name: 'Gói cơ bản', price: '200.000đ', desc: 'Khám tổng quát + tư vấn điều trị.'),
      _PriceCard(name: 'Gói tiêu chuẩn', price: '350.000đ', desc: 'Khám + chụp X-quang + làm sạch răng.'),
      _PriceCard(name: 'Gói nâng cao', price: '550.000đ', desc: 'Khám chuyên sâu + đánh giá nha chu + kế hoạch điều trị.'),
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, i) => cards[i],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.name, required this.price, required this.desc});
  final String name;
  final String price;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(price, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(desc, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800));
  }
}