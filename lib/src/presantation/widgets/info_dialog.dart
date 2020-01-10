import 'package:flutter/material.dart';

class DialogAction {
  final String text;
  final VoidCallback onPressed;

  DialogAction({
    @required this.text,
    @required this.onPressed,
  })  : assert(text != null),
        assert(onPressed != null);
}

class InfoDialog extends StatelessWidget {
  final String info;
  final List<DialogAction> actions;

  const InfoDialog({
    Key key,
    @required this.info,
    @required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        info,
        style: Theme.of(context).textTheme.subtitle,
      ),
      actions: mapMaterialActions(),
    );
  }

  List<FlatButton> mapMaterialActions() => actions
      .map(
        (action) => FlatButton(
          child: Text(action.text),
          onPressed: action.onPressed,
        ),
      )
      .toList();
}
