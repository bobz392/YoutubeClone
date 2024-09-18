import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/features/auth/repository/user_data_service.dart';

final kUsernameFormKey = GlobalKey<FormState>();

class UsernamePage extends ConsumerStatefulWidget {
  final String displayName;
  final String email;
  final String profilePic;

  const UsernamePage(this.displayName, this.email, this.profilePic,
      {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UsernamePageState();
  }
}

class _UsernamePageState extends ConsumerState<UsernamePage> {
  final usernameController = TextEditingController();
  bool isValidate = true;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 14,
              ),
              child: Text(
                'Enter the username',
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                child: TextFormField(
                  key: kUsernameFormKey,
                  controller: usernameController,
                  onChanged: (username) {
                    validateUsername(username);
                  },
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    return isValidate ? null : "Username is already token";
                  },
                  decoration: InputDecoration(
                      suffixIcon: isValidate
                          ? const Icon(Icons.verified_user_rounded)
                          : const Icon(Icons.cancel),
                      suffixIconColor: isValidate ? Colors.green : Colors.red,
                      hintText: "Insert username",
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.blue,
                      )),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.green,
                      ))),
                ),
              ),
            ),
            const Spacer(),
            Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                child: ElevatedButton(
                    onPressed: () async {
                      // add data to database
                      isValidate
                          ? await ref
                              .read(userDataServiceProvider)
                              .addUserDataToFireStore(
                                  displayName: widget.displayName,
                                  username: usernameController.text,
                                  email: widget.email,
                                  profilePic: widget.profilePic,
                                  description: "description")
                          : null;
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isValidate ? Colors.green : Colors.green.shade100,
                        minimumSize: const Size.fromHeight(45),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        )),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  // features
  void validateUsername(String inputUsername) async {
    final userMaps = await FirebaseFirestore.instance.collection("users").get();
    final users = userMaps.docs.map((user) => user).toList();
    String? targetUsername;
    for (var user in users) {
      final username = user.data()["username"];
      if (inputUsername == username) {
        targetUsername = username;
        isValidate = false;
        setState(() {});
      }

      if (targetUsername != inputUsername) {
        isValidate = true;
        setState(() {});
      }
    }
  }
}
