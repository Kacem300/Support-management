import 'package:flutter/material.dart';

class DialogUtils {
  /// Show a simple alert dialog
  static Future<void> showAlert(
    BuildContext context, {
    required String title,
    required String message,
    String okButtonText = 'OK',
    VoidCallback? onOk,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOk?.call();
              },
              child: Text(okButtonText),
            ),
          ],
        );
      },
    );
  }

  /// Show a confirmation dialog
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmButtonText = 'Confirm',
    String cancelButtonText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelButtonText),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: isDestructive
                  ? TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    )
                  : null,
              child: Text(confirmButtonText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Show a loading dialog
  static void showLoading(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  /// Hide loading dialog
  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Show an error dialog
  static Future<void> showError(
    BuildContext context, {
    String title = 'Error',
    required String message,
    String okButtonText = 'OK',
    VoidCallback? onOk,
  }) async {
    return showAlert(
      context,
      title: title,
      message: message,
      okButtonText: okButtonText,
      onOk: onOk,
    );
  }

  /// Show a success dialog
  static Future<void> showSuccess(
    BuildContext context, {
    String title = 'Success',
    required String message,
    String okButtonText = 'OK',
    VoidCallback? onOk,
  }) async {
    return showAlert(
      context,
      title: title,
      message: message,
      okButtonText: okButtonText,
      onOk: onOk,
    );
  }

  /// Show a custom dialog
  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => child,
    );
  }

  /// Show a bottom sheet
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (BuildContext context) => child,
    );
  }
}
