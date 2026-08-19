import 'package:flutter/material.dart';
import 'package:doc_scanner_sdk/doc_scanner_sdk.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocScanner SDK Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ScannerPage(),
    );
  }
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _scanner = DocScannerSdk.instance;
  
  String? _frontImagePath;
  String? _backImagePath;
  bool _isScanning = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Document Scanner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Scan Documents',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            if (_error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Front Image
            if (_frontImagePath != null) ...[
              const Text('Front:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_frontImagePath!),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Back Image
            if (_backImagePath != null) ...[
              const Text('Back:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_backImagePath!),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Buttons
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _scanSingleDocument,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Single Side'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 12),
            
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _scanBothSides,
              icon: const Icon(Icons.document_scanner),
              label: const Text('Scan Both Sides'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 12),
            
            if (_frontImagePath != null || _backImagePath != null)
              OutlinedButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            
            if (_isScanning)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanSingleDocument() async {
    setState(() {
      _isScanning = true;
      _error = null;
    });

    try {
      // Request permission
      final hasPermission = await _scanner.hasCameraPermission();
      if (!hasPermission) {
        final granted = await _scanner.requestCameraPermission();
        if (!granted) {
          setState(() {
            _error = 'Camera permission is required';
            _isScanning = false;
          });
          return;
        }
      }

      // Scan document
      final result = await _scanner.scanDocument();
      
      if (result.isSuccess && result.frontImagePath != null) {
        setState(() {
          _frontImagePath = result.frontImagePath;
          _backImagePath = null;
        });
      } else {
        setState(() {
          _error = result.errorMessage ?? 'Scan failed';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _scanBothSides() async {
    setState(() {
      _isScanning = true;
      _error = null;
    });

    try {
      // Request permission
      final hasPermission = await _scanner.hasCameraPermission();
      if (!hasPermission) {
        final granted = await _scanner.requestCameraPermission();
        if (!granted) {
          setState(() {
            _error = 'Camera permission is required';
            _isScanning = false;
          });
          return;
        }
      }

      // Scan both sides
      final result = await _scanner.scanBothSides();
      
      if (result.isSuccess) {
        setState(() {
          _frontImagePath = result.frontImagePath;
          _backImagePath = result.backImagePath;
        });
      } else {
        setState(() {
          _error = result.errorMessage ?? 'Scan failed';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _clear() {
    setState(() {
      _frontImagePath = null;
      _backImagePath = null;
      _error = null;
    });
  }
}
