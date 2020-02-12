import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final googleColor = Colors.redAccent[700];

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final VoidCallback onPressed;

  SocialButton({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.backgroundColor,
    this.onPressed,
  })  : assert(title != null),
        assert(icon != null),
        assert(backgroundColor != null),
        super(key: key);

  factory SocialButton.google({
    Key key,
    @required String title,
    @required VoidCallback onPressed,
  }) {
    return SocialButton(
      key: key,
      title: title,
      backgroundColor: googleColor,
      onPressed: onPressed,
      icon: FontAwesomeIcons.google,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RawMaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(48.0)),
      ),
      fillColor: backgroundColor,
      constraints: BoxConstraints(
        minWidth: 132.0,
        minHeight: 48.0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              icon,
              size: 14.0,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.subtitle.copyWith(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
