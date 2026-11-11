import 'package:flutter/material.dart';
import 'services/tts_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MoneyVoiceApp());
}

class MoneyVoiceApp extends StatelessWidget {
  const MoneyVoiceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00C853))),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int income = 0;
  int outcome = 0;
  final List<String> history = [];
  String voice = 'ผู้หญิงสุภาพ';
  final voices = ['ผู้หญิงสุภาพ', 'ผู้ชายสุภาพ', 'เสียงน่ารัก', 'เสียงเข้ม'];
  bool isPro = false;

  void simulate(bool isIncome) async {
    final amount = isIncome ? 350 : 120;
    await TtsService.speakAmount(isIncome: isIncome, amount: amount);
    setState(() {
      if (isIncome) income += amount; else outcome += amount;
      history.insert(0, '${isIncome ? 'เงินเข้า' : 'เงินออก'} $amount บาท');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Money Voice')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: ListTile(title: const Text('ยอดวันนี้'), subtitle: Text('เข้า $income บาท • ออก $outcome บาท'))),
        const SizedBox(height: 12),
        if (!isPro)
          const Card(color: Color(0xFFFFF8E1), child: ListTile(title: Text('แพ็กเกจฟรี'), subtitle: Text('ใช้ได้เฉพาะตอนเปิดแอปค้างไว้ ถ้าพับแอปเสียงจะไม่ดัง'))),
        if (isPro)
          const Card(color: Color(0xFFE8F5E9), child: ListTile(title: Text('PRO กำลังทำงานเบื้องหลัง'), subtitle: Text('พับแอปได้เลย เสียงยังดังอยู่'))),
        const SizedBox(height: 12),
        const Text('เสียงภาษาไทย ใช้ได้ตั้งแต่แพ็กเกจแรก', style: TextStyle(fontWeight: FontWeight.bold)),
        ...voices.map((v) => RadioListTile(value: v, groupValue: voice, onChanged: (val) => setState(() => voice = val.toString()), title: Text(v))),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: () => TtsService.testVoice(), child: const Text('ทดลองฟังเสียงไทย - เงินเข้า 350 บาท')),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: ElevatedButton(onPressed: () => simulate(true), child: const Text('จำลองเงินเข้า'))),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton(onPressed: () => simulate(false), child: const Text('จำลองเงินออก'))),
        ]),
        const SizedBox(height: 16),
        const Text('ประวัติ', style: TextStyle(fontWeight: FontWeight.bold)),
        ...history.map((h) => ListTile(title: Text(h))),
        const SizedBox(height: 16),
        const Card(child: ListTile(title: Text('Pro: รายเดือน 30 บาท/เดือน'), subtitle: Text('ทดลองใช้ฟรี 3 วัน'))),
        const Card(child: ListTile(title: Text('Pro: รายปี 249 บาท/ปี'), subtitle: Text('คุ้มสุด ประหยัด 111 บาท • ทดลองใช้ฟรี 3 วัน'))),
        const Text('ชำระผ่าน Google Play Billing เท่านั้น', style: TextStyle(color: Colors.grey)),
      ]),
    );
  }
}
