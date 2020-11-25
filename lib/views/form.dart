import 'package:base32/base32.dart';
import 'package:flutter/material.dart';
import 'package:yaotp/generated/l10n.dart';
import 'package:yaotp/models/securtotp.dart';

class OTPForm extends StatefulWidget {
  @override
  _OPTFormState createState() => _OPTFormState();
}

class _OPTFormState extends State<OTPForm> {
  final List<int> interval = [15, 30, 60, 120, 300, 600];
  final List<int> digits = [6, 7, 8];
  final List<String> algorithm = ['SHA1', 'SHA256', 'SHA384', 'SHA512'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _secret;
  String _issuer;
  int _interval;
  int _digits;
  String _algorithm;
  String _accountName;
  String _imageUrl;

  String stringValidator(String value) {
    return (value == null || value.isEmpty)
        ? S.of(context).fieldCannotBeEmpty
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).addNewAccount),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                Navigator.pop(
                  context,
                  SecurTOTP(
                    secret: _secret,
                    accountName: _accountName,
                    algorithm: _algorithm,
                    digits: _digits,
                    interval: _interval,
                    issuer: _issuer,
                  ),
                );
              }
            },
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    onSaved: (newValue) {
                      _secret = newValue;
                    },
                    decoration: InputDecoration(
                      labelText: S.of(context).secretKey,
                      hintText: S.of(context).secureKeyHintText,
                    ),
                    initialValue: _secret,
                    validator: (String value) {
                      if (stringValidator(value) == null) {
                        if (value.length == 32 || value.length == 16) {
                          try {
                            base32.decode(value);
                            return null;
                          } on FormatException catch (_) {
                            return S.of(context).theEnteredSecretIsInvalid;
                          }
                        }
                      }
                      return S.of(context).theEnteredSecretIsInvalid;
                    },
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      _accountName = newValue;
                    },
                    decoration: InputDecoration(
                      labelText: S.of(context).accountName,
                    ),
                    initialValue: _accountName,
                    validator: stringValidator,
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      _issuer = newValue;
                    },
                    decoration: InputDecoration(
                      labelText: S.of(context).issuer,
                      hintText: S.of(context).issuerHintText,
                    ),
                    initialValue: _issuer,
                    validator: stringValidator,
                  ),
                  DropdownButtonFormField(
                    hint: Text(S.of(context).interval),
                    // onTap: () {
                    //   FocusManager.instance.primaryFocus.unfocus();
                    // },
                    items: interval
                        .map((e) => DropdownMenuItem<int>(
                            value: e,
                            child: Container(
                              child: Text(e.toString()),
                            )))
                        .toList(),
                    onChanged: (value) {
                      _interval = value;
                    },
                    onSaved: (value) {
                      _interval = value ?? 30;
                    },
                  ),
                  DropdownButtonFormField(
                    hint: Text(S.of(context).digits),
                    onTap: () {
                      FocusManager.instance.primaryFocus.unfocus();
                    },
                    items: digits
                        .map((e) => DropdownMenuItem<int>(
                            value: e,
                            child: Container(
                              child: Text(e.toString()),
                            )))
                        .toList(),
                    onChanged: (value) {
                      _digits = value;
                    },
                    onSaved: (value) {
                      _digits = value ?? 6;
                    },
                  ),
                  DropdownButtonFormField(
                    hint: Text(S.of(context).algorithm),
                    onTap: () {
                      FocusManager.instance.primaryFocus.unfocus();
                    },
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                    ),
                    items: algorithm
                        .map(
                          (e) => DropdownMenuItem<String>(
                              value: e, child: Text(e.toString())),
                        )
                        .toList(),
                    onChanged: (value) {
                      _algorithm = value;
                    },
                    onSaved: (value) {
                      _algorithm = value ?? 'SHA1';
                    },
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      _imageUrl = newValue;
                    },
                    decoration: InputDecoration(
                      labelText: S.of(context).iconUrl,
                      hintText: S.of(context).imageUrlHintText,
                    ),
                    initialValue: _imageUrl,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
