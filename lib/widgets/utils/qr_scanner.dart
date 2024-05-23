import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
class QRScannerView extends StatefulWidget {
  const QRScannerView({Key? key}) : super(key: key);

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}
class _QRScannerViewState extends State<QRScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final WorkOrdersController _workOrdersController= Get.find<WorkOrdersController>();
  Barcode? result;
  QRViewController? controller;
 TextEditingController _textController = TextEditingController();
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        body: QRView(
          overlay: QrScannerOverlayShape(
            borderColor: const Color.fromARGB(255, 54, 60, 244),
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 300,
          ),
          
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        )
      ),
    );
    
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print("Scan data: $scanData");
      _workOrdersController.getControlItem(controlNum: "scanData");
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}