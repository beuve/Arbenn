import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart' hide IconButton, BackButton;
import 'package:arbenn/utils/colors.dart';
import 'package:arbenn/components/buttons.dart';

class FormStepper extends StatefulWidget {
  const FormStepper({
    Key? key,
    required this.steps,
    required this.color,
    this.onStepTapped,
    this.onNext,
    this.onBack,
    this.onCancel,
    this.pop = true,
    required this.onFinish,
    this.resizeOnKeyboard,
  }) : super(key: key);

  final List<Step> steps;
  final Nuance color;
  final VoidCallback? onCancel;
  final Future<bool> Function() onFinish;
  final List<bool>? resizeOnKeyboard;
  final ValueChanged<int>? onStepTapped;
  final ValueChanged<int>? onNext;
  final ValueChanged<int>? onBack;
  final bool pop;

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
                    child: FutureButton(
                      onPressed: widget.onFinish,
                      onEnd: widget.pop ? () => Navigator.pop(context) : null,
                      color: widget.color,
                      label: "FINIR",
                    ),
                  )
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
            color: widget.color.lighter,
            child: _buildBody(),
          ),
        ),
      ),
    );
  }
}
