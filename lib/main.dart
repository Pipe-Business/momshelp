import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:momhelp/api/api_call.dart';
import 'package:momhelp/utils/date.dart';
import 'package:momhelp/utils/env.dart';
import 'package:momhelp/utils/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("execute task");
    print("Native called background task: $task");
    fetchNetworkDataAndShowNotification();

    return Future.value(true);
  });
}

Future<void> fetchNetworkDataAndShowNotification() async {
  // 여기서 네트워크 요청을 수행합니다
  // 예: final response = await http.get(Uri.parse('https://api.example.com/data'));
  NotificationService().showNotification(title: "title", body: "body");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  Gemini.init(apiKey: Env.gemApiKey);
  // Workmanager().initialize(callbackDispatcher,isInDebugMode: true);
  // Workmanager().registerOneOffTask("123", "asdf",initialDelay: Duration(seconds: 10));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
  String result = "";
  String _nickname = '';
  String timeString = '';
  String _storedTime = '';
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadNickname();
    _loadStoredTime();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final statuses = await [
          Permission.manageExternalStorage,
          Permission.audio, // 이미지, 비디오, 오디오 접근 권한,
          Permission.systemAlertWindow,
          Permission.scheduleExactAlarm,
          Permission.notification
        ].request();

        if (statuses[Permission.manageExternalStorage]!.isGranted ||
            statuses[Permission.mediaLibrary]!.isGranted ||
            statuses[Permission.systemAlertWindow]!.isGranted ||
            statuses[Permission.scheduleExactAlarm]!.isGranted ||
            statuses[Permission.notification]!.isGranted) {
          // 권한이 허용된 경우
          print("권한이 허용되었습니다.");
        } else {
          // 권한이 거부된 경우
          print("권한이 거부되었습니다.");
        }
      },
    );
  }

  Future<void> _loadStoredTime() async {
    final prefs = await SharedPreferences.getInstance();
    timeString = prefs.getString('lastSetTime') ?? '';
    setState(() {});
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
    final weather = await fetchGetWeatherDataWithLatLon(
        lat: '37.461349', lon: '126.8970666');
    print(weather);
    print(getDateToday());
    print(getDateTime());
    final air = await getAirData(date: getDateToday(), time: getDateTime());
    print(air);
    final data = air.body.items
        .where((element) => element.informData == getDateToday())
        .toList();
    String name = await _loadNickname();
    String propt =
        "${name} 이 이름이니 이 이름으로 불러줘 날씨 정보는 ${weather.toString()} 이거고 미세먼지 지역은 이거야 여기 위치는 서울이야 ${data.toString()} 이 데이터를 통해 너가 엄마처럼 날씨가 습도 강수량 미세먼지등의 정보로 나갈때 조언을 해줘 이 데이터는 바로 TTS 에 연동시킬거기 떄문에 특수문자 없이 그냥 텍스트로 해줘 그리고 엄마니까 반말로해 친근하게 ";
    gemini.text(propt).then((value) {
      FlutterTts tts = FlutterTts();
      if (value?.output != null) {
        setState(() {
          result = value!.output!;
        });

        tts.speak(value!.output!);
      }
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
        timeString = picked.format(context);
      });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _onConfirmPressed(
      BuildContext context, MethodChannel channel) async {
    if (_selectedTime != null) {
      final prefs = await SharedPreferences.getInstance();

      // 새로운 시간 문자열 생성
      String newTime = _selectedTime!.format(context);

      // 시간 저장
      await prefs.setString('lastSetTime', newTime);

      _loadStoredTime();
      DateTime now = DateTime.now();
      DateTime tomorrow = now.add(Duration(days: 1));

      // 내일 날짜와 선택된 시간을 조합하여 DateTime 객체 생성
      DateTime selectedDateTime = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // DateTime을 밀리초 단위 정수값으로 변환
      int alarmTimeMillis = selectedDateTime.millisecondsSinceEpoch;
      // 알람 ID 값을 가져오거나 기본값 1로 초기화
      int alarmId = prefs.getInt('alarmId') ?? 1;

      setState(() {
        _selectedTime = null;
        timeString = "";
        _storedTime = newTime;
      });
      // 알람 ID 값을 +1 해서 저장
      await prefs.setInt('alarmId', alarmId + 1);

      Workmanager().registerPeriodicTask(
        '1',
        'fetchData',
        initialDelay: Duration(seconds: 10), // 초기 지연 시간 설정
      );
      print("workmanger 설정ㄷE");

      Navigator.of(context).pop(); // 다이얼로그 닫기
      _showSnackBar(context, '시간이 설정되었습니다.');
    } else {
      _showSnackBar(context, '시간을 선택해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    const channel = MethodChannel("alarmChannel");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_nickname.isNotEmpty ? _nickname : widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // if (timeString.isNotEmpty)
            //   Column(
            //     children: [
            //       Text("설정된 시간: $timeString", style: TextStyle(fontSize: 20)),
            //       SizedBox(height: 10),
            //       ElevatedButton(
            //         onPressed: () async {
            //           // 알람 삭제 로직
            //           final prefs = await SharedPreferences.getInstance();
            //           await prefs.remove('lastSetTime');
            //           setState(() {
            //             timeString = '';
            //           });
            //           _showSnackBar(context, '알람이 삭제되었습니다.');
            //         },
            //         child: Text('알람 삭제하기'),
            //       ),
            //     ],
            //   ),
            // if (timeString.isEmpty)
            //   ElevatedButton(
            //     onPressed: () {
            //       showDialog(
            //         context: context,
            //         builder: (context) {
            //           return Dialog(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Text("알람을 울릴 시간을 설정해주세요"),
            //                   ElevatedButton(
            //                     onPressed: () => _selectTime(context),
            //                     child: Text("시간 설정하기"),
            //                   ),
            //                   ElevatedButton(
            //                     onPressed: () => _onConfirmPressed(context,channel),
            //                     child: Text("확인"),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //     child: Text('알람 추가하기'),
            //
            //   ),
            Image.asset(
              "assets/images/mom_image.png",
              height: 300,
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Text(
                result,
                style: TextStyle(fontSize: 14),
              ),
            ),

            Container(
              width: double.infinity,
              height: 48,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  backgroundColor: Colors.black,
                ),
                  onPressed: () {
                    _incrementCounter();
                  },
                  child: Text("엄마의 말 들어보기", style: TextStyle(color: Colors.white, fontSize: 20),)),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
