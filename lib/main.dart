import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:momhelp/api/api_call.dart';
import 'package:momhelp/common/fetch_translator.dart';
import 'package:momhelp/utils/background_notification.dart';
import 'package:momhelp/utils/date.dart';
import 'package:momhelp/utils/env.dart';
import 'package:momhelp/utils/notification_service.dart';
import 'package:momhelp/widget/time_setting_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:translator/translator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String getDeviceLocale() {
  String r = defaultTargetPlatform == TargetPlatform.iOS
      ? WidgetsBinding.instance.window.locale.toString()
      : Platform.localeName;
  if(r=="zh_Hans_CN")
    return 'zh_Hans_CN';
  return r;
}

Future<String> _loadNickNameOrigin() async {
  final prefs = await SharedPreferences.getInstance();
  final savedNickname = prefs.getString('nickname') ?? '';
  return savedNickname;
}

Future<String> getCurrentLocationOrigin() async {
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
  } catch (e, stacktace) {
    print(stacktace);
    throw e;
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("execute task $task / ${Workmanager.iOSBackgroundTask}");
    if (Platform.isIOS) {
      try {
        print("ios Native called background task: $task");

        await fetchNetworkDataAndShowNotification();
        print("end function");
      } catch (e) {
        print(e);
      }
    }
    if (task == "push data" || task == Workmanager.iOSBackgroundTask) {
      try {
        print("Native called background task: $task");
        await fetchNetworkDataAndShowNotification();
      } catch (e) {
        print(e);
      }
    }

    return Future.value(true);
  });
}

Future<String> getAiGenerateData() async {
  SharedPreferences.getInstance();
  print("call function");
  final latlng = await getCurrentLocationOrigin();
  print("locagion $latlng");
  try {
    final language = getDeviceLocale();
    final weather = await fetchGetWeatherDataWithLatLon(
        lat: latlng.split(',')[0], lon: latlng.split(',')[1]);
    print(weather);
    print(getDateToday());
    print(getDateTime());
    final air = await getAirData(date: getDateToday(), time: getDateTime());
    print("air $air");
    var data;
    if (air.body.totalCount==0){
      data=[];

    }else{
       data = air.body.items
          .where((element) => element.informData == getDateToday())
          .toList();
    }
    print("미세먼지 :$data");
    String name = await _loadNickNameOrigin();
    var propt ="";
    if (language == "ko_KR") {
      // 한국어의 경우 미세먼지 정보 포함
      propt =
          "너는 엄마의 역할을 해서 자식에게 날씨 정보를 알려주는 역할이야, 기계 같은 느낌이 나면 절대로 안되고, 실제 엄마처럼 반말로 말해주고 친근하게 이름을 불러주고 날씨 수치데이터를 추상적으로 표현해서 말해줘, 이름은 ${name} 이야 날씨는 정보 : ${weather.weather},기온: ${weather.main?.temp}, 체감온도: ${weather.main?.feels_like},  습도: ${weather.main?.humidity} 미세먼지 :  ${data.length>1 ? data[0].informData:""} 또한  수치적인 데이터를 그대로 말하는게 아닌 추상적으로 말해주고, 날씨 습도등을 고려한 옷차림 추천도 해줘 특수문자 없이 그냥 텍스트로 해줘";
    } else {
      // 한국을 제외한 다른 나라의 경우 미세먼지 데이터 제외시킴
      propt =
          "너는 엄마의 역할을 해서 자식에게 날씨 정보를 알려주는 역할이야, 기계 같은 느낌이 나면 절대로 안되고, 실제 엄마처럼 반말로 말해주고 친근하게 이름을 불러주고 날씨 수치데이터를 추상적으로 표현해서 말해줘, 이름은 ${name} 이야 날씨는 정보 : ${weather.weather},기온: ${weather.main?.temp}, 체감온도: ${weather.main?.feels_like},  습도: ${weather.main?.humidity} 또한 수치적인 데이터를 그대로 말하는게 아닌 추상적으로 말해주고, 날씨 습도등을 고려한 옷차림 추천도 해줘 특수문자 없이 그냥 텍스트로 해줘";
      propt =
          (await translateText(propt, from: 'ko', to: language.split('_')[0]));
    }
    print(propt);
    Gemini.init(apiKey: Env.gemApiKey);
    final gemini = Gemini.instance;
    print("gemini $gemini");
    final value = await gemini.text(propt);
    print("value :$value");
    print(value?.output);
    var result = "";
    return value!.output!;
  } catch (e) {
    print(e);
    return "error";
  }
}

Future<void> fetchNetworkDataAndShowNotification() async {
  final data = await getAiGenerateData();
  await backgroundNotification(title: "알림", content: data);
}

Future<String> translateText(String text,
    {String from = 'auto', String to = 'en'}) async {
  GoogleTranslator translator = GoogleTranslator();
  var translation = await translator.translate(text, from: from, to: to);
  return translation.text;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  print(getDeviceLocale());
  Gemini.init(apiKey: Env.gemApiKey);
  NotificationService().initNotification();
  await SharedPreferences.getInstance();
  Workmanager().initialize(callbackDispatcher,isInDebugMode: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // context가 없는 곳에서 context를 사용할 수 있는 방
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
  String timeStringDialog = '';
  String _storedTime = '';
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadNickname();
    _loadStoredTime();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
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
        final statuses = await [
          Permission.scheduleExactAlarm,
          Permission.notification,
          Permission.locationWhenInUse,
          Permission.backgroundRefresh,
        ].request();

        if (statuses[Permission.scheduleExactAlarm]!.isGranted ||
            statuses[Permission.locationWhenInUse]!.isGranted ||
            statuses[Permission.backgroundRefresh]!.isGranted ||
            statuses[Permission.notification]!.isGranted
        ) {
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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('닉네임 입력'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: '닉네임을 입력하세요'),
          ),
          actions: <Widget>[
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
              child: const Text('확인'),
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

  Future<void> _generateMomMessage() async {
    FlutterTts tts = FlutterTts();
    String language=getDeviceLocale();
    tts.stop();
    tts.setLanguage(language.split('_')[0]);
    final data = await getAiGenerateData();
    setState(() {
      result = data;
    });
    tts.speak(data);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        timeStringDialog =
            "${picked.period == DayPeriod.am ? "오전" : "오후"} ${picked.hourOfPeriod}시${picked.minute}분";
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_nickname.isNotEmpty ? _nickname : ""),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (timeString.isNotEmpty)
              Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("알림 시간", style: TextStyle(fontSize: 18)),
                            Text(timeString,
                                style: const TextStyle(
                                  fontSize: 25,
                                )),
                          ],
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("삭제하시겠습니까?"),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        await prefs.remove('lastSetTime');
                                        setState(() {
                                          timeString = '';
                                        });
                                        _showSnackBar(context, '알람이 삭제되었습니다.');
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          // 중요 작업에 대해 주의를 주는 색상
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      child: const Text("네",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        backgroundColor:
                                            Colors.grey[200], // 덜 강조된 배경색
                                      ),
                                      child: const Text(
                                        "아니오",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            // 알람 삭제 로직
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 34,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider()
                ],
              ),
            if (timeString.isEmpty)
              Column(
                children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: const Text(
                        "원하는 시간에 날씨정보를 요약해서 들어볼수 있어요",
                        textAlign: TextAlign.center,
                      )),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return const TimeSettingDialog();
                          },
                        );
                        _loadStoredTime();
                        setState(() {});
                      },
                      child: const Text(
                        '알람 추가하기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            const Spacer(),
            Image.asset(
              "assets/images/mom_image.png",
              height: 300,
            ),

            SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                height: 150,
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    _generateMomMessage();
                  },
                  child: const Text(
                    "엄마의 말 들어보기",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ),
            const Spacer(),
            // TODO : admob 자리
            Container(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
