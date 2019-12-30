import 'package:flutter/material.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';
import 'package:qr/src/presantation/widgets/no_scroll_behavior.dart';

class AuthLayout extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  AuthLayout({
    Key key,
    this.isLoading = false,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _resetFocusNode(context),
      child: LoadingLayout(
        isLoading: isLoading,
        child: Container(
          color: Theme.of(context).primaryColorDark,
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: _buildScrollingLayout,
            ),
          ),
        ),
      ),
    );
  }

  void _resetFocusNode(BuildContext context) =>
      FocusScope.of(context).requestFocus(FocusNode());

  Widget _buildScrollingLayout(
      BuildContext context, BoxConstraints constraints) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: NoOverScrollBehavior(),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: constraints,
            child: child,
          ),
        ),
      ),
    );
  }
}

class AuthContainer extends StatelessWidget {
  final Widget child;

  AuthContainer({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final horizontalPadding =
    MediaQuery.of(context).size.width < 350 ? 16.0 : 42.0;
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 480.0,
          maxHeight: 500.0,
        ),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: child,
      ),
    );
  }
}
