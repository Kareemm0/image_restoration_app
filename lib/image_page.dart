import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  img.Image? _originalImage;
  img.Image? _processedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickImage = await _picker.pickImage(source: source);
    if (pickImage == null) return;

    final Uint8List bytes = await pickImage.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    setState(() {
      _originalImage = image;
      _processedImage = _originalImage != null
          ? img.grayscale(
              _originalImage!,
            )
          : null;
      //! _processedImage = _originalImage != null
      //!    ? img.copyResize(_originalImage!, width: 100, height: 1000)
      //!    : null;
      // !_processedImage = _originalImage != null
      //  !   ? img.gaussianBlur(_originalImage!, radius: 5)
      //   !  : null;
      // !_processedImage = _originalImage != null ? img.drawImage(
      //  ! _originalImage,
      //  ! img.Rect.fromPoints(img.Point(10, 10), img.Point(100, 100)),
      //  ! fillColor: img.getColor(255, 0, 0),
      // !);
      //!List<int> jpegBytes = img.encodeJpg(image, quality: 85);
      //!img.Histogram histogram = img.getHistogram(image);
      // !img.Image warpedImage = img.copyTransform(image, [
      //  ! img.Point(0, 0),
      //  ! img.Point(100, 0),
      //  ! img.Point(100, 100),
      //  ! img.Point(0, 100),
      // !], [
      // !  img.Point(10, 10),
      // !  img.Point(90, 10),
      // !  img.Point(100, 90),
      //  ! img.Point(0, 90),
      // !]);
    });
  }

  void _chooseCameraOption() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.3,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  const Text(
                    "Choose From Camera Or Gallery",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                      child: const Text(
                        "Choose From Camera",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      child: const Text(
                        "Choose From Gallery",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Restoration"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_processedImage != null)
            Container(
              clipBehavior: Clip.antiAlias,
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: MemoryImage(
                      Uint8List.fromList(img.encodeJpg(_processedImage!))),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: MaterialButton(
              onPressed: () {
                _chooseCameraOption();
              },
              child: const Text(
                "Upload Image",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      )),
    );
  }
}
