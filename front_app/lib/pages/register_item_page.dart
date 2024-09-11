import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'package:mime/mime.dart';

import '../constants.dart';
import '../models/item.dart';
import '../widgets/barcode_scanner.dart';
import '../widgets/show_snack_bar.dart';

class RegisterItemPage extends StatefulWidget {
  final String? itemCode;

  const RegisterItemPage({super.key, this.itemCode});

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
  Uint8List? _imageBytes;
  bool _isUpdate = false;

  bool _isLoading = false;
  Item? _item;
  @override
  void initState() {
    super.initState();

    if (widget.itemCode != null) {
      _itemCodeController.text = widget.itemCode!;
      _fetchItem();
      setState(() {
        _isUpdate = true;
      });
    }
  }

  Future<void> _fetchItem() async {
    var url = Uri.parse(API.ITEM).replace(queryParameters: {
      'itemCode': _itemCodeController.text,
    });
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status']) {
          setState(() {
            _item = Item.fromJson(jsonData['item']);
          });
          _itemNameController.text = _item!.itemName;
          _itemTypeController.text = _item!.type;
          _seriesController.text = _item!.series;
          _priceController.text = _item!.price.toString();
        }
      }
    } catch (e) {
      showSnackBar(context, 'Error occurred: $e', 'error');
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Web平台选择图片
      final Uint8List? bytes = await ImagePickerWeb.getImageAsBytes();
      if (!mounted) return; // 检查是否挂载
      if (bytes != null) {
        setState(() {
          _imageBytes = bytes;
        });
      } else {
        showSnackBar(context, 'No image selected', 'error');
      }
    } else {
      // 移动平台选择图片
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
      var requestMethod = _isUpdate ? 'PUT' : 'POST';

      final request = http.MultipartRequest(requestMethod, Uri.parse(API.ITEM));
      request.fields['itemCode'] = _itemCodeController.text;
      request.fields['itemName'] = _itemNameController.text;
      request.fields['itemType'] = _itemTypeController.text;
      request.fields['series'] = _seriesController.text;
      request.fields['price'] = Decimal.parse(_priceController.text).toString();

      if (kIsWeb && _imageBytes != null) {
        // Web平台上传图片
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          _imageBytes!,
          filename: 'upload.jpg', // 可以根据实际情况更改
          contentType: MediaType('image', 'jpeg'), // 假设图片是jpeg格式
        ));
      } else if (_imageFile != null) {
        // 移动平台上传图片
        String mimeType =
            lookupMimeType(_imageFile!.path) ?? 'application/octet-stream';
        List<String> mimeTypes = mimeType.split('/');

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
          contentType: MediaType(mimeTypes[0], mimeTypes[1]),
        ));
      }

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
                    onPressed: _isUpdate
                        ? null
                        : () async {
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
                  if (_imageBytes != null)
                    Image.memory(
                      _imageBytes!,
                      width: 100,
                      height: 100,
                    )
                  else if (_imageFile != null)
                    Image.file(
                      _imageFile!,
                      width: 100,
                      height: 100,
                    )
                  else
                    Container(),
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
