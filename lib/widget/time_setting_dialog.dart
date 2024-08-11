import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/date.dart';

class TimeSettingDialog extends StatefulWidget {
  const TimeSettingDialog({Key? key}) : super(key: key);

  @override
  _TimeSettingDialogState createState() => _TimeSettingDialogState();
}

class _TimeSettingDialogState extends State<TimeSettingDialog> {
  TimeOfDay? _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _onConfirmPressed(BuildContext context) async {
    if (_selectedTime != null) {
      final prefs = await SharedPreferences.getInstance();

      // 새로운 시간 문자열 생성
      String savedTime =
          "${_selectedTime!.period == DayPeriod.am ? "오전" : "오후"} ${_selectedTime!.hourOfPeriod}시 ${_selectedTime!.minute}분";

      // 시간 저장
      await prefs.setString('lastSetTime', savedTime);
      // 몇시간후에 울린걸지 가져오기
      Duration duration = getTimeUntil(_selectedTime!);
      print(duration);

      // 알람 ID 값을 가져오거나 기본값 1로 초기화
      int alarmId = prefs.getInt('alarmId') ?? 1;

      setState(() {
        _selectedTime = null;
      });
      // 알람 ID 값을 +1 해서 저장

      await prefs.setInt('alarmId', alarmId + 1);

      try {
        if(Platform.isIOS){
          //	<string>task-identifier</string>
          // info.plit 에 등록한것만 알람 가능 현재 oneOffTask 한번만 실행하는것만 지원됨 : ios 버전문제
          const iOSBackgroundProcessingTask = "task-identifier";
          Workmanager().registerOneOffTask(
            iOSBackgroundProcessingTask,
            iOSBackgroundProcessingTask,
            initialDelay: duration,
            existingWorkPolicy: ExistingWorkPolicy.keep,
            backoffPolicy: BackoffPolicy.linear,
            backoffPolicyDelay: Duration(minutes: 15),
            constraints: Constraints(
              networkType: NetworkType.connected,
              requiresBatteryNotLow: true,
            ),
          );
        }else{

          Workmanager().registerPeriodicTask(
            alarmId.toString(),
            "push data",
            initialDelay: duration,
            frequency: Duration(days: 1),
            existingWorkPolicy: ExistingWorkPolicy.keep,
            backoffPolicy: BackoffPolicy.linear,
            backoffPolicyDelay: Duration(minutes: 15), // 실패시 15분뒤 다시 실행
            constraints: Constraints(
              networkType: NetworkType.connected, // 네트워크 연결되있어야 동작하는 옵션
              requiresBatteryNotLow: false, // 배터리가 낮더라도 실행하는 옵션 true 일시 배터리 충분할때만 실행
            ),
          );
        }
        print("success regist workmanage");
      } catch (e) {
        print(e);
      }

      _showSnackBar(context,
          '${duration.inHours}시간 ${duration.inMinutes % 60}분 후에 알림이 울립니다.');
    } else {
      _showSnackBar(context, '시간을 선택해주세요.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('시간 설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => _selectTime(context),
            child: const Text('시간 선택'),
          ),
          if (_selectedTime != null)
            Text(
              "선택된 시간: ${_selectedTime!.period == DayPeriod.am ? "오전" : "오후"} ${_selectedTime!.hourOfPeriod}시 ${_selectedTime!.minute}분",
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
            Navigator.of(context).pop(_selectedTime); // 선택된 시간을 반환하고 다이얼로그 닫기
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
