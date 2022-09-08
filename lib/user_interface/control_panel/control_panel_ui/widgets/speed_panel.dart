import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/utility/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget speedController({
  required BuildContext context,
  bool isVisible=true}) {

  List<ButtonAttribute<int>> a=[
      ButtonAttribute(title: "Slow",value: 0),
      ButtonAttribute(title: "Medium",value: 1),
      ButtonAttribute(title: "Fast",value: 2),
  ];

 return AnimatedContainer(
   duration: const Duration(milliseconds: 300),
   height: isVisible?75:0,
   child: Row(
      children: a.map((e) =>
          button(
              title: e.title,
              isSelected: context.watch<ControlPanelCubit>().speed==e.value,
              context: context,
              action: () {
        context.read<HomeCubit>().setSpeed(e.value).then((value) {
          if(value) {
            context.read<ControlPanelCubit>().setSpeed(e.value);
          }
        });
      } )).toList()
    ),
 );


}
