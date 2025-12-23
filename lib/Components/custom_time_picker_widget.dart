import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/constants.dart';

class CustomTimePicker extends StatefulWidget {
  String selectedTime = "09:00 AM";
  String label;
  CustomTimePicker({
    super.key,
    required this.selectedTime,
    required this.label,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  @override
  void initState() {
    super.initState();
    final parts = widget.selectedTime.split(RegExp(r"[: ]"));
    final currentHour = int.parse(parts[0]) - 1; // Convert 1-based to 0-based
    final currentMinute = int.parse(parts[1]);
    final currentPeriod = parts[2] == "AM" ? 0 : 1;

    _hourController = FixedExtentScrollController(initialItem: currentHour);
    _minuteController = FixedExtentScrollController(initialItem: currentMinute);
    _periodController = FixedExtentScrollController(initialItem: currentPeriod);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            widget.label,
            style: GoogleFonts.outfit(fontSize: 13, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () {
              if (_overlayEntry == null) {
                _showOverlay();
              } else {
                _removeOverlay();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.selectedTime,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: Constants.onboardingTextFont,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _overlayEntry != null
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 150,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 80),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 150,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildDropdownContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownContent() {
    return Row(
      children: [
        Expanded(
          child: ListWheelScrollView.useDelegate(
            controller: _hourController,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              _onTimeChanged(index + 1, null, null);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 12,
              builder: (context, index) => Center(
                child: Text(
                  "${index + 1}".padLeft(2, '0'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        const Text(":", style: TextStyle(fontSize: 16)),
        Expanded(
          child: ListWheelScrollView.useDelegate(
            controller: _minuteController,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              _onTimeChanged(null, index, null);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 60,
              builder: (context, index) => Center(
                child: Text(
                  "$index".padLeft(2, '0'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListWheelScrollView.useDelegate(
            controller: _periodController,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              _onTimeChanged(null, null, index == 0 ? "AM" : "PM");
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 2,
              builder: (context, index) => Center(
                child: Text(
                  index == 0 ? "AM" : "PM",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onTimeChanged(int? hour, int? minute, String? period) {
    final parts = widget.selectedTime.split(RegExp(r"[: ]"));
    int currentHour = int.parse(parts[0]);
    int currentMinute = int.parse(parts[1]);
    String currentPeriod = parts[2];

    if (hour != null) currentHour = hour;
    if (minute != null) currentMinute = minute;
    if (period != null) currentPeriod = period;

    setState(() {
      widget.selectedTime =
          "${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')} $currentPeriod";
      _hourController.jumpToItem(currentHour - 1);
      _minuteController.jumpToItem(currentMinute);
      _periodController.jumpToItem(currentPeriod == "AM" ? 0 : 1);
    });
  }
}
