import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: BarcodeDisplay(),
      ),
    );
  }
}

class BarcodeDisplay extends StatelessWidget {
  const BarcodeDisplay({Key? key}) : super(key: key);

  Future<File> _generateBarcode() async {
    final Barcode dataMatrix = Barcode.dataMatrix();

    Uint8List bytes = Uint8List.fromList(latin1.encode('abcdefghijklmnopqrstuvwxyz').toList());
    String svgContent = dataMatrix.toSvgBytes(bytes);

    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/barcode.svg');
    await file.writeAsString(svgContent);

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<File>(
        future: _generateBarcode(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }

          return SvgPicture.file(snapshot.requireData);
        },
      ),
    );
  }
}
