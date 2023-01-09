import 'package:anonim_io/src/core/utils/failure.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FailureWidget {
  const FailureWidget({required Failure exception}) : _exception = exception;

  final Failure _exception;

  Future<void> showErrorToast({required BuildContext context}) {
    return Fluttertoast.showToast(msg: _getMessageForUser(context));
  }

  Widget showErrorWidgetOnContentPage({required BuildContext context}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 100),
          Text(
            _getMessageForUser(context),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  String _getMessageForUser(BuildContext context) {
    switch (_exception.runtimeType) {
      case WrongCredentialsException:
        switch (_exception.message) {
          default:
            return 'Wrong credentials';
        }
      case UserExistsException:
        switch (_exception.message) {
          default:
            return 'User exists';
        }
      case WeakPasswordException:
        switch (_exception.message) {
          default:
            return 'Weak password';
        }
      default:
        return 'Unknown error';
    }
  }
}
