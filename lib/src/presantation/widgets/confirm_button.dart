import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final String title;
  final bool isButtonActive;
  final VoidCallback onPressed;

  const ConfirmButton({
    Key key,
    @required this.title,
    @required this.isButtonActive,
    @required this.onPressed,
  })  : assert(title != null),
        assert(isButtonActive != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final horizontalPadding = title.length < 10 ? 70.0 : 25.0;

    return RawMaterialButton(
      fillColor: isButtonActive ? theme.primaryColorDark : Colors.white,
      shape: RoundedRectangleBorder(
        side: isButtonActive
            ? BorderSide.none
            : BorderSide(color: theme.primaryColorDark),
        borderRadius: BorderRadius.circular(48.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14.0),
        child: Text(
          title.toUpperCase(),
          style: theme.textTheme.subtitle.copyWith(
            color: isButtonActive ? Colors.white : theme.primaryColorDark,
          ),
        ),
      ),
      onPressed: isButtonActive ? onPressed : null,
    );
  }
}
