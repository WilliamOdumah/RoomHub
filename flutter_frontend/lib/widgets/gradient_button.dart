import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/our_theme.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final void Function()? onTap;

  const GradientButton({super.key, required this.text, required this.onTap});

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(_controller);
  }
   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = OurTheme();
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call(); // Call the onTap function
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 55,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient:LinearGradient(colors: [
             theme.mintgreen, theme.darkblue, 
            ]),
          ),
          child: Center(
            child: Text( widget.text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            ),
          ),
        ),
    ));
  }
}

