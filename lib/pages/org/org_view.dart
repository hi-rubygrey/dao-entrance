import 'dart:async';
import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart' as link;

import './org_menu.dart';
import '../../router.dart';
import '../../utils/screen.dart';
import '../../components/components.dart';
import '../../components/popup.dart';
import '../../models/models.dart';
import '../../store/im.dart';
import '../../store/theme.dart';

class OrgViewPage extends StatefulWidget {
  final Function(String) onChannel;
  final double width;
  const OrgViewPage({Key? key, required this.onChannel, required this.width}) : super(key: key);

  @override
  State<OrgViewPage> createState() => _OrgViewPageState();
}

class _OrgViewPageState extends State<OrgViewPage> {
  late ExpandableController _controllerChannels;
  late ExpandableController _controllerStarred;
  late ExpandableController _controllerUsers;
  late link.Client client;
  StreamSubscription? _onRoom;

  final BasePopupMenuController menuController = BasePopupMenuController();
  final StreamController<bool> menuStreamController = StreamController<bool>();
  IMProvider? im;
  AccountOrg? org;
  String channelId = "";
  String directId = "";
  List<link.Room> channels = [];
  List<link.Room> directChats = [];

  @override
  void initState() {
    super.initState();
    _controllerChannels = ExpandableController(initialExpanded: true);
    _controllerStarred = ExpandableController(initialExpanded: true);
    _controllerUsers = ExpandableController(initialExpanded: true);
    menuController.addListener(() {
      menuStreamController.add(menuController.menuIsShowing);
    });

    Timer(const Duration(milliseconds: 300), () {
      im = context.read<IMProvider>();
      onImInit();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controllerChannels.dispose();
    _controllerStarred.dispose();
    _controllerUsers.dispose();
    _onRoom?.cancel();
  }

  onImInit() {
    if (im!.current == null || im!.currentState == null) {
      return;
    }
    client = im!.currentState!.client;
    _onRoom = client.onRoomState.stream.listen((event) {
      if (["m.room.history_visibility", "m.room.join_rules", "m.room.power_levels"].contains(event.body)) {
        return;
      }
      // print("client.onRoomState.stream ===>> ${event.type}");
      getRoom();
    });
    getRoom();
  }

  getRoom() {
    final clist = client.rooms.toList();

    setState(() {
      channels = clist.where((c) => !c.isDirectChat).toList();
      directChats = clist.where((c) => c.isDirectChat).toList();
    });

    org = im!.currentState!.org;
    if (channelId.isEmpty && channels.isNotEmpty) {
      setChannelId(channels[0].id);
    }
  }

  void setChannelId(String id) {
    if (id == channelId) {
      return;
    }
    if (mounted) {
      setState(() => channelId = id);
      if (channelId.isNotEmpty) {
        widget.onChannel(channelId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    return Column(
      children: [
        moveWindow(
          Row(
            children: [
              SizedBox(width: 14.w),
              BasePopupMenu(
                verticalMargin: -1.w,
                horizontalMargin: 5.w,
                showArrow: false,
                controller: menuController,
                pressType: PressType.singleClick,
                position: PreferredPosition.bottomLeft,
                child: StreamBuilder<bool>(
                  stream: menuStreamController.stream,
                  initialData: false,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return Container(
                      height: 35.w,
                      width: widget.width - 79.w,
                      padding: EdgeInsets.only(left: 10.w, right: 7.w, top: 2.w, bottom: 2.w),
                      decoration: BoxDecoration(
                        color: snapshot.data != null && snapshot.data!
                            ? constTheme.sidebarText.withOpacity(0.25)
                            : constTheme.sidebarText.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(3.w)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              org != null && org!.orgName != null ? org!.orgName! : '',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: constTheme.sidebarText,
                                fontWeight: FontWeight.w800,
                                fontSize: 15.w,
                                height: 1.3,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: constTheme.sidebarText,
                            size: 18.w,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                menuBuilder: () => orgMenuRender(menuController, widget.width - 30.w),
              ),
              SizedBox(width: 10.w),
              InkWell(
                onTap: () {
                  showModelOrPage(context, "/search");
                },
                child: Container(
                  height: 35.w,
                  width: 35.w,
                  margin: EdgeInsets.only(left: 0.w, right: 15.w, top: 15.w, bottom: 15.w),
                  // padding: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    color: constTheme.sidebarText.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(3.w)),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.search, size: 20.w, color: constTheme.sidebarText),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: constTheme.sidebarText.withOpacity(0.08),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.w, bottom: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          L10n.of(context)!.channel,
                          style: TextStyle(
                            color: constTheme.sidebarText,
                            fontWeight: FontWeight.w800,
                            fontSize: 14.w,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            key: const Key("create_channel"),
                            onTap: () async {
                              showModelOrPage(
                                context,
                                "/create_channel",
                                width: 450.w,
                                height: 300.w,
                              );
                            },
                            child: Icon(
                              Icons.add,
                              size: 20.w,
                              color: constTheme.sidebarText,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _controllerChannels.toggle();
                              });
                            },
                            child: Icon(
                              _controllerChannels.expanded
                                  ? Icons.keyboard_arrow_down_outlined
                                  : Icons.keyboard_arrow_up_outlined,
                              size: 25.w,
                              color: constTheme.sidebarText.withAlpha(180),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ExpandablePanel(
                  key: const Key("room"),
                  controller: _controllerChannels,
                  collapsed: const SizedBox(),
                  expanded: ChannelList(
                    key: const Key("ChannelList"),
                    channels,
                    channelId,
                    (id) {
                      setChannelId(id);
                    },
                  ),
                ),
                SizedBox(height: 5.w),
                Divider(
                  height: 1,
                  color: constTheme.sidebarText.withOpacity(0.05),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.w, bottom: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          L10n.of(context)!.directChat,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.w,
                            color: constTheme.sidebarText,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            key: const Key("create_private"),
                            onTap: () async {
                              showModelOrPage(
                                context,
                                "/create_private",
                                width: 550.w,
                                height: 0.7.sh,
                              );
                            },
                            child: Icon(
                              Icons.add,
                              size: 20.w,
                              color: constTheme.sidebarText,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _controllerUsers.toggle();
                              });
                            },
                            child: Icon(
                              _controllerUsers.expanded
                                  ? Icons.keyboard_arrow_down_outlined
                                  : Icons.keyboard_arrow_up_outlined,
                              size: 25.w,
                              color: constTheme.sidebarText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ExpandablePanel(
                  key: const Key("droom"),
                  controller: _controllerUsers,
                  collapsed: const SizedBox(),
                  expanded: DirectChats(
                    key: const Key("DirectChats"),
                    directChats,
                    channelId,
                    (id) {
                      setChannelId(id);
                    },
                  ),
                ),
                SizedBox(height: 5.w),
                Divider(
                  height: 1,
                  color: constTheme.sidebarText.withOpacity(0.05),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
