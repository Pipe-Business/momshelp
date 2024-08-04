import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:momhelp/api/api_call.dart';
import 'package:momhelp/utils/date.dart';
import 'package:momhelp/utils/env.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';  // 추가된 부분

void main() {
  Gemini.init(apiKey: Env.gemApiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  Future<String> _loadNickname() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNickname = prefs.getString('nickname') ?? '';

    if (savedNickname.isEmpty) {
      _showNicknameDialog();
      return "";
    } else {
      setState(() {
        _nickname = savedNickname;
      });
      return _nickname;
    }
  }

  Future<void> _showNicknameDialog() async {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('닉네임 입력'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: '닉네임을 입력하세요'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                final newNickname = _controller.text;
                if (newNickname.isNotEmpty) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('nickname', newNickname);

                  setState(() {
                    _nickname = newNickname;
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw "permission error";
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw "permission error";
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return "${position.latitude},${position.longitude}";
    } catch (e) {
      throw e;
    }
  }

  Future<void> _incrementCounter() async {
    final latlng = await getCurrentLocation();

    final gemini = Gemini.instance;
    print(latlng);
    final weather = await fetchGetWeatherDataWithLatLon(lat: '37.461349', lon: '126.8970666');
    print(weather);
    print(getDateToday());
    print(getDateTime());
    final air = await getAirData(date: getDateToday(), time: getDateTime());
    print(air);
    final data = air.body.items.where((element) => element.informData == getDateToday()).toList();
    String name = await _loadNickname();
    String propt =
        "${name} 이 이름이니 이 이름으로 불러줘 날씨 정보는 ${weather.toString()} 이거고 미세먼지 지역은 이거야 여기 위치는 서울이야 ${data.toString()} 이 데이터를 통해 너가 엄마처럼 날씨가 습도 강수량 미세먼지등의 정보로 나갈때 조언을 해줘 예를들면 비가오면 우산을 챙긴다던지 날씨가 더우면 물을 챙기라던지 또한 이 데이터는 바로 TTS 에 연동시킬거기 떄문에 특수문자 없이 그냥 텍스트로 해줘 그리고 엄마니까 반말로해 친근하게 ";
    gemini.text(propt).then((value) {
      FlutterTts tts = FlutterTts();
      if (value?.output != null) {
        print(value?.output);

        tts.speak(value!.output!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_nickname.isNotEmpty ? _nickname : widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              "testbutton",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
