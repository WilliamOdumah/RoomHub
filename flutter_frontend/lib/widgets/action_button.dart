import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  final Color color;

  const ActionButton(
      {super.key,
      required this.text,
      this.onTap,
      required this.color});

  @override
  ActionButtonState createState() => ActionButtonState();
}

class ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
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
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(40.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30) +
              const EdgeInsets.only(
                  top: 13,
                  bottom: 13), // Adjust horizontal and vertical padding
          child: Text(
                widget.text,
                style: const TextStyle(color: Colors.white),
              )
        ),
      ),
    );
  }
}
