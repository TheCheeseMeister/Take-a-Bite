import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:take_a_bite/globals.dart' as globals;
import 'package:image/image.dart' as img;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? selectedImage;
  final userBioController = TextEditingController();

  Future imageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  Future<void> getAllUsers() async {
    var url = Uri.http('3.93.61.3', '/api/feed/users');
    var response = await http.get(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    final data = jsonDecode(response.body)['users'];
    print(data);
  }

  Future<void> storePicture() async {
    int user_id = globals.user['user_id'];

    var url = Uri.http('3.93.61.3', '/api/feed/changeProfilePicture');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": 'Bearer ${globals.token}',
      "Content-Type": "application/json",
      "Accept": "application/json"
    });

    request.fields['user_id'] = user_id.toString();

    if (selectedImage != null) {
      final bytes = await selectedImage!.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);

      img.Image resized = img.copyResize(originalImage!, width: 800);
      final resizedBytes = img.encodeJpg(resized, quality: 80);
      final resizedImage = File(selectedImage!.path)
        ..writeAsBytesSync(resizedBytes);

      var file = await http.MultipartFile.fromPath('image', resizedImage.path);
      request.files.add(file);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    final data = jsonDecode(response.body);
    setState(() {
      globals.user = data['user'];
    });

    /*print(data['user']);
    print(globals.user);*/
    print(globals.user);
  }

  Future<void> storeBio() async {
    int user_id = globals.user['user_id'];

    var url = Uri.http('3.93.61.3', '/api/feed/changeProfileBio');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": 'Bearer ${globals.token}',
      "Content-Type": "application/json",
      "Accept": "application/json"
    });

    request.fields['user_id'] = user_id.toString();
    request.fields['bio'] = userBioController.text;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    final data = jsonDecode(response.body);
    print(data);
    setState(() {
      globals.user = data['user'];
    });

    setState(() {
      globals.userBio.value = globals.user['user_bio'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 72, 0, 36),
                child: Text(
                  "Edit Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () async {
                        await imageFromGallery();
                      },
                      child: selectedImage != null
                          //? Image.file(selectedImage!)
                          ? Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      color: Color.fromARGB(255, 107, 107, 107),
                                      spreadRadius: 0)
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                //backgroundImage: AssetImage('lib/imgs/cheeseprofile.PNG'),
                                backgroundImage: FileImage(selectedImage!),
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      color: Color.fromARGB(255, 107, 107, 107),
                                      spreadRadius: 0)
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Text("Select a Picture",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black)),
                              ),
                            )),
                  const SizedBox(width: 24),
                  TextButton(
                    onPressed: () async {
                      if (selectedImage != null) {
                        await storePicture();
        
                        if (!context.mounted) return;
        
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: SizedBox(
                                  height: 100,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                    child: Column(
                                      children: [
                                        const Text(
                                            "Your profile picture has been set."),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Ok"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 145, 204, 252),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    child: const Text(
                      "Set Photo",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(
                indent: 36,
                endIndent: 36,
              ),
              const SizedBox(height: 12),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                  controller: userBioController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Biography (max 150 chars)",
                  ),
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(185, 8, 0, 0),
                child: TextButton(
                  onPressed: () async {
                    await storeBio();
        
                    if (!context.mounted) return;
        
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: SizedBox(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Column(
                                  children: [
                                    const Text("Your profile bio has been set."),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Ok"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 145, 204, 252),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: const Text(
                    "Set Bio",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
