import 'package:flutter/material.dart';

class SkyAnimation extends StatefulWidget {
  const SkyAnimation({super.key});

  @override
  State<SkyAnimation> createState() => _SkyAnimationState();
}

class _SkyAnimationState extends State<SkyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 90),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: -1, end: 1).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/minecraft_sky_BGHeader.jpg"),
                fit: BoxFit.cover,
                alignment: Alignment(animation.value, 0),
              ),
            ),
          );
        },
      ),
    );
  }
}