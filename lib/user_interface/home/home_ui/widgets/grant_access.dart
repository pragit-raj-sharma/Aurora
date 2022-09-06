import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


InkWell grantAccess(BuildContext context){
  return InkWell(
    onTap: (){
      context.read<HomeCubit>().requestAccess();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: const Text("Grant Access"),
    ),
  );
}