
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_event.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


Widget speedController({
  required BuildContext context,
  required String title,
  bool isVisible=true}) {

  List<ButtonAttribute<int>> speedList=[
      ButtonAttribute(title: "Slow",value: 0),
      ButtonAttribute(title: "Medium",value: 1),
      ButtonAttribute(title: "Fast",value: 2),
  ];

 return AnimatedContainer(
   duration: const Duration(milliseconds: 300),
   height: isVisible?13.h:0,
   child: SingleChildScrollView(
     child: BlocBuilder<KeyboardSettingsBloc,KeyboardSettingsState>(
       builder: (BuildContext context, state) {
           return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(title,style: Theme.of(context).textTheme.headlineSmall,),
             Row(
                 children: speedList.map((e) =>
                     ArButton(
                         title: e.title,
                         isSelected: state.speed==e.value,
                         action: () {
                           context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventSetSpeed(speed: e.value??0));
                         } )).toList()
             ),
           ],
         );
       }
     ),
   ),
 );


}
