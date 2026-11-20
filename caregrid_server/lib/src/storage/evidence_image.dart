import 'dart:convert';
import 'dart:typed_data';

import '../core/access.dart';

/// Bounded signature/dimension checks, not a full decoder or malware scanner.
/// Original bytes are preserved. They may contain EXIF or other metadata.
class EvidenceImage {
  static const maxBytes = 512 * 1024;
  static const maxPixels = 4 * 1024 * 1024;

  static Uint8List decode(String encoded, String mediaType) {
    if (encoded.length > ((maxBytes + 2) ~/ 3) * 4) {
      throw badRequest('Use a PNG or JPEG image of at most 512 KiB.');
    }
    Uint8List bytes;
    try {
      bytes = base64Decode(encoded);
      if (base64Encode(bytes) != encoded) throw const FormatException();
    } on FormatException {
      throw badRequest('Use canonical base64 image data.');
    }
    validate(bytes, mediaType);
    return bytes;
  }

  static void validate(Uint8List bytes, String mediaType) {
    if (bytes.isEmpty || bytes.length > maxBytes) {
      throw badRequest('Use a PNG or JPEG image of at most 512 KiB.');
    }
    (int, int)? dimensions;
    if (mediaType == 'image/png' &&
        bytes.length >= 45 &&
        _matches(bytes, 0, [137, 80, 78, 71, 13, 10, 26, 10]) &&
        _matches(bytes, 8, [0, 0, 0, 13, 73, 72, 68, 82]) &&
        _matches(bytes, bytes.length - 12, [
          0,
          0,
          0,
          0,
          73,
          69,
          78,
          68,
          174,
          66,
          96,
          130,
        ])) {
      final data = ByteData.sublistView(bytes);
      dimensions = (data.getUint32(16), data.getUint32(20));
    } else if (mediaType == 'image/jpeg' &&
        bytes.length >= 12 &&
        _matches(bytes, 0, [255, 216]) &&
        _matches(bytes, bytes.length - 2, [255, 217])) {
      var offset = 2;
      while (offset + 4 <= bytes.length) {
        if (bytes[offset++] != 255) break;
        while (offset < bytes.length && bytes[offset] == 255) {
          offset++;
        }
        if (offset + 3 > bytes.length) break;
        final marker = bytes[offset++];
        if (marker == 218 || marker == 217) break;
        final length = (bytes[offset] << 8) | bytes[offset + 1];
        if (length < 2 || offset + length > bytes.length) break;
        if ([192, 193, 194].contains(marker) && length >= 8) {
          dimensions = (
            (bytes[offset + 5] << 8) | bytes[offset + 6],
            (bytes[offset + 3] << 8) | bytes[offset + 4],
          );
          break;
        }
        offset += length;
      }
    }
    if (dimensions == null ||
        dimensions.$1 <= 0 ||
        dimensions.$2 <= 0 ||
        dimensions.$1 > 4096 ||
        dimensions.$2 > 4096 ||
        dimensions.$1 * dimensions.$2 > maxPixels) {
      throw badRequest(
        'Use a PNG or JPEG image up to 4096 pixels per side and 4 megapixels.',
      );
    }
  }

  static bool _matches(Uint8List bytes, int offset, List<int> expected) {
    for (var i = 0; i < expected.length; i++) {
      if (bytes[offset + i] != expected[i]) return false;
    }
    return true;
  }
}
