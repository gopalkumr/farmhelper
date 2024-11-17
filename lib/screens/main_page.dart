import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;

class MainPage extends StatefulWidget {
  final Client client;

  const MainPage({super.key, required this.client});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Future<models.User> _userFuture;
  late Storage storage;
  late Databases database;

  XFile? _image;
  Uint8List? _imageBytes;
  String predictionResult = '';
  bool isloading = false;
  /*
  database id = "farmhelp-db"
  databse name = "farmhelp-db"

  */

  static const String databaseId = 'farmhelp-db';
  static const String collectionId = 'farmhelp-collectionid';
  static const String bucketId = '67132d8a003cd527a806';

  final ImagePicker _picker = ImagePicker();

// added Slide menu to slide from top corner, added 3 options to slide menu
  void _showSlideMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuOption(
                icon: Icons.star,
                title: 'Explore Premium Options',
                onTap: () {
                  // Handle premium options
                  Navigator.pop(context);
                },
              ),
              _buildMenuOption(
                icon: Icons.smart_toy,
                title: 'More Accurate Insights',
                onTap: () {
                  // Handle Gemini option
                  Navigator.pop(context);
                },
              ),
              _buildMenuOption(
                icon: Icons.bug_report,
                title: 'Beta Features',
                onTap: () {
                  // Handle beta features
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
    _userFuture = _fetchUserDetails();
  }

  Future<models.User> _fetchUserDetails() async {
    final account = Account(widget.client);
    try {
      return await account.get();
    } catch (e) {
      throw Exception("Failed to fetch user details");
    }
  }

  // future function for storing the medatadat and image to the appwrite server

  Future<void> _storeImageMetadata(
      {required String ImageId,
      required String userId,
      required String prediction,
      required String imageUrl}) async {
    try {
      await database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: {
          'ImageId': ImageId,
          'userId': userId,
          'prediction': prediction,
          'imageUrl': imageUrl,
        },
      );
    } catch (e) {
      print('Failed to store image metadata: $e');
      throw Exception('Failed to store image metadata');
    }
  }

  Future<String> _uploadImageToStorage(
      String imagePath, Uint8List imageBytes, String userId) async {
    try {
      final filename =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imagePath)}';
      final result = await storage.createFile(
          bucketId: bucketId,
          fileId: ID.unique(),
          file: InputFile.fromBytes(
              bytes: imageBytes,
              filename: filename,
              contentType: 'image/jpeg'));

      return result.$id;
    } catch (e) {
      print('Failed to upload image to storage: $e');
      throw Exception('Failed to upload image to storage');
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _image = pickedFile;
        _imageBytes = imageBytes;
        uploadImage(pickedFile.path);
        isloading = true;
      });
    } else {
      setState(() {
        isloading = false;
      });
    }
  }

  Future uploadImage(String path) async {
    final uri = Uri.parse('https://plant-dd-co9k.onrender.com/predict');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        setState(() {
          predictionResult = responseBody;
          isloading = false;
        });
      }
    } catch (e) {
      print('Could not upload image: $e');
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> resultData = predictionResult.isNotEmpty
        ? (jsonDecode(predictionResult) as Map<String, dynamic>)
        : {};

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Plant Disease Detection',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _showSlideMenu,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F7F4), Colors.white],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: FutureBuilder<models.User>(
            future: _userFuture,
            builder: (context, snapshot) {
              String userName = snapshot.data?.name ?? "Plant Explorer";

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 100),
                              // Welcome Card
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor:
                                          Colors.green.withOpacity(0.1),
                                      child: const Icon(
                                        Icons.eco,
                                        size: 40,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Welcome, $userName!',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Let\'s identify your plant\'s health',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Image Upload Section
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 15,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.photo_library),
                                        label:
                                            const Text('Upload from Gallery'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: () =>
                                            getImage(ImageSource.gallery),
                                      ),
                                      const SizedBox(height: 15),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.camera_alt),
                                        label: const Text('Take a Photo'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: () =>
                                            getImage(ImageSource.camera),
                                      ),
                                      if (_imageBytes != null) ...[
                                        const SizedBox(height: 20),
                                        Flexible(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.memory(
                                              _imageBytes!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        TextButton.icon(
                                          icon: const Icon(Icons.refresh),
                                          label:
                                              const Text('Scan Another Plant'),
                                          onPressed: () {
                                            setState(() {
                                              _imageBytes = null;
                                              predictionResult = '';
                                            });
                                          },
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isloading)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Lottie.network(
                                    'https://assets1.lottiefiles.com/packages/lf20_uwR49r.json',
                                    height: 200,
                                  ),
                                ),
                              if (predictionResult.isNotEmpty)
                                _buildPredictionResult(resultData),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionResult(Map<String, dynamic> resultData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_florist, color: Colors.green),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  'Analysis Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildResultSection(
            'Title',
            resultData['title'] ?? 'Not available',
            Icons.medication,
          ),
          _buildResultSection(
            'Description',
            resultData['description'] ?? 'No description available',
            Icons.description,
          ),
          _buildResultSection(
            'Prevention',
            resultData['prevent'] ?? 'No prevention measures available',
            Icons.shield,
          ),
          if (resultData['supplement_buy_link'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Purchase Supplement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  final url = resultData['supplement_buy_link'];
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultSection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.green),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
