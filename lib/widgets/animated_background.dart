import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
final Widget child;
const AnimatedBackground({super.key, required this.child});

@override
State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
with SingleTickerProviderStateMixin {
late AnimationController _controller;

@override
void initState() {
super.initState();
_controller = AnimationController(
vsync: this,
duration: const Duration(seconds: 12),
)..repeat();
}

@override
void dispose() {
_controller.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Stack(
children: [
Positioned.fill(
child: Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
colors: [Color(0xFF0A0A0A), Color(0xFF141414)],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
),
),
),
AnimatedBuilder(
animation: _controller,
builder: (_, __) {
return Positioned.fill(
child: CustomPaint(
painter: _GlowPainter(_controller.value),
),
);
},
),
widget.child,
],
);
}
}

class _GlowPainter extends CustomPainter {
final double t;
_GlowPainter(this.t);

@override
void paint(Canvas canvas, Size size) {
final paint = Paint()
..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);

final p1 = Offset(
size.width * (0.2 + 0.1 * (1 - (t * 2 - 1).abs())),
size.height * 0.15,
);
paint.color = AppColors.goldPrimary.withOpacity(0.15);
canvas.drawCircle(p1, 180, paint);

final p2 = Offset(
size.width * 0.85,
size.height * (0.4 + 0.15 * (t * 2 - 1).abs()),
);
paint.color = AppColors.silverMid.withOpacity(0.08);
canvas.drawCircle(p2, 220, paint);

final p3 = Offset(
size.width * (0.5 + 0.2 * ((t + 0.5) % 1 - 0.5)),
size.height * 0.9,
);
paint.color = AppColors.goldDark.withOpacity(0.12);
canvas.drawCircle(p3, 200, paint);
}

@override
bool shouldRepaint(covariant _GlowPainter old) => old.t != t;
}