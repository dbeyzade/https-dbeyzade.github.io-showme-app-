import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showme/models/recognition_result.dart';
import 'package:showme/services/math_solver_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final MathSolverService _mathSolver = MathSolverService();
  RecognitionResult? _currentResult;
  bool _isLoading = true;
  String _statusMessage = 'Kamera başlatılıyor...';
  bool _initStarted = false;
  bool _instructionDismissed = false;

  static const String _instructionText = 'Show the math problem to the camera';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // iOS'ta izin diyaloğunun güvenilir şekilde görünmesi için
    // ilk frame render edildikten sonra izin iste.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mathSolver.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Kullanıcı Ayarlar'dan geri dönerse tekrar başlat.
    if (state == AppLifecycleState.resumed) {
      if (!_mathSolver.isInitialized) {
        _initializeCamera();
      }
    }
  }

  Future<void> _initializeCamera() async {
    try {
      if (_initStarted) return;
      _initStarted = true;

      if (mounted) {
        setState(() {
          _isLoading = true;
          _statusMessage = 'Kamera izni isteniyor...';
        });
      }

      // Uygulama açılır açılmaz kamera iznini iste
      var status = await Permission.camera.request();

      if (status.isGranted || status.isLimited) {
        setState(() {
          _statusMessage = 'Kamera hazırlanıyor...';
        });

        // Kamerayı başlat
        await _mathSolver.initCamera((result) {
          if (mounted) {
            setState(() {
              _currentResult = result;
            });
          }
        });

        setState(() {
          _isLoading = false;
          _statusMessage = _instructionText;
        });
      } else if (status.isPermanentlyDenied || status.isRestricted) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Kamera izni kapalı. Ayarlar > Showme > Kamera\'yı açın.';
        });
      } else {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Kamera izni gerekli';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Hata: $e';
      });
    } finally {
      _initStarted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Image.asset(
                // Kullanıcının eklediği iPhone ekran görüntüsü.
                // Dosya yoksa home.png'ye düş.
                'assets/images/scr2.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/home.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Ana içerik alanı
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Yükleme göstergesi veya durum mesajı
                        if (_isLoading)
                          Column(
                            children: [
                              CircularProgressIndicator(
                                color: Colors.orange.shade400,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                _statusMessage,
                                style: TextStyle(
                                  color: Colors.orange.shade300,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              // Hata/özel durum mesajı (instruction ayrı olarak altta gösterilecek)
                              if (_currentResult == null && _statusMessage != _instructionText)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    _statusMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.orange.shade300,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),

                              // Sonuç gösterimi
                              if (_currentResult != null)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 30),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.orange.shade400,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            _currentResult!.type == RecognitionResultType.math
                                                ? Icons.calculate
                                                : Icons.science,
                                            color: Colors.orange.shade400,
                                            size: 34,
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _currentResult = null;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.orange.shade300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      if (_currentResult!.type == RecognitionResultType.math)
                                        Text(
                                          _currentResult!.displayText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.orange.withValues(alpha: 0.5),
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        Column(
                                          children: [
                                            if (_currentResult!.imageAsset != null)
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 10),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.asset(
                                                    _currentResult!.imageAsset!,
                                                    height: 140,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return const SizedBox.shrink();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            if (_currentResult!.formula != null)
                                              Text(
                                                _currentResult!.formula!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.orange.withValues(alpha: 0.35),
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            const SizedBox(height: 8),
                                            Text(
                                              _currentResult!.inventor ?? _currentResult!.displayText,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.orange.shade200,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Instruction: en altta ve kullanıcı kapatabilsin.
          if (!_isLoading && _currentResult == null && !_instructionDismissed)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.shade400.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            _instructionText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.orange.shade200.withValues(alpha: 0.75),
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                          onPressed: () {
                            setState(() {
                              _instructionDismissed = true;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.orange.shade300.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
