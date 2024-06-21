import 'package:asky/api/requests_assistance_api.dart';
import 'package:flutter/material.dart';
import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/api/request_material_api.dart';

class StatusProgressBar extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;
  final Color activeColor;
  final Color inactiveColor;
  final String status;
  final bool editable;
 final Map<String, String> dropdownOptions;
  final int requestId;
  final String type;

  StatusProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
    required this.activeColor,
    required this.inactiveColor,
    required this.status,
    required this.requestId,
    required this.type,
    this.editable = false,
    this.dropdownOptions = const {},
    
  }) : super(key: key);

  @override
  _StatusProgressBarState createState() => _StatusProgressBarState();
}

class _StatusProgressBarState extends State<StatusProgressBar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late String _selectedOption;
  var requestAssistanceApi = RequestsAssistance();
  var requestMedicineApi = RequestMedicineApi();
  var requestMaterialApi = RequestMaterialApi();

  
  @override
  void initState() {
    super.initState();
    _selectedOption = widget.status;
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,  // Now this line should work because 'this' is a TickerProvider
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 8.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

      print(widget.dropdownOptions.entries.toList());
  print(widget.dropdownOptions);

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleDropdownChange(String newValue) async {
    setState(() {
      _selectedOption = newValue;
    });
    // Call your API function here
    if (widget.type == 'assistance') {
      await requestAssistanceApi.updateRequestStatus(widget.requestId, _selectedOption);
    } else if (widget.type == 'material') {
      await requestMaterialApi.updateRequestStatus(widget.requestId, _selectedOption);
      
    } else {
      await requestMedicineApi.updateRequestStatus(widget.requestId, _selectedOption);
      // Call the API function for medicine requests
    }
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
              widget.editable
                  ? DropdownButton<String>(
                      value: _selectedOption,
                      items: widget.dropdownOptions.entries
      .map((entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          ))
      .toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          _handleDropdownChange(newValue);
                        }
                      },
                    )
                  : Text(
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
