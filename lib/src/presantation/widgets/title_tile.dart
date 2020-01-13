import 'package:flutter/material.dart';

class TitleTile extends StatelessWidget {
  final String title;

  const TitleTile({Key key, @required this.title})
      : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      child: ListTile(
        dense: true,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .subtitle
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
