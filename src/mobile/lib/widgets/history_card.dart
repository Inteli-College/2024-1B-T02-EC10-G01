import 'package:asky/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatefulWidget {
  final String date;
  final String title;
  final String subtitle;
  final String tag;
  final String status;
  final Color statusColor;
  final String id;
  final String requestType;

  HistoryCard(
      {Key? key,
      required this.date,
      required this.title,
      required this.subtitle,
      required this.tag,
      required this.status,
      required this.statusColor,
      required this.id,
      required this.requestType})
      : super(key: key);

  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation =
        Tween<double>(begin: 8.0, end: 10.0).animate(_animationController)
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
    return InkWell(
      onTap: () {
        // Navigate to the desired page
        Navigator.pushNamed(context,
            '/nurse_request', // This is the route name for RequestDetailsScreen
            arguments: {
              'requestId': widget.id,
              'type': widget.requestType
            } // Passing id as an argument
            );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Color.fromRGBO(26, 54, 93, 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          DateFormat('dd/MM')
                              .format(DateTime.parse(widget.date)),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700])),
                      const SizedBox(height: 8.0),
                      Text(widget.title,
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Text(widget.subtitle,
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[600])),
                      const SizedBox(height: 8.0),
                      Text(widget.tag.toUpperCase(),
                          style: TextStyle(
                              fontSize: 14.0,
                              color: widget.tag == 'NORMAL'
                                  ? Constants.askyBlue
                                  : Colors.red,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: _animation.value,
                          height: _animation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.statusColor,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Text(widget.status,
                            style: TextStyle(
                                color: widget.statusColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
