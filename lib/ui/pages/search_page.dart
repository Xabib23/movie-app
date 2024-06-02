import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/domain/models/movies_model.dart';
import 'dart:math' as math;

import 'package:movies_app/ui/pages/movie_detail_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            centerTitle: true,
            title: const Text(
              'Поиск',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 16),
          const SearchPageInput(),
          const SearchPageList(),
        ],
      ),
    );
  }
}

class SearchPageInput extends StatelessWidget {
  const SearchPageInput({super.key});

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          suffixIcon: Transform.rotate(
            angle: 180 * math.pi / 360,
            child: SvgPicture.asset(
              'assets/images/search.svg',
              fit: BoxFit.none,
            ),
          ),
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          fillColor: const Color(0xff3A3F47),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          hintText: 'Поиск...',
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SearchPageList extends StatelessWidget {
  const SearchPageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        itemBuilder: (context, index) => const SearchPageListItem(),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: 10,
      ),
    );
  }
}

class SearchPageListItem extends StatelessWidget {
  const SearchPageListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => MovieDetailPage(
        //       movie: MovieModel(),
        //     ),
        //   ),
        // );
      },
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 120,
          child: Row(
            children: <Widget>[
              Image.asset(
                'assets/images/item.png',
                width: 95,
                height: 120,
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Spiderman',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  SearchPageListItemOption(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPageListItemOption extends StatelessWidget {
  const SearchPageListItemOption({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SearchPageListItemOptionItem(
          rating: true,
          data: '9.5',
        ),
        SearchPageListItemOptionItem(
          icon: Icons.airplane_ticket,
          data: 'Жанр',
        ),
        SearchPageListItemOptionItem(
          icon: Icons.calendar_today_outlined,
          data: '2019',
        ),
        SearchPageListItemOptionItem(
          icon: Icons.watch_later_outlined,
          data: '2019',
        ),
      ],
    );
  }
}

class SearchPageListItemOptionItem extends StatelessWidget {
  final bool rating;
  final IconData icon;
  final String data;
  const SearchPageListItemOptionItem({
    super.key,
    this.rating = false,
    this.icon = Icons.star_border_rounded,
    this.data = 'Error',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          color: rating ? const Color(0xffFF8700) : Colors.white,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          data,
          style: TextStyle(
            color: rating ? const Color(0xffFF8700) : Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
