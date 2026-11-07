import 'package:flutter/material.dart';

/// Mini Map Visual Preview Widget
class MiniMapWidget extends StatelessWidget {
  const MiniMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFBAE6FD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: const CustomPaint(painter: MiniMapPainter()),
      ),
    );
  }
}

class MiniMapPainter extends CustomPainter {
  const MiniMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Daratan
    final landPaint = Paint()..color = const Color(0xFFE2E8F0);
    final landPath = Path()
      ..moveTo(size.width * 0.22, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.12, size.height)
      ..quadraticBezierTo(
        size.width * 0.32,
        size.height * 0.5,
        size.width * 0.22,
        0,
      )
      ..close();
    canvas.drawPath(landPath, landPaint);

    // Area hijau / taman
    final parkPaint = Paint()..color = const Color(0xFFDCFCE7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.38,
          size.height * 0.18,
          size.width * 0.45,
          size.height * 0.32,
        ),
        const Radius.circular(3),
      ),
      parkPaint,
    );

    // 2. Jalur Jalan Raya
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.28),
      Offset(size.width, size.height * 0.78),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.62, 0),
      Offset(size.width * 0.45, size.height),
      roadPaint,
    );

    // 3. Pin Lokasi Merah di titik kampus
    final pinPaint = Paint()..color = const Color(0xFFEF4444);
    final center = Offset(size.width * 0.52, size.height * 0.46);
    canvas.drawCircle(center, 4.2, pinPaint);
    canvas.drawCircle(center, 1.8, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
