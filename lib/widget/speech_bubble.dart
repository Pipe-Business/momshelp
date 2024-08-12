// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class SpeechBubble extends StatelessWidget {
//   final String result;
//
//   const SpeechBubble({Key? key, required this.result}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//       child: CustomPaint(
//         painter: SpeechBubblePainter(),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           width: double.infinity,
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.grey,width: 1),
//             color: Colors.yellowAccent[100]
//           ),
//           height: 150,
//           child: SingleChildScrollView(
//             child: Text(
//               result,
//               style: const TextStyle(fontSize: 14, color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class SpeechBubblePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double arrowHeight = 10;
//     final double arrowWidth = 20;
//     final double arrowPosition = size.width - 40; // 꼭지 위치 조정
//
//     final Paint paint = Paint()
//       ..color = Colors.yellowAccent[100]!
//       ..style = PaintingStyle.fill;
//
//     final Paint borderPaint = Paint()
//       ..color = Colors.grey
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//
//     final Path path = Path()
//       ..moveTo(10, 0)
//       ..lineTo(size.width - 10, 0)
//       ..lineTo(size.width - 10, size.height - arrowHeight)
//       ..lineTo(arrowPosition + arrowWidth / 2, size.height - arrowHeight)
//       ..lineTo(arrowPosition, size.height)
//       ..lineTo(arrowPosition - arrowWidth / 2, size.height - arrowHeight)
//       ..lineTo(10, size.height - arrowHeight)
//       ..close();
//
//     canvas.drawPath(path, paint);
//     canvas.drawPath(path, borderPaint);
//   }
//
//   @override
//   bool shouldRepaint(SpeechBubblePainter oldDelegate) => false;
// }
// class SpeechBubbleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     final double arrowHeight = 10;
//     final double arrowWidth = 20;
//     final double arrowPosition = size.width * 0.5;
//
//     // 말풍선 본체
//     path.moveTo(0, 0);
//     path.lineTo(size.width, 0);
//     path.lineTo(size.width, size.height - arrowHeight);
//     path.lineTo(arrowPosition + arrowWidth / 2, size.height - arrowHeight);
//
//     // 하단의 뾰족한 부분
//     path.lineTo(arrowPosition, size.height);
//     path.lineTo(arrowPosition - arrowWidth / 2, size.height - arrowHeight);
//
//     // 말풍선 본체 이어서
//     path.lineTo(0, size.height - arrowHeight);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(SpeechBubbleClipper oldClipper) => false;
// }