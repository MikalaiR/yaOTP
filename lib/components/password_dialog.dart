import 'package:flutter/material.dart';
import 'package:yaotp/generated/l10n.dart';

class EncryptionPasswordDialog extends StatefulWidget {
  final bool isForEncryption;

  EncryptionPasswordDialog({this.isForEncryption = true});

  @override
  State<EncryptionPasswordDialog> createState() =>
      _EncryptionPasswordDialogState();
}

class _EncryptionPasswordDialogState extends State<EncryptionPasswordDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).enterPassword),
      content: TextField(
        decoration: InputDecoration(
            labelText: S.of(context).password,
            helperText: widget.isForEncryption
                ? S.of(context).emptyToLeaveUnencrypted
                : null),
        controller: controller,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
      ),
      actions: [
        FlatButton(
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        FlatButton(
          child: Text(S.of(context).save),
          onPressed: () {
            Navigator.pop(context, controller.text);
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
