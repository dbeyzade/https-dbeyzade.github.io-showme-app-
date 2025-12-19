import 'dart:typed_data';
import 'dart:ui' show Size;
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:showme/data/formula_library.dart';
import 'package:showme/models/recognition_result.dart';

class MathSolverService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  CameraController? _cameraController;
  CameraDescription? _cameraDescription;
  bool _isProcessing = false;
  DateTime _lastProcessedAt = DateTime.fromMillisecondsSinceEpoch(0);

  // Kamera başlatma
  Future<void> initCamera(void Function(RecognitionResult result) onResultCallback) async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Arka kamerayı seç
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _cameraDescription = backCamera;

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      // Sürekli görüntü işleme başlat
      _startImageStream(onResultCallback);
    } catch (e) {
      print('Kamera başlatma hatası: $e');
    }
  }

  // Görüntü akışını başlat
  void _startImageStream(void Function(RecognitionResult result) onResultCallback) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _cameraController!.startImageStream((CameraImage image) async {
      final now = DateTime.now();
      if (now.difference(_lastProcessedAt) < const Duration(milliseconds: 700)) {
        return;
      }

      if (_isProcessing) return;
      _isProcessing = true;
      _lastProcessedAt = now;

      try {
        // Görüntüyü işle
        final result = await _processImage(image);
        if (result != null) onResultCallback(result);
      } catch (e) {
        print('Görüntü işleme hatası: $e');
      } finally {
        _isProcessing = false;
      }
    });
  }

  // Görüntüden metin tanıma ve hesaplama
  Future<RecognitionResult?> _processImage(CameraImage image) async {
    try {
      // CameraImage'i InputImage'e çevir
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) return null;

      // Metni tanı
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Önce: formül eşleştirmeyi dene (fizik formülleri)
      final fullMatch = FormulaLibrary.tryMatch(recognizedText.text);
      if (fullMatch != null) return fullMatch;

      // Sonra: satır satır formül/matematik
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          String text = line.text.trim();

          final formulaMatch = FormulaLibrary.tryMatch(text);
          if (formulaMatch != null) return formulaMatch;
          
          // Matematik ifadesi kontrolü
          final normalized = _normalizeMathText(text);
          if (normalized != null && _isMathExpression(normalized)) {
            try {
              final result = _solveMathExpression(normalized);
              if (result != null) {
                // Sadece sonucu döndür (işlemi gösterme)
                return RecognitionResult.math(value: result);
              }
            } catch (e) {
              print('Hesaplama hatası: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Metin tanıma hatası: $e');
    }
    return null;
  }

  // CameraImage'i InputImage'e çevir
  InputImage? _convertCameraImage(CameraImage image) {
    try {
      final Size imageSize = Size(
        image.width.toDouble(),
        image.height.toDouble(),
      );

      final rotation = _rotationFromSensorOrientation(_cameraDescription?.sensorOrientation);

      // iOS: bgra8888 (tek plane). Android: yuv420 -> nv21'e çevir.
      final group = image.format.group;
      if (group == ImageFormatGroup.bgra8888) {
        final Plane plane = image.planes.first;
        final metadata = InputImageMetadata(
          size: imageSize,
          rotation: rotation,
          format: InputImageFormat.bgra8888,
          bytesPerRow: plane.bytesPerRow,
        );
        return InputImage.fromBytes(
          bytes: plane.bytes,
          metadata: metadata,
        );
      }

      if (group == ImageFormatGroup.yuv420) {
        final Uint8List nv21 = _yuv420ToNv21(image);
        final metadata = InputImageMetadata(
          size: imageSize,
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.width,
        );
        return InputImage.fromBytes(
          bytes: nv21,
          metadata: metadata,
        );
      }

      // Diğer formatlar desteklenmiyor.
      return null;
    } catch (e) {
      print('Görüntü dönüştürme hatası: $e');
      return null;
    }
  }

  InputImageRotation _rotationFromSensorOrientation(int? degrees) {
    switch (degrees) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      case 0:
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Uint8List _yuv420ToNv21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final int yRowStride = yPlane.bytesPerRow;
    final int uRowStride = uPlane.bytesPerRow;
    final int vRowStride = vPlane.bytesPerRow;
    final int uPixelStride = uPlane.bytesPerPixel ?? 1;
    final int vPixelStride = vPlane.bytesPerPixel ?? 1;

    final int ySize = width * height;
    final int uvSize = width * height ~/ 2;
    final Uint8List out = Uint8List(ySize + uvSize);

    // Copy Y
    int outIndex = 0;
    for (int row = 0; row < height; row++) {
      final int yRowOffset = row * yRowStride;
      out.setRange(outIndex, outIndex + width, yPlane.bytes, yRowOffset);
      outIndex += width;
    }

    // Interleave VU (NV21)
    final int uvHeight = height ~/ 2;
    final int uvWidth = width ~/ 2;
    for (int row = 0; row < uvHeight; row++) {
      final int uRowOffset = row * uRowStride;
      final int vRowOffset = row * vRowStride;
      for (int col = 0; col < uvWidth; col++) {
        final int uIndex = uRowOffset + col * uPixelStride;
        final int vIndex = vRowOffset + col * vPixelStride;
        out[outIndex++] = vPlane.bytes[vIndex];
        out[outIndex++] = uPlane.bytes[uIndex];
      }
    }

    return out;
  }

  String? _normalizeMathText(String text) {
    var t = text.trim();

    // Eşittir / sonuç kısmını temizle
    // Örn: "11+2=" -> "11+2"
    // Örn: "11+2=13" -> "11+2" (sadece sol taraf)
    if (t.contains('=')) {
      t = t.split('=').first;
    }

    t = t
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('x', '*')
        .replaceAll('X', '*')
        .replaceAll(',', '.')
        .replaceAll(' ', '');

    // Sadece güvenli karakterleri bırak
    t = t.replaceAll(RegExp(r'[^0-9+\-*/().]'), '');

    if (t.isEmpty) return null;
    return t;
  }

  // Matematik ifadesi kontrolü
  bool _isMathExpression(String text) {
    // Matematik operatörlerini içeriyor mu?
    final mathPattern = RegExp(r'^[\d+\-*/().]+$');
    final hasOperator = RegExp(r'[+\-*/]').hasMatch(text);
    return mathPattern.hasMatch(text) && hasOperator && text.length < 50;
  }

  // Matematik ifadesini çöz
  String? _solveMathExpression(String expression) {
    try {
      // İfadeyi temizle
      String cleanExpression = expression
          .replaceAll('x', '*')
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll(',', '.')
          .replaceAll(' ', '');

      // İfadeyi parse et
      // ignore: deprecated_member_use
      Parser parser = Parser();
      Expression exp = parser.parse(cleanExpression);

      // Hesapla
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      // Sonucu formatla
      if (result == result.roundToDouble()) {
        return result.round().toString();
      } else {
        return result.toStringAsFixed(2);
      }
    } catch (e) {
      print('İfade çözme hatası: $e');
      return null;
    }
  }

  // Kaynakları temizle
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
  }

  bool get isInitialized => _cameraController?.value.isInitialized ?? false;
}
