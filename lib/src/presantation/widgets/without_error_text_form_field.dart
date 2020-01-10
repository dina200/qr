import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WithoutErrorTextFormField extends FormField<String> {
  final bool _showErrorText = false;

  WithoutErrorTextFormField({
    Key key,
    this.controller,
    String initialValue,
    FocusNode focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction,
    TextStyle style,
    StrutStyle strutStyle,
    TextDirection textDirection,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions toolbarOptions,
    bool showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    bool autovalidate = false,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int minLines,
    bool expands = false,
    int maxLength,
    ValueChanged<String> onChanged,
    GestureTapCallback onTap,
    VoidCallback onEditingComplete,
    ValueChanged<String> onFieldSubmitted,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    Radius cursorRadius,
    Color cursorColor,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder buildCounter,
  }) : assert(textAlign != null),
        assert(controller == null || initialValue == null),
        assert(autofocus != null),
        assert(readOnly != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(autovalidate != null),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
        (maxLines == null) || (minLines == null) || (maxLines >= minLines),
        'minLines can\'t be greater than maxLines',
        ),
        assert(expands != null),
        assert(
        !expands || (maxLines == null && minLines == null),
        'minLines and maxLines must be null when expands is true.',
        ),
        assert(maxLength == null || maxLength > 0),
        assert(enableInteractiveSelection != null),
        super(
        key: key,
        initialValue: controller != null ? controller.text : (initialValue ?? ''),
        onSaved: onSaved,
        validator: validator,
        autovalidate: autovalidate,
        enabled: enabled,
        builder: (field) {
          final theme = Theme.of(field.context);
          final WithoutErrorFormFieldState state = field;

          final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
              .applyDefaults(theme.inputDecorationTheme);
          void onChangedHandler(String value) {
            if (onChanged != null) {
              onChanged(value);
            }
            field.didChange(value);
          }

          Color color = theme.brightness == Brightness.dark
              ? theme.accentColor
              : theme.primaryColorDark;

          return Theme(
            data: theme.copyWith(
                cursorColor: color,
                primaryColor: color,
                disabledColor: theme.hintColor
            ),
            child: TextField(
              controller: state._effectiveController,
              focusNode: focusNode,
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
                isDense: true,
              ),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textDirection: textDirection,
              textCapitalization: textCapitalization,
              autofocus: autofocus,
              toolbarOptions: toolbarOptions,
              readOnly: readOnly,
              showCursor: showCursor,
              obscureText: obscureText,
              autocorrect: autocorrect,
              maxLengthEnforced: maxLengthEnforced,
              maxLines: maxLines,
              minLines: minLines,
              expands: expands,
              maxLength: maxLength,
              onChanged: onChangedHandler,
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              onSubmitted: onFieldSubmitted,
              inputFormatters: inputFormatters,
              enabled: enabled,
              cursorWidth: cursorWidth,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              keyboardAppearance: keyboardAppearance,
              enableInteractiveSelection: enableInteractiveSelection,
              buildCounter: buildCounter,
            ),
          );
        },
      );

  final TextEditingController controller;

  @override
  WithoutErrorFormFieldState createState() =>
      WithoutErrorFormFieldState(showError: _showErrorText);
}

class WithoutErrorFormFieldState extends FormFieldState<String> {
  TextEditingController _controller;
  final bool _showError;
  String _errorText;
  bool _hasError = false;


  void onChangeCar() {
    super.setValue('');
  }

  WithoutErrorFormFieldState({showError})
      : _showError = showError,
        super();

  String get errorText => _showError ? _errorText : null;

  bool validate() {
    setState(() {
      if (widget.validator != null) {
        _errorText = widget.validator(value);
        _hasError = _errorText != null;
      }
    });
    return !_hasError;
  }

  TextEditingController get _effectiveController => widget.controller ?? _controller;

  @override
  WithoutErrorTextFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(WithoutErrorTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null)
          _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }
}
