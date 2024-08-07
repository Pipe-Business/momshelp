import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:momhelp/api/api_call.dart';
import 'package:momhelp/utils/background_notification.dart';
import 'package:momhelp/utils/date.dart';
import 'package:momhelp/utils/env.dart';
import 'package:momhelp/utils/notification_service.dart';
import 'package:momhelp/widget/time_setting_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

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
  } catch (e,stacktace) {
    print(stacktace);
    throw e;
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("execute task $task / ${Workmanager.iOSBackgroundTask}");
    if(Platform.isIOS){
      try{
        print("ios Native called background task: $task");
        await fetchNetworkDataAndShowNotification();
        print("end function");
      }catch(e){
        print(e);
      }
    }
    if (task == "push data" || task== Workmanager.iOSBackgroundTask) {
      try{
        print("Native called background task: $task");
        await fetchNetworkDataAndShowNotification();
      }catch(e){
        print(e);
      }
    }

    return Future.value(true);
  });
}

Future<void> fetchNetworkDataAndShowNotification() async {

  if(Platform.isIOS){
    SharedPreferences.getInstance();
  }
  print("call function");
  // NotificationService().initNotification();
  final latlng = await getCurrentLocationOrigin();
  print("locagion $latlng");

  print(latlng);
  try {
    final weather = await fetchGetWeatherDataWithLatLon(
        lat: latlng.split(',')[0], lon: latlng.split(',')[1]);
    print(weather);
    print(getDateToday());
    print(getDateTime());
    final air = await getAirData(date: getDateToday(), time: getDateTime());
    print(air);
    final data = air.body.items
        .where((element) => element.informData == getDateToday())
        .toList();
    String name =  await _loadNickNameOrigin();
    String propt =
        "너는 엄마의 역할을 해서 자식에게 날씨 정보를 알려주는 역할이야 실제 엄마처럼 반말로 말해주고 친근하게 이름을 불러줘, 이름은 ${name} 이야 날씨는 정보 :  ${weather.weather},기온: ${weather.main?.temp}, 체감온도: ${weather.main?.feels_like},  습도: ${weather.main?.humidity}  미세먼지:  ${data.toString()},  이 데이터는 바로 TTS 에 연동시킬거기 떄문에 특수문자 없이 그냥 텍스트로 해줘";
    print(propt);
    Gemini.init(apiKey: Env.gemApiKey);
    final gemini = Gemini.instance;
    print("gemini $gemini");
    final value = await gemini.text(propt);
    print("value :$value");
    print(value?.output);
    var result = "";
    await backgroundNotification(
        title: "알림", content: value?.output ?? "Gemini api error");
    value?.content?.parts?.map((e) {
      if (e.text != null) {
        result += e.text!;
      }
    });
  } catch (e) {
    print(e);
  }
  // gemini.text(propt).then((value) {
  //   if (value?.output != null) {
  //     NotificationService().showNotification(title: "알림", body: "${value!.output}");
  //   }
  // });
  // 여기서 네트워크 요청을 수행합니다
  // 예: final response = await http.get(Uri.parse('https://api.example.com/data'));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: Env.gemApiKey);
  NotificationService().initNotification();
  await SharedPreferences.getInstance();
  Workmanager().initialize(callbackDispatcher);
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
          Permission.locationWhenInUse
        ].request();

        if (statuses[Permission.scheduleExactAlarm]!.isGranted ||
            statuses[Permission.locationWhenInUse]!.isGranted ||
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
      barrierDismissible: false,
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
    final weather =
        await fetchGetWeatherDataWithLatLon(lat: latlng[0], lon: latlng[1]);
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
        "너는 엄마의 역할을 해서 자식에게 날씨 정보를 알려주는 역할이야 실제 엄마처럼 자식을 응원하는 멘트도 쳐줘, 너의 이름은 ${name} 이고 이름으로 불러줘 날씨 정보는 ${weather.toString()} 이거고 미세먼지 지역은 이거야 여기 위치는 서울이야 ${data.toString()} 이 데이터는 바로 TTS 에 연동시킬거기 떄문에 특수문자 없이 그냥 텍스트로 해줘 그리고 엄마니까 반말로해 친근하게 ";
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
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        timeStringDialog =
            "${picked.period == DayPeriod.am ? "오전" : "오후"} ${picked.hour}시${picked.minute}분";
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
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("알림 시간", style: TextStyle(fontSize: 18)),
                            Text(timeString,
                                style: TextStyle(
                                  fontSize: 25,
                                )),
                          ],
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("삭제하시겠습니까?"),
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
                                      child: Text("네",
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
                                      child: Text(
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
                          icon: Icon(
                            Icons.delete,
                            size: 34,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider()
                ],
              ),
            if (timeString.isEmpty)
              Column(
                children: [
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Text(
                        "원하는 시간에 날씨정보를 요약해서 들어볼수 있어요",
                        textAlign: TextAlign.center,
                      )),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
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
                            return TimeSettingDialog();
                            // return Dialog(
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Column(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         Text("알람을 울릴 시간을 설정해주세요"),
                            //         Container(
                            //           child: Row(
                            //             mainAxisAlignment: MainAxisAlignment.center,
                            //             crossAxisAlignment: CrossAxisAlignment.center,
                            //             children: [
                            //               Text(timeStringDialog)
                            //             ],
                            //           ),
                            //         ),
                            //         ElevatedButton(
                            //           onPressed: () => _selectTime(context),
                            //           child: Text("시간 설정하기"),
                            //         ),
                            //         ElevatedButton(
                            //           onPressed: () =>
                            //               _onConfirmPressed(context, channel),
                            //           child: Text("확인"),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // );
                          },
                        );
                        _loadStoredTime();
                        setState(() {});
                      },
                      child: Text(
                        '알람 추가하기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            Spacer(),
            Image.asset(
              "assets/images/mom_image.png",
              height: 300,
            ),
            Spacer(),
            // TODO : admob 자리
            Container(
              height: 50,
            ),

            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            //   child: Text(
            //     result,
            //     style: TextStyle(fontSize: 14),
            //   ),
            // ),
            //
            // Container(
            //   width: double.infinity,
            //   height: 48,
            //   margin: EdgeInsets.symmetric(horizontal: 20),
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10)
            //       ),
            //       backgroundColor: Colors.black,
            //     ),
            //       onPressed: () {
            //         _incrementCounter();
            //       },
            //       child: Text("엄마의 말 들어보기", style: TextStyle(color: Colors.white, fontSize: 20),)),
            // ),
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
