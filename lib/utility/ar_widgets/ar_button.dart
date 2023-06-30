import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ArButton extends StatefulWidget {
  const ArButton({
    super.key,
    required this.title,
    required this.action,
    this.isSelected = false,
    this.isEnabled = true,
    this.isLoading = false,
    this.animate = true,
    this.edgeInsets
  });

  final String title;
  final Function action;
  final bool isSelected;
  final bool isEnabled;
  final bool isLoading;
  final bool animate;
  final EdgeInsetsGeometry? edgeInsets;

  @override
  State<ArButton> createState() {
    return _ArButtonState();
  }
}

class _ArButtonState extends State<ArButton> {
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
  }

  _setBounds(){
    height = widget.isSelected ? 7.h : 6.h;
    width = widget.isSelected ? 11.w : 10.w;
  }

  @override
  Widget build(BuildContext context) {
    _setBounds();
    return Container(
      margin: widget.edgeInsets,
      padding: EdgeInsets.symmetric(vertical: 1.5.h,horizontal: .5.w),
      child: widget.isLoading && widget.isSelected
          ? SizedBox(
              height: height,
              width: width,
              child: LinearProgressIndicator(
                color: context.read<KeyboardSettingsBloc>().selectedColor,
              ))
          : InkWell(
              onTap: () async {
                if (widget.isEnabled) {
                  await widget.action();
                }
              },
              child: animationHandler(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: widget.isEnabled
                        ? widget.isSelected
                        ? context.selectedColor
                        : ArColors.greyDisabled!
                        : ArColors.grey,),
                    color: widget.isEnabled
                        ? widget.isSelected
                        ? context.selectedColorWithAlpha
                        : null
                        : ArColors.grey,
                  ),
                  child: Center(
                      child:
                       Text(
                         widget.title,
                         textAlign: TextAlign.center,
                       )),
                ),
              ),
            ),
    );
  }

  Widget animationHandler({required Widget child}){
    return widget.animate?
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: width,
          height: height,
          child: child,
        ):
        FittedBox(child: child,);

  }
}

class ButtonAttribute<T> {
  String title;
  T? value;

  ButtonAttribute({required this.title, this.value});
}
