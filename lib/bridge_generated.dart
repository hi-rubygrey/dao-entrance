// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.71.1.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

import 'dart:ffi' as ffi;

abstract class RustWraper {
  Future<int> connect({required String url, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kConnectConstMeta;

  /// 获取种子
  Future<List<String>> seedGenerate({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kSeedGenerateConstMeta;

  /// 种子换取账户信息
  Future<String> getSeedPhrase(
      {required String seedStr,
      required String name,
      required String password,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetSeedPhraseConstMeta;

  Future<bool> addKeyring(
      {required String keyringStr, required String password, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kAddKeyringConstMeta;

  Future<String> signFromAddress(
      {required String address, required String ctx, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kSignFromAddressConstMeta;
}

class RustWraperImpl implements RustWraper {
  final RustWraperPlatform _platform;
  factory RustWraperImpl(ExternalLibrary dylib) =>
      RustWraperImpl.raw(RustWraperPlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory RustWraperImpl.wasm(FutureOr<WasmModule> module) =>
      RustWraperImpl(module as ExternalLibrary);
  RustWraperImpl.raw(this._platform);
  Future<int> connect({required String url, dynamic hint}) {
    var arg0 = _platform.api2wire_String(url);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_connect(port_, arg0),
      parseSuccessData: _wire2api_u32,
      constMeta: kConnectConstMeta,
      argValues: [url],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kConnectConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "connect",
        argNames: ["url"],
      );

  Future<List<String>> seedGenerate({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_seed_generate(port_),
      parseSuccessData: _wire2api_StringList,
      constMeta: kSeedGenerateConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kSeedGenerateConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "seed_generate",
        argNames: [],
      );

  Future<String> getSeedPhrase(
      {required String seedStr,
      required String name,
      required String password,
      dynamic hint}) {
    var arg0 = _platform.api2wire_String(seedStr);
    var arg1 = _platform.api2wire_String(name);
    var arg2 = _platform.api2wire_String(password);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_get_seed_phrase(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_String,
      constMeta: kGetSeedPhraseConstMeta,
      argValues: [seedStr, name, password],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetSeedPhraseConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_seed_phrase",
        argNames: ["seedStr", "name", "password"],
      );

  Future<bool> addKeyring(
      {required String keyringStr, required String password, dynamic hint}) {
    var arg0 = _platform.api2wire_String(keyringStr);
    var arg1 = _platform.api2wire_String(password);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_add_keyring(port_, arg0, arg1),
      parseSuccessData: _wire2api_bool,
      constMeta: kAddKeyringConstMeta,
      argValues: [keyringStr, password],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kAddKeyringConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "add_keyring",
        argNames: ["keyringStr", "password"],
      );

  Future<String> signFromAddress(
      {required String address, required String ctx, dynamic hint}) {
    var arg0 = _platform.api2wire_String(address);
    var arg1 = _platform.api2wire_String(ctx);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_sign_from_address(port_, arg0, arg1),
      parseSuccessData: _wire2api_String,
      constMeta: kSignFromAddressConstMeta,
      argValues: [address, ctx],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kSignFromAddressConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "sign_from_address",
        argNames: ["address", "ctx"],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  String _wire2api_String(dynamic raw) {
    return raw as String;
  }

  List<String> _wire2api_StringList(dynamic raw) {
    return (raw as List<dynamic>).cast<String>();
  }

  bool _wire2api_bool(dynamic raw) {
    return raw as bool;
  }

  int _wire2api_u32(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }
}

// Section: api2wire

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class RustWraperPlatform extends FlutterRustBridgeBase<RustWraperWire> {
  RustWraperPlatform(ffi.DynamicLibrary dylib) : super(RustWraperWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class RustWraperWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustWraperWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  RustWraperWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_connect(
    int port_,
    ffi.Pointer<wire_uint_8_list> url,
  ) {
    return _wire_connect(
      port_,
      url,
    );
  }

  late final _wire_connectPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_connect');
  late final _wire_connect = _wire_connectPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_seed_generate(
    int port_,
  ) {
    return _wire_seed_generate(
      port_,
    );
  }

  late final _wire_seed_generatePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_seed_generate');
  late final _wire_seed_generate =
      _wire_seed_generatePtr.asFunction<void Function(int)>();

  void wire_get_seed_phrase(
    int port_,
    ffi.Pointer<wire_uint_8_list> seed_str,
    ffi.Pointer<wire_uint_8_list> name,
    ffi.Pointer<wire_uint_8_list> password,
  ) {
    return _wire_get_seed_phrase(
      port_,
      seed_str,
      name,
      password,
    );
  }

  late final _wire_get_seed_phrasePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>)>>('wire_get_seed_phrase');
  late final _wire_get_seed_phrase = _wire_get_seed_phrasePtr.asFunction<
      void Function(int, ffi.Pointer<wire_uint_8_list>,
          ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_add_keyring(
    int port_,
    ffi.Pointer<wire_uint_8_list> keyring_str,
    ffi.Pointer<wire_uint_8_list> password,
  ) {
    return _wire_add_keyring(
      port_,
      keyring_str,
      password,
    );
  }

  late final _wire_add_keyringPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>)>>('wire_add_keyring');
  late final _wire_add_keyring = _wire_add_keyringPtr.asFunction<
      void Function(
          int, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_sign_from_address(
    int port_,
    ffi.Pointer<wire_uint_8_list> address,
    ffi.Pointer<wire_uint_8_list> ctx,
  ) {
    return _wire_sign_from_address(
      port_,
      address,
      ctx,
    );
  }

  late final _wire_sign_from_addressPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>)>>('wire_sign_from_address');
  late final _wire_sign_from_address = _wire_sign_from_addressPtr.asFunction<
      void Function(
          int, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_uint_8_list>)>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_uint_8_list> Function(
              ffi.Int32)>>('new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

class _Dart_Handle extends ffi.Opaque {}

class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<ffi.Bool Function(DartPort, ffi.Pointer<ffi.Void>)>>;
typedef DartPort = ffi.Int64;
