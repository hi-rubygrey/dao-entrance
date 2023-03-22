import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import '../../router.dart';
import '../../store/theme.dart';
import '../../utils/screen.dart';
import '../../models/account.dart';
import '../../apis/account_api.dart';
import '../../rust_wraper.io.dart';
import '../../components/app_bar.dart';

class ImportSr25519KeyPage extends StatefulWidget {
  const ImportSr25519KeyPage({Key? key}) : super(key: key);

  @override
  State<ImportSr25519KeyPage> createState() => _ImportSr25519KeyPageState();
}

class _ImportSr25519KeyPageState extends State<ImportSr25519KeyPage> with WindowListener {
  int step = 0;
  String _name = "";
  String _password = "";
  final TextEditingController seed = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var titles = [L10n.of(context)!.singup1, L10n.of(context)!.singup3];
    return Scaffold(
      appBar: LocalAppBar(
        title: L10n.of(context)!.signUp,
        onBack: () {
          if (step == 0) {
            context.pop();
          } else {
            setState(() {
              step = step - 1;
            });
          }
        },
      ),
      backgroundColor: ConstTheme.centerChannelBg,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                L10n.of(context)!.importAccount,
                style: TextStyle(
                  fontSize: 32.w,
                  color: ConstTheme.centerChannelColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                titles[step],
                style: TextStyle(
                  fontSize: 14.w,
                  color: ConstTheme.centerChannelColor.withOpacity(0.7),
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 40.w,
              ),
              stepRender(step),
            ],
          ),
        ),
      ),
    );
  }

  Widget stepRender(int s) {
    if (s == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: ConstTheme.centerChannelColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Container(
              height: 40.w,
              margin: EdgeInsets.all(10.w),
              padding: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.w)),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: seed,
                autofocus: false,
                minLines: 5,
                maxLines: 6,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                style: TextStyle(color: ConstTheme.centerChannelColor, fontSize: 13.w),
                decoration: InputDecoration(
                  label: null,
                  hintText: L10n.of(context)!.inputMnemonic,
                  hintStyle: TextStyle(
                    height: 1.5,
                    color: ConstTheme.centerChannelColor,
                    fontSize: 14.w,
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40.w,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5.w),
                child: Icon(
                  Icons.warning,
                  size: 14.w,
                  color: ConstTheme.linkColor,
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                // margin: EdgeInsets.only(left: 5.w),
                child: Text(
                  "请写下你的钱包助记词，放在安全的地方。这个助记词可以用来恢复你的钱包。小心保管，以免失去你的资产。",
                  style: TextStyle(
                    fontSize: 12.w,
                    color: ConstTheme.linkColor.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50.w),
          InkWell(
            onTap: () {
              setState(() {
                if (seed.text.split(" ").length != 12) {
                  BotToast.showText(text: '账户助记词长度错误', duration: const Duration(seconds: 2));
                  return;
                }
                step = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 15.w,
                horizontal: 30.w,
              ),
              width: MediaQuery.of(context).size.width * 0.4,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ConstTheme.centerChannelColor,
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        '下一步',
                        style: TextStyle(
                          color: ConstTheme.centerChannelBg,
                          fontWeight: FontWeight.bold,
                          fontSize: 19.w,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: ConstTheme.centerChannelBg,
                  )
                ],
              ),
            ),
          ),
        ],
      );
    } else if (s == 1) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(
                color: ConstTheme.centerChannelColor,
              ),
              decoration: InputDecoration(
                hintText: L10n.of(context)!.accountName,
                hintStyle: TextStyle(
                  fontSize: 14.w,
                  color: ConstTheme.centerChannelColor,
                ),
                filled: true,
                fillColor: ConstTheme.sidebarBg.withOpacity(0.2),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.account_balance_wallet,
                  color: ConstTheme.centerChannelColor,
                ),
              ),
              onSaved: (v) {
                _name = v ?? "";
              },
              validator: (value) {
                RegExp reg = RegExp(r'^[\u4E00-\u9FA5A-Za-z0-9_]+$');
                if (!reg.hasMatch(value ?? "")) {
                  return L10n.of(context)!.accountNameRule;
                }
                if (value == null || value.isEmpty) {
                  return L10n.of(context)!.accountNameNotNull;
                }
                return null;
              },
            ),
            SizedBox(height: 10.w),
            TextFormField(
              style: TextStyle(
                color: ConstTheme.centerChannelColor,
              ),
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: L10n.of(context)!.accountPasswd,
                hintStyle: TextStyle(
                  fontSize: 14.w,
                  color: ConstTheme.centerChannelColor,
                ),
                filled: true,
                fillColor: ConstTheme.sidebarBg.withOpacity(0.2),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.password,
                  color: ConstTheme.centerChannelColor,
                ),
              ),
              onSaved: (v) {
                _password = v ?? "";
              },
              validator: (value) {
                RegExp reg = RegExp(r'^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,}$');
                if (!reg.hasMatch(value ?? "")) {
                  return L10n.of(context)!.accountPasswdRule;
                }
                return null;
              },
            ),
            SizedBox(height: 10.w),
            TextFormField(
              style: TextStyle(
                color: ConstTheme.centerChannelColor,
              ),
              obscureText: true,
              decoration: InputDecoration(
                hintText: L10n.of(context)!.accountPasswd2,
                hintStyle: TextStyle(
                  fontSize: 14.w,
                  color: ConstTheme.centerChannelColor,
                ),
                filled: true,
                fillColor: ConstTheme.sidebarBg.withOpacity(0.2),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.password,
                  color: ConstTheme.centerChannelColor,
                ),
              ),
              onSaved: (v) {
                _password = v ?? "";
              },
              validator: (value) {
                if (_passwordController.text != value) {
                  return L10n.of(context)!.accountPasswdNoeq;
                }
                return null;
              },
            ),
            SizedBox(height: 50.w),
            InkWell(
              onTap: () {
                if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
                  return;
                }
                _formKey.currentState!.save();

                api.getSeedPhrase(seedStr: seed.text, name: _name, password: _password).then((accountStr) async {
                  print(accountStr);
                  // 解码区块链账户问题
                  var chainData = ChainData.fromJson(
                    convert.jsonDecode(accountStr),
                  );

                  // 创建账户
                  var initUser = Account();
                  initUser.name = chainData.meta["name"];
                  initUser.address = chainData.address;
                  initUser.domain = "";
                  initUser.chainData = accountStr;

                  //保存在本地
                  AccountApi.create().addUser(initUser);
                  BotToast.showText(text: '账户创建成功，稍后您需要选择您的组织连接web3网络', duration: const Duration(seconds: 2));

                  rootNavigatorKey.currentContext?.pop();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15.w,
                  horizontal: 30.w,
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ConstTheme.centerChannelColor,
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          '创建本地账户',
                          style: TextStyle(
                            color: ConstTheme.centerChannelBg,
                            fontWeight: FontWeight.w600,
                            fontSize: 19.w,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: ConstTheme.centerChannelBg,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
