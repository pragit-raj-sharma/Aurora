import 'package:flutter/cupertino.dart';

abstract class SetupWizardState{}

class SetupWizardInitState extends SetupWizardState{
  SetupWizardInitState();
}

class SetupWizardConnectedState extends SetupWizardState{
  SetupWizardConnectedState();
}

class SetupWizardUpdateAvailableState extends SetupWizardState{
  SetupWizardUpdateAvailableState();
}

class SetupWizardCompatibleState extends SetupWizardState{
  SetupWizardCompatibleState();
}

class SetupWizardLoadingState extends SetupWizardState{
  SetupWizardLoadingState();
}

class SetupWizardIncompatibleState extends SetupWizardState{
  final int stepValue;
  final Widget? child;
  final bool isValid;

  SetupWizardIncompatibleState({
    this.stepValue=0,
    this.child,
    this.isValid=false
  });

  SetupWizardIncompatibleState copyState({
    int? stepValue,
    Widget? child,
    bool? isValid,
  }){
    return SetupWizardIncompatibleState(
      stepValue: stepValue??this.stepValue,
      isValid: isValid??this.isValid,
      child: child??this.child
    );
  }

}
