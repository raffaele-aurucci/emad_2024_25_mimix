import 'package:flutter/material.dart';
import 'package:mimix_app/utils/view/app_palette.dart';
import 'package:mimix_app/utils/view/widgets/texts/card_title_text.dart';

class ProfileImageWithLevel extends StatelessWidget {
  final String? profileImageUrl; // url or path image
  final int experienceLevel; // experience level
  final double experienceProgress; // experience progress

  const ProfileImageWithLevel({
    Key? key,
    this.profileImageUrl,
    required this.experienceLevel,
    required this.experienceProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PaletteColor.powderBlue,
        borderRadius: BorderRadius.circular(40.0),
      ),
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Adapt the witdh at the content
        children: [
          // Profile image
          CircleAvatar(
            radius: 20.0,
            backgroundImage: profileImageUrl != null // Static image if image doesn't exist
                ? NetworkImage(profileImageUrl!)
                : null,
            backgroundColor: Colors.grey[200],
            child: profileImageUrl == null
                ? const Icon(
              Icons.person, // Default icon
              size: 30.0,
              color: Colors.grey,
            )
                : null,
          ),

          const SizedBox(width: 8.0),

          // Circular bar progress
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(40, 40),
                painter: _RoundedCircularProgressPainter(
                  progress: experienceProgress,
                  progressColor: PaletteColor.darkBlue,
                  strokeWidth: 3.5,
                ),
              ),

              CardTitleText(text: experienceLevel.toString(), size: CardTitleText.H5)
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundedCircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final double strokeWidth;

  _RoundedCircularProgressPainter({
    required this.progress,
    required this.progressColor,
    this.strokeWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = PaletteColor.progressBarBackground
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final sweepAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
