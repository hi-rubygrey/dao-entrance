import 'package:asyou_app/pages/chain/import_sr25519_key.dart';
import 'package:asyou_app/pages/channel/invitation.dart';
import 'package:asyou_app/utils/screen.dart';

import 'pages/channel/create_private.dart';
import 'pages/channel/setting/setting.dart';
import 'pages/dao/pop/create_roadmap.dart';
import 'pages/setting/setting.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'pages/channel/create.dart';
import 'pages/main_mobile.dart';
import 'pages/main_pc.dart';
import 'pages/chain/sr25519_key.dart';
import 'pages/search.dart';
import 'pages/select_org.dart';
import 'preloader.dart';
import 'store/theme.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
BuildContext globalCtx() {
  return rootNavigatorKey.currentContext!;
}

routers() {
  return <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const PreloaderPage();
      },
    ),
    GoRoute(
      path: '/mobile',
      builder: (BuildContext context, GoRouterState state) {
        return const MobilePage();
      },
    ),
    GoRoute(
      path: '/pc/:app',
      builder: (BuildContext context, GoRouterState state) {
        return const PCPage();
      },
    ),
    GoRoute(
      path: '/sr25519key',
      builder: (BuildContext context, GoRouterState state) {
        return const Sr25519KeyPage();
      },
    ),
    GoRoute(
      path: '/importSr25519key',
      builder: (BuildContext context, GoRouterState state) {
        return const ImportSr25519KeyPage();
      },
    ),
    GoRoute(
      path: '/select_org',
      builder: (BuildContext context, GoRouterState state) {
        final auto = state.queryParams["auto"];
        return SelectOrgPage(auto: auto ?? "");
      },
    ),
    GoRoute(
      path: '/search',
      builder: (BuildContext context, GoRouterState state) {
        return const SearchPage();
      },
    ),
    GoRoute(
      path: '/create_channel',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateChannelPage();
      },
    ),
    GoRoute(
      path: '/create_private',
      builder: (BuildContext context, GoRouterState state) {
        return const CreatePrivatePage();
      },
    ),
    GoRoute(
      path: '/channel_setting/:id/:t',
      builder: (BuildContext context, GoRouterState state) {
        return ChannelSettingPage(
          id: state.params['id'] ?? "",
          t: state.params['t'] ?? "",
        );
      },
    ),
    GoRoute(
      path: '/invitation/:id',
      builder: (BuildContext context, GoRouterState state) {
        return InvitationPage(id: state.params['id'] ?? "");
      },
    ),
    GoRoute(
      path: '/setting',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingPage();
      },
    ),
    GoRoute(
      path: '/create_roadmap',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateRoadMapPage();
      },
    ),
  ];
}

getPage(String url, Function closeModel) {
  if (url == "/create_channel") {
    return CreateChannelPage(closeModel: closeModel);
  } else if (url == "/search") {
    return SearchPage(closeModel: closeModel);
  } else if (url == "/setting") {
    return SettingPage(closeModel: closeModel);
  } else if (url == "/create_private") {
    return CreatePrivatePage(closeModel: closeModel);
  } else if (url == "/create_roadmap") {
    return CreateRoadMapPage(closeModel: closeModel);
  } else if (url.indexOf("/channel_setting/") == 0) {
    final pstr = url.replaceAll("/channel_setting/", "");
    final ps = pstr.split("/");
    return ChannelSettingPage(
      closeModel: closeModel,
      id: Uri.decodeComponent(ps[0]),
      t: Uri.decodeComponent(ps[1]),
    );
  } else if (url.indexOf("/invitation/") == 0) {
    final pstr = url.replaceAll("/invitation/", "");
    final ps = pstr.split("/");
    return InvitationPage(
      closeModel: closeModel,
      id: Uri.decodeComponent(ps[0]),
    );
  }

  return const Center(child: Text("404"));
}

showModelOrPage(context, url, {double width = 520, double height = 550}) {
  final constTheme = Theme.of(context).extension<ExtColors>()!;
  if (isPc()) {
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: constTheme.sidebarHeaderTextColor.withOpacity(0.06),
      builder: (context) {
        final media = MediaQuery.of(context);
        final bottom = media.size.height - 30.w - height.w;
        return Container(
          margin: EdgeInsets.only(
            left: (media.size.width - width.w) / 2,
            right: (media.size.width - width.w) / 2,
            top: 30.w,
            bottom: bottom > 0 ? bottom : 40.w,
          ),
          width: width.w,
          height: height.w,
          decoration: BoxDecoration(
            color: constTheme.centerChannelBg,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8.w,
              ),
            ],
          ),
          child: getPage(url, () {
            Navigator.pop(context);
          }),
        );
      },
    );
  } else {
    context.push(url);
  }
}
