import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart';

class Identicon {
  final int _rows = 10;
  final int _cols = 10;
  late Function(List<int>) _digest;

  List<int> _fgColour = [255, 255, 255];
  Identicon({List<int>? fg, List<int>? bg}) {
    if (fg != null) {
      _fgColour = fg;
    }

    _digest = md5.convert;
  }

  _bitIsOne(int n, List<int> hashBytes) {
    const scale = 16;
    return hashBytes[n ~/ (scale / 2)] >> ((scale / 2) - ((n % (scale / 2)) + 1)).toInt() & 1 == 1;
  }

  List<int> _createImage(List<List<bool>> matrix, int width, int height, int space, int pad) {
    final image = Image(width + (pad * 2), height + (pad * 2));

    final blockWidth = width ~/ _cols;
    final blockHeight = height ~/ _rows;

    for (int row = 0; row < matrix.length; row++) {
      for (int col = 0; col < matrix[row].length; col++) {
        if (matrix[row][col]) {
          fillRect(
            image,
            pad + col * blockWidth + space + 1,
            pad + row * blockHeight + space + 1,
            pad + (col + 1) * blockWidth - space - 1,
            pad + (row + 1) * blockHeight - space - 1,
            Color.fromRgb(_fgColour[0], _fgColour[1], _fgColour[2]),
          );
        }
      }
    }

    return encodePng(image);
  }

  _createMatrix(List<int> byteList) {
    final cells = (_rows * _cols / 2 + _cols % 2).toInt();
    final matrix = List.generate(_rows, (_) => List.generate(_cols, (_) => false));

    for (int n = 0; n < cells; n++) {
      if (_bitIsOne(n, byteList.getRange(1, byteList.length).toList())) {
        final row = n % _rows;
        final col = n ~/ _cols;
        matrix[row][_cols - col - 1] = true;
        matrix[row][col] = true;
      }
    }
    return matrix;
  }

  Uint8List generate(String text, {int scale = 1}) {
    var size = toSize(70 * scale);
    const bytesLength = 16;
    final hexDigest = _digest(utf8.encode(text)).toString();

    final hexDigestByteList = List<int>.generate(bytesLength, (int i) {
      return int.parse(hexDigest.substring(i * 2, i * 2 + 2), radix: bytesLength);
    });

    final matrix = _createMatrix(hexDigestByteList);
    final bt = _createImage(matrix, size, size, scale, 0);
    Uint8List bytes = Uint8List.fromList(bt);
    return bytes;
  }

  String generateBase64(String text, {int scale = 1}) {
    var size = toSize(70 * scale);
    const bytesLength = 16;
    final hexDigest = _digest(utf8.encode(text)).toString();

    final hexDigestByteList = List<int>.generate(bytesLength, (int i) {
      return int.parse(hexDigest.substring(i * 2, i * 2 + 2), radix: bytesLength);
    });

    final matrix = _createMatrix(hexDigestByteList);
    final bt = _createImage(matrix, size, size, scale, 0);
    return "data:image/png;base64,${base64Encode(bt)}";
  }

  int toSize(int size) {
    if (size % _rows == 0) {
      return size;
    }
    return _rows * ((size - size % _rows) + 1);
  }
}
