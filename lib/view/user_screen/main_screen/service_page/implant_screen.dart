import 'package:flutter/material.dart';

class ImplantServicePage extends StatelessWidget {
  const ImplantServicePage({super.key});

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
                  _SectionTitle(title: 'Vì sao nên cắm Implant tại chúng tôi?'),
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
      leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new, size: 19, color: Colors.white,)),
      pinned: true,
      expandedHeight: 260,
      backgroundColor: Colors.lightBlue.shade200,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/implant2.png',
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
            Text(
              'Phục hồi răng mất bằng Implant chuẩn quốc tế',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Răng Implant bền chắc, ăn nhai tự nhiên, thẩm mỹ cao. Ứng dụng chẩn đoán hình ảnh 3D, hướng dẫn phẫu thuật bằng máng in kỹ thuật số để tối ưu độ chính xác và thời gian hồi phục.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
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
    final items = const [
      _KPIItem(number: '98%', label: 'Hài lòng'),
      _KPIItem(number: '10.000+', label: 'Ca Implant'),
      _KPIItem(number: '15+', label: 'Năm kinh nghiệm'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: color.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((e) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: e,
        ),
        ).toList(),
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
        Text(number,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
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
      _Benefit(icon: Icons.health_and_safety_rounded, title: 'Ăn nhai như răng thật', desc: 'Trụ titanium tích hợp xương, chịu lực tốt.'),
      _Benefit(icon: Icons.verified_rounded, title: 'Thẩm mỹ cao', desc: 'Giữ đường nét nướu, tự tin khi cười.'),
      _Benefit(icon: Icons.schedule_rounded, title: 'Hồi phục nhanh', desc: 'Kỹ thuật ít xâm lấn, chăm sóc dễ dàng.'),
      _Benefit(icon: Icons.security_rounded, title: 'Bền chắc lâu dài', desc: 'Tuổi thọ 10–20 năm hoặc lâu hơn.'),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant),
      ),
      child:
      Padding(
        padding: const EdgeInsets.all(14),
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
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(desc, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _StepsTimeline extends StatelessWidget {
  const _StepsTimeline();

  @override
  Widget build(BuildContext context) {
    final steps = const [
      ('Khám & Chụp CT 3D', 'Đánh giá mật độ xương, lập kế hoạch điều trị.'),
      ('Lên máng hướng dẫn', 'Thiết kế – in máng phẫu thuật cá nhân hoá.'),
      ('Cấy trụ Implant', 'Thủ thuật vô cảm, ít xâm lấn, 20–45 phút/trụ.'),
      ('Theo dõi tích hợp xương', '4–12 tuần tuỳ cơ địa & vị trí.'),
      ('Gắn Abutment & mão răng', 'Lấy dấu – chế tác mão sứ, điều chỉnh khớp cắn.'),
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
            if (index < 5)
              Container(width: 2, height: 36, color: color.outlineVariant),
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
    final color = Theme.of(context).colorScheme;
    final cards = const [
      _PriceCard(
        name: 'Basic',
        price: '12.9 triệu',
        desc: 'Trụ Hàn Quốc, mão sứ cơ bản. Phù hợp mất 1 răng đơn lẻ.',
        features: ['Khám & CT 3D', 'Cấy trụ + Abutment', 'Bảo hành 3 năm'],
      ),
      _PriceCard(
        name: 'Advanced',
        price: '19.9 triệu',
        desc: 'Trụ Đức/Thuỵ Sĩ, mão sứ cao cấp. Tối ưu độ bền & thẩm mỹ.',
        features: ['Khám & CT 3D', 'Máng hướng dẫn', 'Bảo hành 5 năm'],
      ),
      _PriceCard(
        name: 'Premium',
        price: '26.9 triệu',
        desc: 'Trụ cao cấp + vật liệu ghép xương (nếu cần), bảo hành mở rộng.',
        features: ['Khám & CT 3D', 'Ghép xương/Màng PRF', 'Bảo hành 8 năm'],
      ),
    ];

    return SizedBox(
      height: 210,
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
  const _PriceCard({
    required this.name,
    required this.price,
    required this.desc,
    required this.features,
  });

  final String name;
  final String price;
  final String desc;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final cardColor = color.surfaceContainerHighest;
    final onCard = color.onSurfaceVariant;

    return Container(
      width: 280,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const Spacer(),
          const SizedBox(height: 6),
          Text(price, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: onCard)),
          const SizedBox(height: 8),
          ...features.map((f) => Row(
            children: [
              const Icon(Icons.check_circle_rounded, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text(f, style: Theme.of(context).textTheme.bodySmall)),
            ],
          )),

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
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}