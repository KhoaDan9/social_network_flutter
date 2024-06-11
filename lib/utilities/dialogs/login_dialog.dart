import 'package:flutter/material.dart';
import 'package:instagramz_flutter/utilities/dialogs/generic_dialog.dart';

Future<void> showLoginDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: "Error!",
    content: "Email or password is incorrect!",
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
