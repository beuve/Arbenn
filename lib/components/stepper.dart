import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/overlay.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/components/buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Step {
  /// Creates a step for a [Stepper].
  const Step({
    this.subtitle,
    required this.content,
    this.state = StepState.indexed,
    this.isActive = false,
    this.label,
  });

  final Widget? subtitle;
  final Widget content;
  final StepState state;
  final bool isActive;
  final Widget? label;
}

class FormStepper extends StatefulWidget {
  final List<Step> steps;
  final String title;
  final String subtitle;
  final VoidCallback? onCancel;
  final Future<bool> Function() onFinish;
  final List<bool>? resizeOnKeyboard;
  final ValueChanged<int>? onStepTapped;
  final ValueChanged<int>? onNext;
  final ValueChanged<int>? onBack;
  final Function(BuildContext)? close;
  final double headerHeight;

  const FormStepper({
    super.key,
    required this.steps,
    required this.title,
    required this.subtitle,
    this.onStepTapped,
    this.onNext,
    this.onBack,
    this.onCancel,
    this.close,
    this.headerHeight = 120,
    required this.onFinish,
    this.resizeOnKeyboard,
  });

  @override
  State<FormStepper> createState() => _FormStepperState();
}

class _FormStepperState extends State<FormStepper> {
  int _step = 0;

  @override
  void initState() {
    super.initState();
  }

  bool isFirst() {
    if (_step == 0) {
      return true;
    }
    return false;
  }

  bool isLast() {
    if (_step == widget.steps.length - 1) {
      return true;
    }
    return false;
  }

  void next() {
    if (_step < widget.steps.length - 1) {
      widget.onNext?.call(_step);
      setState(() => _step = _step + 1);
    }
  }

  void back() {
    if (_step > 0) {
      widget.onBack?.call(_step);
      setState(() => _step = _step - 1);
    }
  }

  void stepTapped(int newStep) {
    if (widget.steps[newStep].state != StepState.disabled) {
      widget.onStepTapped?.call(_step);
      setState(() => _step = newStep);
    }
  }

  Widget _buildControls(int stepIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        // The Material spec no longer includes a Stepper widget. The continue
        // and cancel button styles have been configured to match the original
        // version of this widget.
        children: <Widget>[
          Expanded(
            flex: 2,
            child: isFirst()
                ? Container()
                : Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: back,
                      icon: const Icon(AkarIcons.arrow_left),
                    ),
                  ),
          ),
          Expanded(flex: 1, child: Container()),
          ...isLast()
              ? [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: FutureButton(
                        onPressed: widget.onFinish,
                        onEnd: widget.close == null
                            ? null
                            : () => widget.close!(context),
                        label: AppLocalizations.of(context)!.validate,
                      ),
                    ),
                  )
                ]
              : [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: next,
                        icon: const Icon(AkarIcons.arrow_right),
                      ),
                    ),
                  )
                ]
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            height: 4,
            width: width - 40,
            decoration: BoxDecoration(
              color: Colors.blue[200]!,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Container(
            height: 4,
            width: (_step + 1) * (width - 40) / widget.steps.length,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final List<Widget> stepPanels = <Widget>[];
    for (int i = 0; i < widget.steps.length; i += 1) {
      stepPanels.add(
        Visibility(
          maintainState: true,
          visible: i == _step,
          child: widget.steps[i].content,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.subtitle,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildProgressBar(),
        Expanded(
          child: widget.steps[_step].content,
        ),
        _buildControls(_step),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (context.findAncestorWidgetOfExactType<Stepper>() != null) {
        throw FlutterError(
          'Steppers must not be nested.\n'
          'The material specification advises that one should avoid embedding '
          'steppers within steppers. '
          'https://material.io/archive/guidelines/components/steppers.html#steppers-usage',
        );
      }
      return true;
    }());
    return FullPageOverlay(title: widget.title, body: _buildBody());
  }
}
