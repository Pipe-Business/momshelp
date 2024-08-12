import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getDateToday() {
  // 현재 날짜와 시간을 가져옵니다
  DateTime now = DateTime.now();

  // 날짜를 'yyyy-MM-dd' 형식으로 포맷합니다
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);

  // 시간 정보를 가져오고 'PM06' 형식으로 변환합니다
  return formattedDate;
}
String getDateTime(){
  DateTime now = DateTime.now();
  String formattedTime = DateFormat('a').format(now) == 'PM'
      ? 'PM${now.hour.toString().padLeft(2, '0')}'
      : 'AM${now.hour.toString().padLeft(2, '0')}';
  return formattedTime;
}
Duration getTimeUntil2(DateTime time) {
  // 현재 시간을 DateTime으로 가져오기
  final now = DateTime.now();
  final currentDateTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

  // 지정된 TimeOfDay를 오늘의 DateTime으로 변환
  final timeDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

  // 현재 시간과 지정된 시간의 차이 계산
  Duration difference = timeDateTime.difference(currentDateTime);

  if (difference.isNegative) {
    // 지정된 시간이 이미 지나간 경우: 다음 날의 해당 시간으로 설정
    final tomorrowTimeDateTime = timeDateTime.add(Duration(days: 1));
    difference = tomorrowTimeDateTime.difference(currentDateTime);
  }

  return difference;
}
Duration getTimeUntil(TimeOfDay time) {
  // 현재 시간을 DateTime으로 가져오기
  final now = DateTime.now();
  final currentDateTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

  // 지정된 TimeOfDay를 오늘의 DateTime으로 변환
  final timeDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

  // 현재 시간과 지정된 시간의 차이 계산
  Duration difference = timeDateTime.difference(currentDateTime);

  if (difference.isNegative) {
    // 지정된 시간이 이미 지나간 경우: 다음 날의 해당 시간으로 설정
    final tomorrowTimeDateTime = timeDateTime.add(Duration(days: 1));
    difference = tomorrowTimeDateTime.difference(currentDateTime);
  }

  return difference;
}