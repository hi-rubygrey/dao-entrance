import 'dart:io';
import 'package:asyou_app/components/components.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../components/sider_bar.dart';
import '../store/im.dart';
import '../utils/screen.dart';
import '../apis/apis.dart';
import '../models/models.dart';
import '../store/theme.dart';
import './dao/dao.dart';
import './org/org.dart';

class PCPage extends StatefulWidget {
  const PCPage({Key? key}) : super(key: key);

  @override
  State<PCPage> createState() => _PCPageState();
}

class _PCPageState extends State<PCPage> with WindowListener {
  late List<AccountOrg> aorgs;
  late IMProvider im;
  late PageController pageController;
  int currentId = 0;
  double rightWidth = 200.w;
  String rightUrl = "";

  final mainPages = [
    const OrgPage(),
    const DaoPage(),
    // SettingNav("主题", Icons.notifications),
  ];

  void onPageChanged(int page) {
    //   _page = page;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    if (isPc()) {
      windowManager.addListener(this);
    }
    im = context.read<IMProvider>();
    aorgs = AccountOrgApi.create().listByAccount(im.me!.address);
  }

  @override
  void dispose() {
    if (isPc()) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  onSelect(index) {
    pageController.jumpToPage(index);
    currentId = index;
  }

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    return Scaffold(
      backgroundColor: constTheme.sidebarHeaderBg,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {
              windowManager.startDragging();
            },
            child: Container(
              width: 65.w,
              height: double.maxFinite,
              decoration: BoxDecoration(
                color: constTheme.sidebarHeaderBg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (Platform.isMacOS) SizedBox(height: 20.w),
                  SizedBox(height: 12.w),
                  // 用户
                  Container(
                    width: 52.w,
                    height: 52.w,
                    margin: EdgeInsets.only(bottom: 10.w),
                    child: UserAvatarWithPop(
                      key: Key(im.currentState!.user.id.toString()),
                      im.currentState!.client.userID ?? "-",
                      "",
                      true,
                      52.w,
                      bg: constTheme.sidebarText.withOpacity(0.05),
                      color: constTheme.sidebarText,
                    ),
                  ),
                  // 消息列表
                  SiderBarItem(Appicon.wode4, "消息", selected: currentId == 0, onTap: () {
                    onSelect(0);
                  }),
                  // DAO管理
                  SiderBarItem(Appicon.shebei, "DAO", selected: currentId == 1, onTap: () {
                    onSelect(1);
                  }),
                  // 设置
                  // SiderBarItem(
                  //   Icons.settings_applications,
                  //   "设置",
                  //   selected: false,
                  //   onTap: () {
                  //     showModelOrPage(context, "/setting", width: 0.7.sw, height: 0.8.sh);
                  //   },
                  // ),
                  Flexible(child: Container()),
                  // InkWell(
                  //   onTap: () async {
                  //     const storage = FlutterSecureStorage();
                  //     await storage.delete(key: "login_state");
                  //     im.logout();
                  //   },
                  //   child: SizedBox(
                  //     width: 40.w,
                  //     height: 40.w,
                  //     child: Icon(
                  //       Icons.logout_rounded,
                  //       size: 22.w,
                  //       color: constTheme.sidebarHeaderTextColor.withOpacity(0.8),
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     showModelOrPage(context, "/setting", width: 0.7.sw, height: 0.8.sh);
                  //   },
                  //   child: Container(
                  //     width: 40.w,
                  //     height: 40.w,
                  //     margin: EdgeInsets.fromLTRB(0, 6.w, 0, 12.w),
                  //     child: Icon(
                  //       Icons.settings,
                  //       size: 22.w,
                  //       color: constTheme.sidebarHeaderTextColor.withOpacity(0.8),
                  //     ),
                  //   ),
                  // ),
                  for (var i = 0; i < aorgs.length; i++)
                    Container(
                      width: 40.w,
                      height: 40.w,
                      padding: EdgeInsets.all(2.w),
                      margin: EdgeInsets.fromLTRB(0, 12.w, 0, 0),
                      decoration: BoxDecoration(
                        color: constTheme.sidebarHeaderTextColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.w),
                        border: Border.all(
                          color: constTheme.sidebarTextActiveBorder,
                          width: 2.w,
                        ),
                      ),
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: aorgs[i].orgColor != null
                              ? hexToColor(aorgs[i].orgColor!)
                              : constTheme.sidebarText.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                        child: aorgs[i].orgAvater == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (aorgs[i].orgAvater == null)
                                    Text(
                                      aorgs[i].orgName ?? "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: constTheme.sidebarHeaderTextColor.withOpacity(0.8),
                                        fontSize: 14.w,
                                      ),
                                    ),
                                ],
                              )
                            : Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2.w),
                                  child: Image.network(
                                    fit: BoxFit.cover,
                                    aorgs[i].orgAvater!,
                                    width: 36.w,
                                    height: 36.w,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  SizedBox(height: 20.w),
                ],
              ),
            ),
          ),
          Flexible(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: onPageChanged,
              children: mainPages,
            ),
          ),
          // GestureDetector(
          //   child: MouseRegion(
          //     cursor: SystemMouseCursors.resizeColumn,
          //     child: SizedBox(
          //       width: 1.w,
          //       height: double.infinity,
          //       child: Container(color: constTheme.sidebarText.withOpacity(0.08)),
          //     ),
          //   ),
          //   onPanUpdate: (details) {
          //     setState(() {
          //       if (rightWidth - details.delta.dx < 180.w || rightWidth - details.delta.dx > 350.w) {
          //         return;
          //       }

          //       rightWidth = rightWidth - details.delta.dx;
          //     });
          //   },
          // ),
          // if (rightUrl != "") Container(width: rightWidth, height: double.maxFinite, color: Colors.red),
        ],
      ),
    );
  }
}
