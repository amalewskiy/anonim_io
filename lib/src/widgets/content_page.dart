import 'package:anonim_io/src/core/utils/const.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({
    required this.child,
    this.withScrollPhysics = true,
    super.key,
  });

  final Widget child;
  final bool withScrollPhysics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: withScrollPhysics
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: appPadding),
                    child: child,
                  )
                : Padding(
                    padding: const EdgeInsets.all(appPadding),
                    child: child,
                  ),
          ),
        ),
      ),
    );
  }
}
