import 'package:flutter/material.dart';
import 'package:instagramz_flutter/utilities/dialogs/generic_dialog.dart';

Future<void> showRegisterSuccessDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'Alert',
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
