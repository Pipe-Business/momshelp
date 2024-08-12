import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:momhelp/widget/time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/date.dart';
import '../utils/notification_service.dart';

class TimeSettingDialog extends StatefulWidget {
  const TimeSettingDialog({Key? key}) : super(key: key);

  @override
  _TimeSettingDialogState createState() => _TimeSettingDialogState();
}

class _TimeSettingDialogState extends State<TimeSettingDialog> {
  DateTime? previewTime;

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //
  //     helpText: "알림을 받고싶은 시간을 선택해주세요",
  //     initialEntryMode: TimePickerEntryMode.dialOnly,
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (picked != null && picked != _selectedTime) {
  //     setState(() {
  //       _selectedTime = picked;
  //     });
  //   }
  // }
  String convertDateTimeToTime(DateTime now) {
    // 오전/오후 구분
    String period = now.hour < 12 ? "오전" : "오후";

    // 12시간 형식으로 시각 표시
    int hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    int minute = now.minute;
    String formattedMinute = minute.toString().padLeft(2, '0');
    return "$period $hour:$formattedMinute";
  }

  Future<void> _onConfirmPressed(BuildContext context) async {
    previewTime ??= DateTime.now();
    final prefs = await SharedPreferences.getInstance();

    // 새로운 시간 문자열 생성
    String savedTime = convertDateTimeToTime(previewTime!);

    // 시간 저장
    await prefs.setString('lastSetTime', savedTime);
    // 몇시간후에 울린걸지 가져오기
    Duration duration = getTimeUntil2(previewTime!);
    print(duration);

    // 알람 ID 값을 가져오거나 기본값 1로 초기화
    int alarmId = prefs.getInt('alarmId') ?? 1;

    // 알람 ID 값을 +1 해서 저장

    await prefs.setInt('alarmId', alarmId + 1);

    // try {
    //   if (Platform.isIOS) {
    //     //	<string>task-identifier</string>
    //     // info.plit 에 등록한것만 알람 가능 현재 oneOffTask 한번만 실행하는것만 지원됨 : ios 버전문제
    //     const iOSBackgroundProcessingTask = "task-identifier";
    //     Workmanager().registerOneOffTask(
    //       iOSBackgroundProcessingTask,
    //       iOSBackgroundProcessingTask,
    //       initialDelay: duration,
    //       existingWorkPolicy: ExistingWorkPolicy.keep,
    //       backoffPolicy: BackoffPolicy.linear,
    //       backoffPolicyDelay: Duration(minutes: 15),
    //       constraints: Constraints(
    //         networkType: NetworkType.connected,
    //         requiresBatteryNotLow: true,
    //       ),
    //     );
    //   } else {
    //     Workmanager().registerPeriodicTask(
    //       alarmId.toString(),
    //       "push data",
    //       initialDelay: duration,
    //       frequency: Duration(days: 1),
    //       constraints: Constraints(
    //         networkType: NetworkType.connected, // 네트워크 연결되있어야 동작하는 옵션
    //       ),
    //     ); //   } //   print("success regist workmanage");
    // } catch (e) {
    //   print(e);
    // }
    print(previewTime);

    bool scheduled = await NotificationService().scheduleDaily(TimeOfDay(hour: previewTime!.hour, minute: previewTime!.minute));
    if(scheduled){
      Fluttertoast.showToast(
          msg: '${duration.inHours}시간 ${duration.inMinutes % 60}분 후에 알림이 울립니다.',
          gravity: ToastGravity.CENTER);
      print("알림 예약 성공");
    }else{
      Fluttertoast.showToast(
          msg: '알림 저장에 실패했습니다.',
          gravity: ToastGravity.CENTER);
      print("알림 예약 실패");
    }
    setState(() {
      previewTime = null;
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild :$previewTime");
    return AlertDialog(
      title: const Text(
        '시간 설정',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("설정한 시간에 매일 알람이 울립니다."),
          SizedBox(
            height: 10,
          ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TimePickerSpinner(
              key: ValueKey(previewTime),
              time: previewTime,
              is24HourMode: false,
              spacing: 40,
              highlightedTextStyle: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),
              normalTextStyle: TextStyle(fontSize: 30,color: Colors.grey),
              itemHeight: 70,
              isForce2Digits: true,
              onTimeChange: (time) {
                setState(() {
                  previewTime = time;
                });
              },
            )
          ],
        ),
          Divider(),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    previewTime = DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day, 0, 0);
                  });
                },
                child: const Text('오전 12시'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    previewTime = DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day, 7, 0);
                  });
                },
                child: const Text('오전 7시'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    previewTime = DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day, 16, 0);
                  });
                },
                child: const Text('오후 4시'),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 취소 버튼 누르면 다이얼로그 닫기
          },
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            _onConfirmPressed(context);
            Navigator.of(context).pop(previewTime); // 선택된 시간을 반환하고 다이얼로그 닫기
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
