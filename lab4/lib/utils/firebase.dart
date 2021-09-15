import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:laba3/CPU.dart';
import 'package:uuid/uuid.dart';



class FirebaseHelper {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static CollectionReference cpus =
      FirebaseFirestore.instance.collection('users');

  static Reference imagesRef = storage.ref().child('images');
  static Reference videosRef = storage.ref().child('videos');

  static Future<List<CPU>> getAllCPUs() async {
    var data = await cpus.get();
    return data.docs
        .map<CPU>((doc) => new CPU(
              doc.id,
              doc.get("model"),
              doc.get("manufacturer"),
              doc.get("frequency"),
              (doc.get("images") as List)
                  ?.map((item) => item as String)
                  ?.toList(),
              doc.get("numcores"),
              doc.get("latitude"),
              doc.get("longitude"),
              doc.get("videoUrl"),
            ))
        .toList();
  }

  static Future<void> addCPU(String model, String manufacturer,
      String frequency, List<String> images, String numcores) async {
    try {
      return await cpus.add({
        'model': model,
        'manufacturer': manufacturer,
        'frequency': frequency,
        'images': images,
        'numcores': numcores,
        'latitude': "",
        'longitude': "",
        'videoUrl': "",
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<void> updateCPU(CPU cpu) async {
    try {
      return await cpus.doc(cpu.id).update({
        'model': cpu.model,
        'manufacturer': cpu.manufacturer,
        'frequency': cpu.frequency,
        'images': cpu.images,
        'numcores': cpu.numcores,
        'latitude': cpu.latitude,
        'longitude': cpu.longitude,
        'videoUrl': cpu.videoUrl,
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<String> uploadImage(File file) async {
    try {
      Reference imageRef = imagesRef.child("${Uuid().v4()}.jpeg");
      await imageRef.putFile(file);
      return await imageRef.getDownloadURL();
    } catch (e) {
      throw e;
    }
  }

  static Future<String> uploadVideo(File file) async {
    try {
      Reference videoRef = videosRef.child("${Uuid().v4()}.mov");
      await videoRef.putFile(file);
      return await videoRef.getDownloadURL();
    } catch (e) {
      throw e;
    }
  }
}
