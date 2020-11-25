import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:yaotp/components/otp_item.dart';
import 'package:yaotp/controllers/otpcontroller.dart';
import 'package:yaotp/generated/l10n.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('yaOTP'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => {Navigator.pushNamed(context, '/settings')},
          ),
        ],
      ),
      body: OTPList(),
      floatingActionButton: HomeFab(),
    );
  }
}

class HomeFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedFloatingActionButton(
      fabButtons: [
        FloatingActionButton(
          heroTag: "scan_qr_code",
          child: Icon(Icons.camera),
          tooltip: S.of(context).scanQrCode,
          onPressed: () async {
            var status = await Permission.camera.status;
            if (!status.isPermanentlyDenied) {
              status = await Permission.camera.request();
            }

            if (!status.isGranted) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(S.of(context).grantCameraAccessToProceed)));
              return;
            }

            final otp = await Navigator.pushNamed(context, '/scan');
            if (otp != null) {
              Provider.of<OTPController>(context, listen: false).add(otp);
            }
          },
        ),
        FloatingActionButton(
          heroTag: "enter_key",
          child: Icon(Icons.keyboard),
          tooltip: S.of(context).enterAProvidedKey,
          onPressed: () async {
            final otp = await Navigator.pushNamed(context, '/form');
            if (otp != null) {
              Provider.of<OTPController>(context, listen: false).add(otp);
            }
          },
        )
      ],
      animatedIconData: AnimatedIcons.menu_close,
    );
  }
}

class OTPList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OTPController>(
      builder: (context, controller, _) => ListView.builder(
        itemCount: controller.all.length,
        itemBuilder: (context, index) =>
            OTPItem2(securTOTP: controller.all.elementAt(index)),
      ),
    );
  }
}
