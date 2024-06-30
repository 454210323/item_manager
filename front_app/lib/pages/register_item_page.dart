import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../constants.dart';
import '../widgets/barcode_scanner.dart';
import '../widgets/show_snack_bar.dart';

class RegisterItemPage extends StatefulWidget {
  final String itemCode;

  const RegisterItemPage({super.key, this.itemCode = ''});

  @override
  _RegisterItemPageState createState() => _RegisterItemPageState();
}

class _RegisterItemPageState extends State<RegisterItemPage> {
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemTypeController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _itemCodeController.text = widget.itemCode;
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select the image source'),
          actions: <Widget>[
            TextButton(
              child: Text('Camera'),
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
            ),
            TextButton(
              child: Text('Gallery'),
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );

    if (source != null) {
      final pickedFile = await _picker.pickImage(source: source);
      if (!mounted) return; // 检查是否挂载
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        } else {
          showSnackBar(context, 'No image selected', 'error');
        }
      });
    }
  }

  Future<void> _submitData() async {
    if (_itemNameController.text.isEmpty || _priceController.text.isEmpty) {
      showSnackBar(context, 'Please fill in all fields', 'error');
      return;
    }
    if (Decimal.tryParse(_priceController.text) == null) {
      showSnackBar(context, 'Please enter a valid price', 'error');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final request = http.MultipartRequest('POST', Uri.parse(API.ITEM));
      request.fields['itemCode'] = _itemCodeController.text;
      request.fields['itemName'] = _itemNameController.text;
      request.fields['itemType'] = _itemTypeController.text;
      request.fields['series'] = _seriesController.text;
      request.fields['price'] = Decimal.parse(_priceController.text).toString();
      String mimeType =
          lookupMimeType(_imageFile!.path) ?? 'application/octet-stream';
      List<String> mimeTypes = mimeType.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
        contentType: MediaType(mimeTypes[0], mimeTypes[1]),
      ));
      final response = await request.send();
      if (response.statusCode == 200) {
        showSnackBar(context, 'Registration successful', 'success');
      } else {
        showSnackBar(context, 'Registration failed', 'error');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', 'error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录新商品')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _itemCodeController,
                      decoration: const InputDecoration(labelText: '商品编号'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-z]|[0-9]")),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String result = await BarcodeScanner.scanBarcode();
                      if (!mounted) return;
                      setState(() {
                        _itemCodeController.text = result;
                      });
                    },
                    child: const Text('Scan'),
                  )
                ],
              ),
              TextField(
                decoration: const InputDecoration(labelText: '商品名'),
                controller: _itemNameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: '类型'),
                controller: _itemTypeController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: '系列'),
                controller: _seriesController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: '价格'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                controller: _priceController,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    // onPressed: () {},
                    child: const Text('添加图片'),
                  ),
                  _imageFile == null
                      ? Container()
                      : Image.file(
                          _imageFile!,
                          width: 100,
                          height: 100,
                        ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('注册'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
