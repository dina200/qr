import 'package:flutter/material.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;

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

Future<void> showErrorDialog({
  @required BuildContext context,
  @required String errorMessage,
  @required VoidCallback onPressed,
}) async {
  assert(context != null || errorMessage != null);
  await showDialog(
    context: context,
    builder: (context) {
      return InfoDialog(
        info: errorMessage,
        actions: [
          DialogAction(
            text: qrLocale.ok,
            onPressed: onPressed,
          )
        ],
      );
    },
  );
}

Future<bool> showChoiceDialog({
  @required BuildContext context,
  @required String message,
  @required VoidCallback onOk,
  @required VoidCallback onCancel,
}) async {
  assert(context != null || message != null);
  return await showDialog(
    context: context,
    builder: (context) {
      return InfoDialog(
        info: message,
        actions: [
          DialogAction(
            text: qrLocale.cancel,
            onPressed: onCancel,
          ),
          DialogAction(
            text: qrLocale.ok,
            onPressed: onOk,
          ),
        ],
      );
    },
  ) ?? false;
}
