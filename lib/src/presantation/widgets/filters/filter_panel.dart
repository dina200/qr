import 'package:flutter/material.dart';

class FilterPanel<T> extends StatelessWidget {
  final T selectedFilter;
  final ValueChanged<T> onPressed;
  final List<ButtonFilter<T>> listButtons;

  const FilterPanel({
    Key key,
    @required this.selectedFilter,
    @required this.onPressed,
    @required this.listButtons,
  })  : assert(selectedFilter != null),
        assert(onPressed != null),
        assert(listButtons != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor,
            width: 1.0,
          ),
        ),
        child: Row(
          children: listButtons,
        ),
      ),
    );
  }
}

class ButtonFilter<T> extends StatelessWidget {
  final T filter;
  final String title;
  final ValueChanged<T> onPressed;
  final bool selected;

  const ButtonFilter({
    Key key,
    @required this.filter,
    @required this.title,
    @required this.onPressed,
    @required this.selected,
  })  : assert(filter != null),
        assert(title != null),
        assert(onPressed != null),
        assert(selected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        shape: ContinuousRectangleBorder(
          side: BorderSide(
            width: 2.0,
            color: selected
                ? Theme.of(context).primaryColorDark
                : Colors.transparent,
          ),
        ),
        child: Text(title),
        onPressed: () => onPressed(filter),
      ),
    );
  }
}
