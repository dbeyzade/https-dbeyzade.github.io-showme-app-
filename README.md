# ShowMe - AI Matematik Çözücü 🧠

ShowMe, kameranızı kullanarak ekranınızdaki matematik işlemlerini otomatik olarak tanıyıp çözen akıllı bir Flutter uygulamasıdır.

## ✨ Özellikler

- 📷 **Arka Plan Kamera**: Kamera arka planda çalışır, görüntü ekrana yansımaz
- 🤖 **AI Destekli**: Google ML Kit ile metin tanıma
- ➕ **Matematik Çözme**: Toplama, çıkarma, çarpma, bölme işlemlerini otomatik çözer
- ⚡ **Anlık Sonuç**: İşlemleri görmeden direkt sonucu gösterir
- 🎨 **Modern UI**: Futuristik ve şık arayüz tasarımı

## 📋 Gereksinimler

- Flutter 3.10.1 veya üzeri
- iOS 13.0+ veya Android API 21+
- Kamera izni

## 🚀 Kurulum

1. Projeyi klonlayın veya indirin
2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. iOS için pod kurulumu:
```bash
cd ios
pod install
cd ..
```

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## 📱 Kullanım

1. Uygulamayı açın
2. Kamera iznini verin
3. Ekranınıza matematik işlemi gösterin (örn: `25 + 15`)
4. Uygulama otomatik olarak işlemi tanıyıp sonucu gösterecektir

## 🔢 Desteklenen İşlemler

- **Toplama**: `25 + 15 = 40`
- **Çıkarma**: `50 - 20 = 30`
- **Çarpma**: `12 * 8 = 96` veya `12 x 8` veya `12 × 8`
- **Bölme**: `100 / 5 = 20` veya `100 ÷ 5`
- **Parantezli işlemler**: `(10 + 5) * 2 = 30`
- **Ondalık sayılar**: `12.5 + 7.3 = 19.8`

## 🛠 Teknik Detaylar

### Kullanılan Teknolojiler

- **Flutter**: Mobil uygulama framework'ü
- **Camera Plugin** (^0.10.5): Kamera erişimi
- **Google ML Kit** (^0.13.0): Metin tanıma (OCR)
- **Math Expressions** (^2.5.0): Matematik ifadelerini hesaplama
- **Permission Handler** (^11.3.1): İzin yönetimi

### Mimari

```
lib/
├── main.dart                       # Uygulama giriş noktası
├── screens/
│   └── home_screen.dart           # Ana ekran ve UI
└── services/
    └── math_solver_service.dart   # Kamera ve hesaplama servisi

assets/
└── images/
    └── icon.png                   # AI yüz görseli
```

### Nasıl Çalışır?

1. **Kamera Başlatma**: Uygulama açılır açılmaz arka kamera arka planda başlatılır
2. **Görüntü İşleme**: Her saniye kameradan bir frame alınır
3. **Metin Tanıma**: Google ML Kit ile frame'deki metinler tanınır
4. **Matematik Tespiti**: Tanınan metinlerden matematik ifadeleri filtrelenir
5. **Hesaplama**: Geçerli ifadeler math_expressions ile çözülür
6. **Sonuç Gösterimi**: Sonuç ekranda gösterilir

## ⚠️ Önemli Notlar

- Kamera arka planda çalışır ve görüntü ekrana yansımaz
- İşlemler sürekli taranır ve tanındıkça sonuç güncellenir
- En iyi sonuç için işlemleri net ve düzgün yazın
- Karmaşık işlemler için parantez kullanabilirsiniz
- İşlem çok uzun veya karmaşıksa tanınmayabilir

## 🎨 Özelleştirme

Renk temasını değiştirmek için [main.dart](lib/main.dart) dosyasındaki `ThemeData` ayarlarını düzenleyin:

```dart
theme: ThemeData(
  primarySwatch: Colors.orange,  // Ana renk
  scaffoldBackgroundColor: const Color(0xFF0A1628),  // Arka plan
  // ...
)
```

## 🐛 Sorun Giderme

### Kamera Açılmıyor
- İzinlerin verildiğinden emin olun
- iOS: Info.plist'te `NSCameraUsageDescription` tanımlı
- Android: AndroidManifest.xml'de kamera izinleri var

### OCR Çalışmıyor
- İyi aydınlatma koşullarında kullanın
- İşlemleri net ve okunaklı yazın
- Telefonu sabit tutun

### Yanlış Sonuç
- İşlemi daha net yazın
- Virgül yerine nokta kullanın (12.5)
- Boşlukları doğru kullanın

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir.

---

Geliştirici: Dogukan Beyzade
