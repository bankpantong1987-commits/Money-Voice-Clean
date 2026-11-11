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
        backgroundColor: const Color(0xFFF6F1E7),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Money Voice', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Text('เงินเข้า พูดให้ฟังทันที', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('รายการล่าสุด'),
                      Text(lastText, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => speak('เงินเข้า 350 บาท'),
                    child: const Text('ทดลองฟังเสียงไทย - เงินเข้า 350 บาท'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await NotificationListenerService.requestPermission();
                    },
                    child: const Text('เปิดการอ่านแจ้งเตือน'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('สมัคร Pro เพื่อใช้งานเบื้องหลัง', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _proCard('รายเดือน', '30 บาท/เดือน', 'ทดลองฟรี 3 วัน')),
                    const SizedBox(width: 12),
                    Expanded(child: _proCard('รายปี', '249 บาท/ปี', 'ทดลองฟรี 3 วัน')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _proCard(String title, String price, String trial) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(trial),
        ],
      ),
    );
  }
}
