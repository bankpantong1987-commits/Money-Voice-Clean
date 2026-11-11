import 'package:flutter_tts/flutter_tts.dart';

// พูดแค่ยอดเงินเท่านั้น ไม่พูดชื่อ ไม่พูดช่องทาง
// ตัวอย่าง: เงินเข้า 350 บาท / เงินออก 120 บาท
class TtsService {
  static final FlutterTts _tts = FlutterTts();
  static Future<void> speakAmount({required bool isIncome, required int amount}) async {
    await _tts.setLanguage('th-TH');
    await _tts.setSpeechRate(0.55);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    final text = isIncome ? 'เงินเข้า $amount บาท' : 'เงินออก $amount บาท';
    await _tts.speak(text);
  }
  static Future<void> testVoice() async {
    await speakAmount(isIncome: true, amount: 350);
  }
}
