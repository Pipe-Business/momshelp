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
