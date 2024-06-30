import 'package:cached_network_image/cached_network_image.dart';
import 'package:evercook/core/common/pages/home/search_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/utils/route_transitision.dart';
import 'package:evercook/features/auth/presentation/pages/profile_pages/profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget profileAvatar(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, animationDownToUp(ProfilePage()));
    },
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).splashColor,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, state) {
            if (state is AppUserLoggedIn) {
              return CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  state.user.avatar,
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    ),
  );
}

Widget searchButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      showSearch(
        context: context,
        delegate: CustomSearch(),
      );
    },
    style: TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      iconColor: const Color.fromARGB(255, 221, 56, 32),
    ),
    child: const FaIcon(Icons.search),
  );
}
