import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yaotp/generated/l10n.dart';
import 'package:yaotp/models/securtotp.dart';
import 'package:yaotp/viewmodels/otp.dart';

enum _MenuAction { Nop, Delete }

class OTPItem2 extends StatelessWidget {
  final SecurTOTP securTOTP;

  OTPItem2({@required this.securTOTP});

  Future<void> showItemMenu(BuildContext context) async {
    RenderBox box = context.findRenderObject();
    Offset position = box.localToGlobal(Offset.zero);

    final result = await showMenu<_MenuAction>(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
      items: <PopupMenuEntry<_MenuAction>>[
        PopupMenuItem<_MenuAction>(
          value: _MenuAction.Delete,
          child: Row(
            children: <Widget>[
              Icon(Icons.delete),
              Text(S.of(context).delete),
            ],
          ),
        )
      ],
    );

    if (result == _MenuAction.Delete) {
      Provider.of<OTPListViewModel>(context, listen: false).delete(securTOTP);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget subtitle = Text(securTOTP.issuer != null
        ? (securTOTP.issuer + ' (' + securTOTP.accountName + ')')
        : securTOTP.accountName);

    Widget imgPlaceholder = CircleAvatar(
      backgroundColor: Theme.of(context).cardColor,
      backgroundImage: AssetImage('images/padlock.png'),
    );

    Widget leading = securTOTP.imageUrl != null
        ? CachedNetworkImage(
            imageUrl: securTOTP.imageUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundColor: Theme.of(context).cardColor,
                  backgroundImage: imageProvider,
                ),
            placeholder: (context, url) => imgPlaceholder,
            errorWidget: (context, url, error) => imgPlaceholder)
        : imgPlaceholder;

    return Card(
      child: Consumer<DateTime>(
        builder: (context, currentTime, _) => ListTile(
          onTap: () async {
            await Clipboard.setData(
                ClipboardData(text: securTOTP.getTotp(currentTime)));
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(S.of(context).otpHasBeenCopiedToClipboard)));
          },
          onLongPress: () => showItemMenu(context),
          title: TOTPValue(securTOTP, currentTime),
          subtitle: subtitle,
          leading: leading,
          trailing: TrailingIndicator(
              percentage: ((currentTime.millisecondsSinceEpoch / 1000) %
                      (securTOTP.interval)) /
                  securTOTP.interval),
        ),
      ),
    );
  }
}

class TrailingIndicator extends StatelessWidget {
  final double percentage;

  const TrailingIndicator({this.percentage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => CircularProgressIndicator(
        value: percentage,
        valueColor: AlwaysStoppedAnimation<Color>(
            ColorTween(begin: Colors.green, end: Colors.red)
                .transform(percentage)),
        strokeWidth: 5,
      ),
    );
  }
}

class TOTPValue extends StatefulWidget {
  final DateTime curTime;
  final SecurTOTP securTOTP;

  TOTPValue(this.securTOTP, this.curTime);

  @override
  State<TOTPValue> createState() => _TOTPValueState();
}

class _TOTPValueState extends State<TOTPValue> {
  String _totp;

  @override
  void initState() {
    this._totp = widget.securTOTP.getTotp(widget.curTime);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TOTPValue oldWidget) {
    if (oldWidget.curTime.millisecondsSinceEpoch ~/
            (1000 * widget.securTOTP.interval) !=
        widget.curTime.millisecondsSinceEpoch ~/
            (1000 * widget.securTOTP.interval)) {
      setState(() {
        this._totp = widget.securTOTP.getTotp(widget.curTime);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  String formatOTP(String otp) {
    switch (otp.length) {
      case 6:
        return otp.substring(0, 3) + ' ' + otp.substring(3, 6);
      case 7:
        return otp.substring(0, 2) +
            ' ' +
            otp.substring(2, 4) +
            ' ' +
            otp.substring(4, 7);
      case 8:
        return otp.substring(0, 2) +
            ' ' +
            otp.substring(2, 4) +
            ' ' +
            otp.substring(4, 6) +
            ' ' +
            otp.substring(6, 8);
    }
    return otp;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatOTP(_totp),
      style: TextStyle(fontSize: 20),
    );
  }
}
