import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

class CustomSwitchButton extends StatefulWidget {
  final bool value;
  final double? width, height;
  final Function(bool) onChanged;
  final bool initialValue;
  final bool enable;
  final bool isLoading;

  const CustomSwitchButton({
    super.key,
    required this.value,
    this.width,
    this.height,
    this.initialValue = false,
    required this.onChanged,
    this.enable = true,
    this.isLoading = false,
  });

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<bool>.dual(
      current: widget.value,
      first: false,
      second: true,
      height: widget.height ?? 24,
      spacing: 2,
      indicatorSize: const Size(20, 20),
      onChanged: widget.onChanged,
      animationCurve: Curves.linear,
      animationDuration: Duration(milliseconds: 300),
      textMargin: EdgeInsets.only(right: 1),
      style: ToggleStyle(
        indicatorColor: Colors.white,
        backgroundColor: _getBackgroundColor(),
        borderColor: Colors.transparent,
      ),
      indicatorTransition: ForegroundIndicatorTransition.rolling(),
      active: widget.enable,
      loading: widget.isLoading,
      loadingIconBuilder:
          (context, global) =>
              CircularProgressIndicator(color: AppColor.primary),
    );
  }

  Color _getBackgroundColor() {
    return widget.isLoading
        ? Colors.transparent
        : widget.value
        ? AppColor.primary
        : Color.fromARGB(255, 213, 215, 218);
  }
}
