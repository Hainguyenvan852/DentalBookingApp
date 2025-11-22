import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../data/model/image_model.dart';
import '../../../../data/repository/gallery_repository.dart';
import '../../../../logic/gallery_cubit.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  late final GalleryRepository repo;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    repo = GalleryRepository();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => repo,
      child: BlocProvider(
          create: (context) => GalleryCubit(repo: repo),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text('Kho ảnh điều trị', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, size: 19,)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GalleryGrid(),
            ),
          )
      ),
    );
  }
}

class GalleryGrid extends StatefulWidget {
  const GalleryGrid({super.key});

  @override
  State<GalleryGrid> createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<GalleryCubit>().loadFirst();
    _controller.addListener(() {
      final pos = _controller.position;
      if (pos.pixels > pos.maxScrollExtent - 800) {
        context.read<GalleryCubit>().loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryCubit, GalleryState>(
        builder: (context, s) {
          if (s.initialLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.error != null && s.items.isEmpty) {
            return Center(child: Text('Lỗi: ${s.error}'));
          }
          // final showLoaderTail = s.lastDocs != null;
          if(s.items.isEmpty){
            return Center(child: Text('Bạn chưa có ảnh nào', ),);
          }
          final grouped = groupBy(s.items, (img) => DateFormat('dd/MM/yyy').format(img.createdAt));
          final keys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.separated(
              itemBuilder: (context, i){
                final date = keys[i];
                final imgs = grouped[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date, style: TextStyle(fontSize: 13),),
                    SizedBox(height: 10),
                    RefreshIndicator(
                      onRefresh: () => context.read<GalleryCubit>().refresh(),
                      child: GridView.builder(
                          controller: _controller,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            // if(index >= s.items.length){
                            //   return Center(child: CircularProgressIndicator(),);
                            // }
                            return ImageTile(img: imgs[index]);
                          },
                          itemCount: imgs.length // + (showLoaderTail ? 1 : 0),
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, i) => SizedBox(height: 25,),
              itemCount: grouped.length
          );
        }
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({super.key, required this.img});
  final ImageDoc img;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => PhotoViewer(img: img),
          ));
        },
        child: Hero(
          tag: img.id,
          child: CachedNetworkImage(
            imageUrl: img.urlThumb,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 180),
            errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }
}

class PhotoViewer extends StatelessWidget {
  const PhotoViewer({super.key, required this.img});
  final ImageDoc img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (_) => Navigator.pop(context),
        onHorizontalDragStart: (_) => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: img.id,
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: img.urlFull,
                fit: BoxFit.contain,
                placeholder: (_, __) => CachedNetworkImage(
                  imageUrl: img.urlThumb,
                  fit: BoxFit.contain,
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

