import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/Modules/Gallery/view.dart';
import 'package:gallery_app/Modules/Picker/controller.dart';
import 'package:get/get.dart';

class UploadScreen extends StatelessWidget {
  final controller = Get.put(UploadController());
  @override
  Widget build(BuildContext context) {
    return Obx( () {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Gallery App"),
            actions: [
              IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GalleryScreen()));
                  })
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.selectFileToUpload();
            },
            child: const Icon(Icons.add),
          ),
          body: controller.uploadedTasks.value.isEmpty
              ? const Center(
                  child: Text("Please tap on add button to upload images"))
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return StreamBuilder<TaskSnapshot>(
                      builder: (context, snapShot) {
                        return snapShot.hasError
                            ? const Text("There is some error in uploading file")
                            : snapShot.hasData
                                ? ListTile(
                                    title: Text(
                                        "${snapShot.data!.bytesTransferred}/${snapShot.data!.totalBytes} ${snapShot.data!.state == TaskState.success ? "Completed" : snapShot.data!.state == TaskState.running ? "In Progress" : "Error"}"),
                                  )
                                : Container();
                      },
                      stream: controller.uploadedTasks[index].snapshotEvents,
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: controller.uploadedTasks.value.length,
                ),
        );
      }
    );
  }
}
