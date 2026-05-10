import 'dart:ffi';
import 'dart:convert';
import 'package:ffi/ffi.dart';

const _pepper = 'poupas_pepper_secret';

class GoSecurityAdapter {
  final DynamicLibrary lib;

  GoSecurityAdapter(this.lib);

  late final _hashPassword = lib.lookupFunction<
      Pointer<Utf8> Function(Pointer<Utf8>),
      Pointer<Utf8> Function(Pointer<Utf8>)>('HashPassword');

  late final _free = lib.lookupFunction<
      Void Function(Pointer<Utf8>),
      void Function(Pointer<Utf8>)>('FreeString');

  String hashPassword(String password) {
    final input = jsonEncode({
      'payload': password,
      'pepper': _pepper,
    });

    final inputPtr = input.toNativeUtf8();
    final resultPtr = _hashPassword(inputPtr);
    malloc.free(inputPtr);

    final resultJson = resultPtr.toDartString();
    _free(resultPtr);

    final decoded = jsonDecode(resultJson) as Map<String, dynamic>;

    if (decoded['success'] != true) {
      throw Exception(
        '[GoSecurityAdapter] HashPassword falhou: ${decoded['error']}',
      );
    }

    return decoded['data'] as String;
  }
}