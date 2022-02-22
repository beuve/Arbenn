import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart' hide IconButton, BackButton;
import '../utils/colors.dart';
import 'buttons.dart';

/// Modified with Arbenn design.
///
/// A material stepper widget that displays progress through a sequence of
/// steps. Steppers are particularly useful in the case of forms where one step
/// requires the completion of another one, or where multiple steps need to be
/// completed in order to submit the whole form.
///
/// The widget is a flexible wrapper. A parent class should pass [currentStep]
/// to this widget based on some logic triggered by the three callbacks that it
/// provides.
///
/// {@tool dartpad}
/// An example the shows how to use the [Stepper], and the [Stepper] UI
/// appearance.
///
/// ** See code in examples/api/lib/material/stepper/stepper.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [Step]
///  * <https://material.io/archive/guidelines/components/steppers.html>
class FormStepper extends StatefulWidget {
  /// Creates a stepper from a list of steps.
  ///
  /// This widget is not meant to be rebuilt with a different list of steps
  /// unless a key is provided in order to distinguish the old stepper from the
  /// new one.
  ///
  /// The [steps] and [color] arguments must not be null.
  const FormStepper({
    Key? key,
    required this.steps,
    required this.color,
    this.onStepTapped,
    this.onNext,
    this.onBack,
    this.onCancel,
    this.onFinish,
    this.resizeOnKeyboard,
  }) : super(key: key);

  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// The length of [steps] must not change.
  final List<Step> steps;

  /// Nuance of colors to be used in the stepper header.
  final Nuance color;

  /// Function called when the user cancel the stepper (cancel button is located
  /// on top left of the page).
  ///
  /// It is only used for custom behiviors. A value is not needed for the
  /// stepper to work.
  final VoidCallback? onCancel;

  /// Function called when the user finishes the stepper.
  ///
  /// It is only used for custom behiviors. A value is not needed for the
  /// stepper to work.
  final VoidCallback? onFinish;

  /// If true the [body] and the scaffold's floating widgets should size
  /// themselves to avoid the onscreen keyboard whose height is defined by the
  /// ambient [MediaQuery]'s [MediaQueryData.viewInsets] bottom property.
  ///
  /// For example, if there is an onscreen keyboard displayed above the scaffold,
  /// the body can be resized to avoid overlapping the keyboard, which prevents
  /// widgets inside the body from being obscured by the keyboard.
  ///
  /// A value is needed for every step (hence the value can vary from one step
  /// to another).
  ///
  /// Defaults to null which means true for all.
  final List<bool>? resizeOnKeyboard;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final ValueChanged<int>? onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final ValueChanged<int>? onNext;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final ValueChanged<int>? onBack;

  @override
  State<FormStepper> createState() => _FormStepperState();
}

class _FormStepperState extends State<FormStepper> {
  int _step = 0;
  late bool _resize;
  late int _maxSteps;

  @override
  void initState() {
    super.initState();
    _maxSteps = widget.steps.length;
    _resize = widget.resizeOnKeyboard == null
        ? true
        : widget.resizeOnKeyboard![_step];
  }

  bool isFirst() {
    if (_step == 0) {
      return true;
    }
    return false;
  }

  bool isLast() {
    if (_step == _maxSteps - 1) {
      return true;
    }
    return false;
  }

  void next() {
    if (_step < _maxSteps - 1) {
      widget.onNext?.call(_step);
      setState(() => {_step = _step + 1});
      _resizeStep();
    }
  }

  void back() {
    if (_step > 0) {
      widget.onBack?.call(_step);
      setState(() => {_step = _step - 1});
      _resizeStep();
    }
  }

  void stepTapped(int newStep) {
    if (widget.steps[newStep].state != StepState.disabled) {
      widget.onStepTapped?.call(_step);
      setState(() => {_step = newStep});
      _resizeStep();
    }
  }

  void _resizeStep() {
    setState(() => {
          _resize = widget.resizeOnKeyboard == null
              ? true
              : widget.resizeOnKeyboard![_step]
        });
  }

  Color _circleColor(int index) {
    return _step == index ? widget.color.darker : widget.color.main;
  }

  Widget _buildCircle(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        color: _circleColor(index),
        shape: BoxShape.circle,
      ),
    );
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
                : IconButton(
                    onPressed: back,
                    color: widget.color,
                    icon: ArbennIcons.back),
          ),
          ...isLast()
              ? [
                  Expanded(
                      flex: 3,
                      child: Button(
                        onPressed: () {
                          if (widget.onFinish != null) {
                            widget.onFinish!();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        color: widget.color,
                        label: "FINIR",
                      ))
                ]
              : [
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: next,
                      color: widget.color,
                      icon: ArbennIcons.next,
                    ),
                  )
                ]
        ],
      ),
    );
  }

  Widget _buildBody() {
    final List<Widget> children = <Widget>[
      Expanded(
        child: Container(),
      ),
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          onTap: () => stepTapped(i),
          canRequestFocus: widget.steps[i].state != StepState.disabled,
          child: SizedBox(
            height: 72.0,
            child: Center(
              child: _buildCircle(i),
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    ];

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
      children: <Widget>[
        Material(
          child: Container(
            color: widget.color.lighter,
            child: Row(
              children: children,
            ),
          ),
        ),
        Expanded(
          child: widget.steps[_step].content,
        ),
        _buildControls(_step),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
        color: widget.color.lighter,
        child: Column(children: [
          Stack(
            children: [
              Container(
                height: 78,
                alignment: Alignment.center,
                child: widget.steps[_step].title,
              ),
              Container(
                height: 78,
                alignment: Alignment.centerLeft,
                child: BackButton(
                  color: widget.color,
                ),
              ),
            ],
          ),
          Container(
              height: 1,
              margin: const EdgeInsets.only(left: 40, right: 40),
              decoration: BoxDecoration(color: widget.color.darker)),
        ]));
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
    return Container(
      color: widget.color.lighter,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: _resize,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: _buildHeader(),
          ),
          body: Container(
            child: _buildBody(),
            color: widget.color.lighter,
          ),
        ),
      ),
    );
  }
}
