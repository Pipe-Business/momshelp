import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:momsmind/api/api_call.dart';
import 'package:momsmind/data/air_entity.dart';
import 'package:momsmind/data/weather_entity.dart';
import 'package:momsmind/utils/background_notification.dart';
import 'package:momsmind/utils/date.dart';
import 'package:momsmind/utils/env.dart';
import 'package:momsmind/utils/notification_service.dart';
import 'package:momsmind/widget/time_setting_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:workmanager/workmanager.dart';

import 'common/permission_service.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String getDeviceLocale() {
  String r = defaultTargetPlatform == TargetPlatform.iOS
      ? WidgetsBinding.instance.window.locale.toString()
      : Platform.localeName;
  if (r == "zh_Hans_CN") return 'zh_Hans_CN';
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
    print("백그라운드 태스크 시작: $task");
    try {
      await NotificationService().showNotification();
      print("알림 전송 완료");
      return Future.value(true);
    } catch (e) {
      print("알림 전송 실패: $e");
      return Future.value(false);
    }
  });
}

String parsingWeatherData(Weather weather) {
  print("functtiion $weather");
  int originId = weather.id ?? 801;
  print(originId);
  int mainCode = ((weather.id ?? 801) / 100).toInt();
  print(mainCode);
  // mainCode=3;
  // originId=800;
  if (mainCode == 2) {
    return "번개,폭우";
  } else if (mainCode == 3 && mainCode == 5) {
    // if (originId == 313 || originId == 321 || originId == 521) {
    //   return "소나기가 내릴거야";
    // }
    return "비";
  } else if (mainCode == 6) {
    // if (611 <= originId && originId <= 616) {
    //   return "눈과 비가 같이 내릴거야";
    // }
    return "눈";
  } else if (mainCode == 7) {
    return "${weather.main} ${weather.description}";
  } else if (originId == 800) {
    return "맑음";
  } else if (801 <= originId && originId <= 804) {
    return "구름:흐림";
  }
  return "";
}

Future<String> getAiGenerateDataWorkManger(WeatherData weather) async {
  try {
    final language = getDeviceLocale();
    print(weather);
    final air = await getAirData(date: getDateToday(), time: getDateTime());
    List<AirQualityItem> data;
    String airSimple = "";
    if (air.body.totalCount == 0) {
      data = [];
    } else {
      data = air.body.items
          .where((element) => element.informData == getDateToday())
          .toList();
      airSimple = data[0].informOverall ?? "";
    }
    String name = await _loadNickNameOrigin();
    var propt = "";
    var parsing = "";
    // 현재 시간 가져오기
    DateTime now = DateTime.now();

    // 낮인지 밤인지 판단
    bool isDayTime = now.hour >= 6 && now.hour < 18;
    // 현재 시(hour) 가져오기
    int currentHour = now.hour;
    currentHour = 8;
    if (weather.weather == null) {
      parsing = "";
    } else {
      parsing = weather.weather!.isNotEmpty
          ? parsingWeatherData(weather.weather![0])
          : "";
    }
    if (language == "ko_KR") {
      // 한국어의 경우 미세먼지 정보 포함
      propt =
          "너는 엄마의 역할을 해서 자식에게 날씨 정보를 알려주는 역할이야\n실제 엄마가 자식을 대하듯이 반말로 친근하게 이름을 불러주고 또한 상황에 따라 날씨와 온도 기반으로 옷차림 추천을 해줘서 대화의 맥락을 자연스럽게 해줘\n기온이나 습도,채감온도등 수치적인 데이터 언급하지 말고 추상적으로 말해주고\n전체적으로 2~3줄 이하로 특수문자 없이 텍스트로 작성해줘\n자식이름 :$name\n날씨 정보 : $parsing,\n기온: ${weather.main?.temp}, 체감온도: ${weather.main?.feels_like},  습도: ${weather.main?.humidity}\n미세먼지 : ${data.length > 1 ? airSimple.split("]")[1] : ""}  기온,체감온도,습도,날씨정보와 미세먼지 정보를 연관지어 분석하고 수치적인 데이터는 언급하지말고 추상적으로 말해줘";
      // propt =
      // "너는 엄마의 역할을 해서 자식에게 날씨 정보를 알려주는 역할이야\n실제 엄마가 자식을 대하듯이 반말로 친근하게 이름을 불러주고 또한 상황에 따라 날씨와 온도 기반으로 옷차림 추천을 해줘서 대화의 맥락을 자연스럽게 해줘\n기온이나 습도,채감온도등 수치적인 데이터 언급하지 말고 추상적으로 말해주고\n전체적으로 2~3줄 이하로 특수문자 없이 텍스트로 작성해줘\n자식이름 :$name\n날씨 정보 : $parsing,\n기온:32.84, 체감온도: 39.84  습도: 73\n미세먼지: 전 권역이 '나쁨'으로 예상됩니다. \n 기온,체감온도,습도,날씨정보와 미세먼지 정보를 연관지어 분석하고 수치적인 데이터는 언급하지말고 추상적으로 말해줘";
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
  SharedPreferences.getInstance();
  print("call function");
  final latlng = await getCurrentLocationOrigin();
  print("locagion $latlng");
  final weather = await fetchGetWeatherDataWithLatLon(
      lat: latlng.split(',')[0], lon: latlng.split(',')[1]);
  final data = await getAiGenerateDataWorkManger(weather);
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
  print(getDeviceLocale());
  final permissionService = PermissionService();
  final permissionStatus = await permissionService.requestAllPermissions();

  if (permissionStatus[Permission.location]!.isGranted &&
      permissionStatus[Permission.notification]!.isGranted) {
    try {
      await NotificationService().init();
      await Workmanager().initialize(callbackDispatcher);
      if (Platform.isAndroid) {
        await AndroidAlarmManager.initialize();
      }
      // iOS를 위한 BackgroundFetch 초기화는 NotificationService().init() 내에서 처리됩니다.
    } catch (e) {
      print('Initialization failed: $e');
    }
  } else {
    print('필요한 권한이 승인되지 않았습니다.');
    // 여기서 사용자에게 권한이 필요하다는 메시지를 표시할 수 있습니다.
  }
  Gemini.init(apiKey: Env.gemApiKey);
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      // context가 없는 곳에서 context를 사용할 수 있는 방
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
  String icon=""; // 결과값 날씨 아이콘 이미지 주소
  String iconDesc=""; // 날씨 종류 (맑은 날씨인지 비가 오는지 등)
  String temp=""; // 온도
  String hu=""; // 습도
  bool loading=false; // 엄마의 마음 버튼을 눌렀는지
  String _storedTime = '';
  TimeOfDay? _selectedTime;
  final PermissionService _permissionService = PermissionService();
  @override
  void initState() {
    super.initState();
    _loadNickname();
    _loadStoredTime();
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) async {
    //     bool serviceEnabled;
    //     LocationPermission permission;
    //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //
    //     if (!serviceEnabled) {
    //       throw "permission error";
    //     }
    //
    //     permission = await Geolocator.checkPermission();
    //     if (permission == LocationPermission.denied) {
    //       permission = await Geolocator.requestPermission();
    //       if (permission != LocationPermission.whileInUse &&
    //           permission != LocationPermission.always) {
    //         throw "permission error";
    //       }
    //     }
    //     final statuses = await [
    //       Permission.scheduleExactAlarm,
    //       Permission.notification,
    //       Permission.locationWhenInUse,
    //       Permission.backgroundRefresh,
    //     ].request();
    //
    //     if (statuses[Permission.scheduleExactAlarm]!.isGranted ||
    //         statuses[Permission.locationWhenInUse]!.isGranted ||
    //         statuses[Permission.backgroundRefresh]!.isGranted ||
    //         statuses[Permission.notification]!.isGranted) {
    //       // 권한이 허용된 경우
    //       print("권한이 허용되었습니다.");
    //     } else {
    //       // 권한이 거부된 경우
    //       print("권한이 거부되었습니다.");
    //     }
    //   },
    // );
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
    String language = getDeviceLocale();
    tts.stop();
    tts.setLanguage(language.split('_')[0]);
    SharedPreferences.getInstance();
    print("call function");
    final latlng = await getCurrentLocationOrigin();
    print("locagion $latlng");
    final weather = await fetchGetWeatherDataWithLatLon(
        lat: latlng.split(',')[0], lon: latlng.split(',')[1]);
    
    final data = await getAiGenerateDataWorkManger(weather);
    setState(() {
      result = data;
      icon=weather.weather!.isNotEmpty?weather.weather![0].icon!:"";
      iconDesc=weather.weather!.isNotEmpty?weather.weather![0].main!:"";
      temp=weather.main!.temp!.toStringAsFixed(1);
      hu=weather.main!.humidity!.toString();
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
            const Spacer(),
            if (result.isNotEmpty)
              Container(
                height: 90,
                child: Bubble(
                  elevation: 1,
                  nipWidth: 10,
                  nip: BubbleNip.leftBottom,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Text(result),
                        ],
                      ),
                    ),
                  ),
                  color: Colors.yellowAccent[100]!,
                ),
              ),
            if(result.isEmpty)
              SizedBox(height: 90,),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/mom_image.png",
                  height: 300,
                ),
                if (icon.isNotEmpty && temp.isNotEmpty && hu.isNotEmpty)...[
                  Container(
                    width: 200,
                    child: Card(
                      child: Row(
                        children: [
                        Column(
                          children: [
                            if(iconDesc=="Clear")
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset("assets/images/clear.png",width: 70,height: 70,),
                              )
                            else
                              Image.network("https://openweathermap.org/img/wn/$icon@2x.png",width: 100,height: 100,),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(temp,style: TextStyle(fontSize: 25),),
                              Text("°C",style: TextStyle(fontSize: 15),)
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(hu,style: TextStyle(fontSize: 15),),
                              Text("%")
                            ],
                          )

                        ],)
                      ],),
                    ),
                  )
                ]
                else...[
                  Container(width: 200,)
                ]
              ],
            ),

            const Spacer(),
            GestureDetector(
              onTap: () {
                _generateMomMessage();
              },
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.pinkAccent[100],
                    borderRadius: BorderRadius.circular(100)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.record_voice_over,
                      size: 40,
                      color: Colors.white,
                    ),
                    const Text(
                      "엄마의 마음",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            if (timeString.isNotEmpty)
              Column(
                children: [
                  const Divider(),
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
                                        Fluttertoast.showToast(
                                            msg: '알람이 삭제되었습니다.',
                                            gravity: ToastGravity.CENTER);
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
                ],
              ),
            if (timeString.isEmpty)
              Column(
                children: [
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
                        bool locationGranted = await _permissionService.requestLocationPermission();
                        bool notificationGranted = await _permissionService.requestNotificationPermission();

                        if (locationGranted && notificationGranted) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return const TimeSettingDialog();
                            },
                          );
                          _loadStoredTime();
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('위치 및 알림 권한이 필요합니다.')),
                          );
                        }
                      },
                      child: const Text(
                        '알람 추가하기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    child: const Text(
                      "원하는 시간에 엄마의 마음을 들을수 있어요",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8,)
                ],
              ),
            // TODO : admob 자리
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.alarm),
      // ),
    );
  }
}
