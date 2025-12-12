import 'package:flutter/material.dart';

class OrthodonticsPage extends StatelessWidget {
  const OrthodonticsPage({super.key});

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
                  _SectionTitle(title: 'Vì sao nên niềng răng tại chúng tôi?'),
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
      leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white,)),
      pinned: true,
      expandedHeight: 240,
      backgroundColor: Colors.lightBlue.shade200,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/orthodontics.png',
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
            Text('Sắp xếp răng đều đẹp – cải thiện nụ cười và khớp cắn',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Niềng răng giúp khắc phục sai lệch răng, chỉnh khớp cắn và mang lại nụ cười tự nhiên.',
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
          Expanded(child: _KPIItem(number: '97%', label: 'Hài lòng')),
          Expanded(child: _KPIItem(number: '6.000+', label: 'Ca niềng')),
          Expanded(child: _KPIItem(number: '10+', label: 'Năm kinh nghiệm')),
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
      _Benefit(icon: Icons.straighten_rounded, title: 'Khớp cắn chuẩn', desc: 'Cải thiện chức năng nhai và phát âm.'),
      _Benefit(icon: Icons.face_rounded, title: 'Thẩm mỹ khuôn mặt', desc: 'Góc nghiêng hài hoà, nụ cười tự tin.'),
      _Benefit(icon: Icons.clean_hands_rounded, title: 'Dễ vệ sinh răng miệng', desc: 'Răng đều giúp chải răng dễ dàng.'),
      _Benefit(icon: Icons.alarm_rounded, title: 'Theo dõi định kỳ', desc: 'Đảm bảo kết quả ổn định, an toàn.'),
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
      ('Khám & X-quang', 'Đánh giá tình trạng răng, chụp phim Ceph/Pano.'),
      ('Lập kế hoạch điều trị', 'Phân tích khớp cắn, lên phác đồ 3D.'),
      ('Gắn mắc cài / nhận khay', 'Bắt đầu quá trình niềng theo kế hoạch.'),
      ('Theo dõi định kỳ', 'Điều chỉnh lực kéo, thay dây cung hoặc khay.'),
      ('Tháo niềng & duy trì', 'Đeo retainer để giữ kết quả ổn định.'),
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
      _PriceCard(name: 'Mắc cài kim loại', price: '25–30 triệu', desc: 'Hiệu quả, tiết kiệm, phổ biến nhất.'),
      _PriceCard(name: 'Mắc cài sứ tự đóng', price: '35–40 triệu', desc: 'Thẩm mỹ cao, ít ma sát, thoải mái.'),
      _PriceCard(name: 'Niềng trong suốt', price: '50–75 triệu', desc: 'Tháo lắp linh hoạt, gần như vô hình.'),
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