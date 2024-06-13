import 'package:flutter/material.dart';

class StatusProgressBar extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;
  final Color activeColor;
  final Color inactiveColor;
  final String status;

  StatusProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
    required this.activeColor,
    required this.inactiveColor,
    required this.status,
  }) : super(key: key);

  @override
  _StatusProgressBarState createState() => _StatusProgressBarState();
}

class _StatusProgressBarState extends State<StatusProgressBar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,  // Now this line should work because 'this' is a TickerProvider
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 8.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              widget.totalSteps,
              (index) => Expanded(
                    child: Container(
                      height: 10,
                      margin: EdgeInsets.only(
                          left: index > 0 ? 2 : 0,
                          right: index < widget.totalSteps - 1 ? 2 : 0),
                      decoration: BoxDecoration(
                        color: index <= widget.currentStep
                            ? widget.activeColor
                            : widget.inactiveColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: _animation.value,
                height: _animation.value,
                decoration: BoxDecoration(
                  color: widget.currentStep >= 0 ? widget.activeColor : widget.inactiveColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.status,
                style: TextStyle(
                  color: widget.currentStep >= 0 ? widget.activeColor : widget.inactiveColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
