// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ImagePicker picker = ImagePicker();
  final TextEditingController _outputController = TextEditingController();
  bool isValidLink = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_outputController.text ?? '',
                style: const TextStyle(fontSize: 20)),
            (isValidLink)
                ? ElevatedButton(
                    onPressed: () async {
                      try {
                        Uri url = Uri.parse(_outputController.text);
                        if (await canLaunch(url.toString())) {
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.inAppWebView,
                            webViewConfiguration: const WebViewConfiguration(
                                enableDomStorage: false),
                          )) {
                            throw Exception('Could not launch $url');
                          }
                        } else {
                          throw Exception('Could not launch $url');
                        }
                      } catch (e) {
                        if (e is PlatformException) {
                          // Handle the platform exception here
                          print('Failed to launch URL: ${e.message}');
                        } else {
                          // Re-throw any other exception
                          rethrow;
                        }
                      }
                    },
                    child: const Text('Open Link'))
                : const SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _scan,
        tooltip: 'Pick Photo',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Future _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      log(barcode ?? 'nothing return.');
      log('nothing return.');
      print('nothing return.');
      setState(() {});
    } else {
      log(barcode);
      isValidLink = true;
      this._outputController.text = barcode;
      setState(() {});
    }
  }
}
