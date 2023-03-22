import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart' as link;

import '../router.dart';
import '../store/theme.dart';
import '../utils/screen.dart';
import 'hover_list_item.dart';

class ChatList extends StatefulWidget {
  final List<link.Room> channelsList;
  final String currentId;
  final Function onSelect;

  const ChatList(this.channelsList, this.currentId, this.onSelect, {Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  // 当前激活
  int hover = -1;

  @override
  Widget build(BuildContext context) {
    final channelsList = widget.channelsList;
    final currentId = widget.currentId;
    final onSelect = widget.onSelect;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: channelsList.length,
      itemBuilder: (context, index) {
        final chat = channelsList[index];
        return HoverListItem(
          key: Key(chat.id),
          ishover: index == hover,
          color: currentId == chat.id ? ConstTheme.sidebarText.withOpacity(0.08) : Colors.transparent,
          hoverColor: ConstTheme.sidebarText.withOpacity(0.08),
          onPressed: () async {
            onSelect(chat.id);
          },
          trailing: GestureDetector(
            onTapDown: (e) async {
              setState(() {
                hover = index;
              });
              final offset = e.globalPosition;
              final result = await showMenu(
                context: context,
                color: ConstTheme.sidebarBg,
                shape: Border.all(color: ConstTheme.sidebarText.withOpacity(0.08)),
                position: RelativeRect.fromLTRB(
                  offset.dx,
                  offset.dy,
                  MediaQuery.of(context).size.width - offset.dx,
                  MediaQuery.of(context).size.height - offset.dy,
                ),
                constraints: const BoxConstraints(minHeight: 0),
                items: <PopupMenuItem<String>>[
                  renderItem("f1", Icons.star_border, chat.isFavourite ? "取消收藏" : "收藏"),
                  renderItem(
                    "f2",
                    Icons.notifications,
                    chat.pushRuleState == link.PushRuleState.notify ? "静音频道" : "取消静音",
                  ),
                  renderItem("f3", Icons.settings, "设置"),
                  renderItem("f4", Icons.add, "添加成员"),
                  renderItem("f5", Icons.time_to_leave_outlined, "离开频道", hideBorder: true),
                ],
              );
              if (result != null) {
                switch (result) {
                  case "f1":
                    await showFutureLoadingDialog(
                      context: globalCtx(),
                      future: () async {
                        await chat.setFavourite(!chat.isFavourite);
                      },
                    );
                    break;
                  case "f2":
                    await showFutureLoadingDialog(
                      context: globalCtx(),
                      future: () => chat.pushRuleState == link.PushRuleState.notify
                          ? chat.setPushRuleState(link.PushRuleState.dontNotify)
                          : chat.setPushRuleState(link.PushRuleState.notify),
                    );
                    break;
                  case "f3":
                    showModelOrPage(
                      globalCtx(),
                      "/channel_setting/${Uri.encodeComponent(chat.id)}/info",
                    );
                    break;
                  case "f4":
                    showModelOrPage(globalCtx(), "/invitation/${Uri.encodeComponent(chat.id)}");
                    break;
                  case "f5":
                    if (OkCancelResult.ok ==
                        await showOkCancelAlertDialog(
                          useRootNavigator: false,
                          title: "提示",
                          message: "确认离开频道",
                          context: globalCtx(),
                          okLabel: L10n.of(globalCtx())!.next,
                          cancelLabel: L10n.of(globalCtx())!.cancel,
                        )) {
                      showFutureLoadingDialog(
                        context: globalCtx(),
                        future: () async {
                          await chat.leave();
                          return true;
                        },
                      );
                    } else {}
                    break;
                }
              }
              setState(() {
                hover = -1;
              });
            },
            child: Container(
              height: 29.w,
              padding: EdgeInsets.only(right: 12.w, left: 12.w),
              child: Icon(Icons.adaptive.more, size: 17.w, color: ConstTheme.sidebarText.withAlpha(155)),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 2.w,
                  color: currentId == chat.id ? ConstTheme.sidebarTextActiveBorder : Colors.transparent,
                ),
              ),
            ),
            height: 35.w,
            width: double.maxFinite,
            // padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10.w),
                Container(
                  width: 25.w,
                  height: 35.w,
                  padding: EdgeInsets.only(top: 2.w),
                  child: Center(
                    child: Icon(
                      chat.encrypted ? Icons.private_connectivity : Icons.all_inclusive_sharp,
                      size: chat.encrypted ? 24.w : 19.w,
                      color:
                          chat.isUnreadOrInvited ? ConstTheme.sidebarUnreadText : ConstTheme.sidebarText.withAlpha(155),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    chat.getLocalizedDisplayname(),
                    style: TextStyle(
                      fontSize: 15.w,
                      fontWeight: chat.isUnreadOrInvited ? FontWeight.bold : FontWeight.normal,
                      color:
                          chat.isUnreadOrInvited ? ConstTheme.sidebarUnreadText : ConstTheme.sidebarText.withAlpha(155),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<String> renderItem(value, icon, name, {hideBorder = false}) {
    return PopupMenuItem<String>(
      padding: EdgeInsets.zero,
      height: 25.w,
      value: value,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          border: Border(
              bottom: !hideBorder ? BorderSide(color: ConstTheme.sidebarText.withOpacity(0.08)) : BorderSide.none),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10.w),
            Icon(icon, color: ConstTheme.sidebarText.withOpacity(0.7), size: 16.w),
            SizedBox(width: 6.w),
            Text(name, style: TextStyle(color: ConstTheme.sidebarText.withOpacity(0.7), fontSize: 12.w, height: 1)),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}