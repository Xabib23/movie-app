import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/domain/bloc/movies_bloc.dart';
import 'package:movies_app/domain/bloc/upcoming_bloc.dart';
import 'package:movies_app/domain/models/upcoming_model.dart';
import 'package:movies_app/ui/pages/favorite_page.dart';
import 'package:movies_app/ui/pages/movie_detail_page.dart';
import 'package:movies_app/ui/pages/search_page.dart';
import 'dart:math' as math;

import 'package:outlined_text/outlined_text.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
      length: 4,
      vsync: this,
    );
    List<Widget> pages = [
      MainPageContent(
        tabController: tabController,
        currentIndex: currentIndex,
      ),
      const SearchPage(),
      const FavoritePage(),
    ];
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xff0296E5),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          unselectedItemColor: const Color(0xff67686D),
          selectedItemColor: const Color(0xff0296E5),
          useLegacyColorScheme: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff242A32),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: SvgPicture.asset(
                  'assets/images/home.svg',
                  color: currentIndex == 0
                      ? const Color(0xff0296E5)
                      : const Color(0xff67686D),
                ),
              ),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: SvgPicture.asset(
                  'assets/images/search.svg',
                  color: currentIndex == 1
                      ? const Color(0xff0296E5)
                      : const Color(0xff67686D),
                ),
              ),
              label: 'Поиск',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: SvgPicture.asset(
                  'assets/images/save.svg',
                  color: currentIndex == 2
                      ? const Color(0xff0296E5)
                      : const Color(0xff67686D),
                ),
              ),
              label: 'Избранное',
            ),
          ],
        ),
      ),
      body: pages[currentIndex],
    );
  }
}

class MainPageContent extends StatelessWidget {
  final int currentIndex;

  const MainPageContent(
      {super.key, required this.tabController, required this.currentIndex});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          // HomePageSearchBar(currentIndex: currentIndex),
          // const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: <Widget>[
                const HomePageTopMovies(),
                HomePageTabBar(controller: tabController),
                const HomePageMoviesGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageMoviesGrid extends StatelessWidget {
  const HomePageMoviesGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state is! MoviesLoaded) {
          return const SizedBox(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xff0296E5),
              ),
            ),
          );
        }
        final data = state.allMovies.allMovies;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
            mainAxisExtent: 220,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) => data[index].posterPath != null
              ? Column(
                  children: [
                    ZoomTapAnimation(
                      onTap: () {
                        Navigator.of(context).pushNamed('/movie_detail_page',
                            arguments: data[index].id);
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        child: SizedBox(
                          height: 160,
                          width: 120,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff0296E5),
                              ),
                            ),
                            fit: BoxFit.cover,
                            imageUrl:
                                'https://image.tmdb.org/t/p/original/${data[index].posterPath}',
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image_not_supported_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data[index].title ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )
              : Image.asset(
                  'assets/images/nophoto.jpg',
                  fit: BoxFit.cover,
                ),
          itemCount: data.length,
        );
      },
    );
  }
}

class HomePageSearchBar extends StatelessWidget {
  final int currentIndex;

  const HomePageSearchBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        currentIndex == 1;
      },
      child: Container(
        height: 42,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        decoration: const BoxDecoration(
          color: Color(0xff3A3F47),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Поиск',
              style: TextStyle(
                color: Color(0xff67686D),
              ),
            ),
            Transform.rotate(
              angle: 180 * math.pi / 360,
              child: SvgPicture.asset('assets/images/search.svg'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageTopMovies extends StatelessWidget {
  const HomePageTopMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(
      viewportFraction: .47,
      initialPage: 0,
      keepPage: true,
    );
    return SizedBox(
      height: 250,
      child: BlocBuilder<UpcomingBloc, UpcomingState>(
        builder: (context, state) {
          if (state is! UpcomingLoaded) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff0296E5),
              ),
            );
          }

          final data = state.data.results ?? [];
          return PageView.builder(
            controller: controller,
            padEnds: false,
            pageSnapping: false,
            itemBuilder: (context, index) => HomePageTopMoviesItem(
              index: index,
              item: data[index],
            ),
            itemCount: data.length,
          );
        },
      ),
    );
  }
}

class HomePageTopMoviesItem extends StatelessWidget {
  final int index;
  final Results item;

  const HomePageTopMoviesItem({
    super.key,
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/movie_detail_page', arguments: item.id);
      },
      child: SizedBox(
        width: 145,
        height: 250,
        child: Stack(
          children: [
            Positioned(
              left: 30,
              child: SizedBox(
                width: 145,
                height: 210,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: item.posterPath != null
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff0296E5),
                            ),
                          ),
                          imageUrl:
                              'https://image.tmdb.org/t/p/original/${item.posterPath}',
                        )
                      : Image.asset(
                          'assets/images/nophoto.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 10,
              child: OutlinedText(
                strokes: [
                  OutlinedTextStroke(
                    color: const Color(0xff0296E5),
                    width: 3,
                  ),
                ],
                text: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 80,
                    color: Color(0xff242A32),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageTabBar extends StatelessWidget {
  final TabController controller;

  const HomePageTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MoviesBloc>(context);
    List<Map<String, dynamic>> categories = [
      {
        'title': 'Текущие',
        'id': 'now_playing',
      },
      {
        'title': 'Предстоящие',
        'id': 'upcoming',
      },
      {
        'title': 'Популярные',
        'id': 'popular',
      },
      {
        'title': 'Топ',
        'id': 'top_rated',
      },
    ];
    List<Widget> tabs = List.generate(categories.length, (index) {
      return Tab(
        text: categories[index]['title'],
        key: UniqueKey(),
      );
    });

    return TabBar(
      onTap: (index) {
        bloc.add(
          GetMovieInCategoryEvent(
            category: categories[index]['id'],
          ),
        );
      },
      controller: controller,
      dividerColor: Colors.transparent,
      isScrollable: true,
      padding: EdgeInsets.zero,
      tabAlignment: TabAlignment.center,
      indicatorColor: const Color(0xff3A3F47),
      unselectedLabelColor: Colors.white,
      indicatorWeight: 2,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      tabs: tabs,
    );
  }
}
