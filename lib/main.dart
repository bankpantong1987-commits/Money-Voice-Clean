import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

void main() => runApp(const MoneyVoiceApp());

class MoneyVoiceApp extends StatefulWidget {
  const MoneyVoiceApp({super.key});
  @override
  State<MoneyVoiceApp> createState() => _MoneyVoiceAppState();
}

class _MoneyVoiceAppState extends State<MoneyVoiceApp> {
  final FlutterTts tts = FlutterTts();
  String lastText = 'ยังไม่มีรายการ';

  @override
  void initState() {
    super.initState();
    _initTts();
    _initListener();
  }

  Future<void> _initTts() async {
    await tts.setLanguage('th-TH');
    await tts.setSpeechRate(0.9);
  }

  Future<void> _initListener() async {
    bool hasPermission = await NotificationListenerService.isPermissionGranted();
    if (!hasPermission) {
      await NotificationListenerService.requestPermission();
    }
    NotificationListenerService.notificationsStream.listen((event) {
      final title = event.title ?? '';
      final content = event.content ?? '';
      final text = '$title $content';
      final match = RegExp(r'(\d[\d,]*\.?\d*)').firstMatch(text);
      if (match != null) {
        final amount = match.group(0)?.replaceAll(',', '') ?? '';
        if (amount.isNotEmpty) {
          setState(() => lastText = 'เงินเข้า $amount บาท');
          speak('เงินเข้า $amount บาท');
        }
      }
    });
  }

  Future<void> speak(String text) async {
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFF3D6),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1BA94A), Color(0xFF00C853)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('💰 Money Voice', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 6),
                      Text('เงินเข้า พูดให้ฟังทันที', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📩 รายการล่าสุด', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Text(lastText, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1BA94A))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9800), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    onPressed: () => speak('เงินเข้า 350 บาท'),
                    child: const Text('🔊 ทดลองฟังเสียงไทย - เงินเข้า 350 บาท', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2196F3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    onPressed: () async { await NotificationListenerService.requestPermission(); },
                    child: const Text('🔔 เปิดการอ่านแจ้งเตือน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('✨ สมัคร Pro เพื่อใช้งานเบื้องหลัง', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _proCard('รายเดือน', '30 บาท/เดือน', 'ทดลองฟรี 3 วัน', const Color(0xFFE8F5E9))),
                    const SizedBox(width: 12),
                    Expanded(child: _proCard('รายปี', '249 บาท/ปี', 'ทดลองฟรี 3 วัน', const Color(0xFFFFF3E0))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _proCard(String title, String price, String trial, Color bg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(trial, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
