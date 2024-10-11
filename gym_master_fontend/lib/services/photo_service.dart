import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gym_master_fontend/model/PhotoProgressModel.dart';
import 'package:gym_master_fontend/model/ProgressCompareLatestModel.dart';
import 'package:gym_master_fontend/model/ProgressCompareModel.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

class PhotoService {
  String url = AppConstants.BASE_URL;
  final dio = Dio();
  Future<int> insertProgress(
      int uid, XFile imagePath, String weight, String tokenJwt) async {
    final dateNow = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy').format(dateNow);
    try {
      final file = File(imagePath.path);
      Uint8List compressedImage = await compressImage(file,
          quality: 70, maxWidth: 600); // อ่านไฟล์เป็น Bytes

      MultipartFile multipartFile = MultipartFile.fromBytes(
        compressedImage,
        filename: "${formattedDate}_$uid.jpg",
        contentType: MediaType("image", "jpg"),
      );

      // MultipartFile multipartFile = await MultipartFile.fromFile(
      //   file.path,
      //   filename: "${formattedDate}_$uid.jpg",
      //   contentType: MediaType("image", "jpg"),
      // );
      FormData formData = FormData.fromMap(
          {"uid": uid, "weight": double.parse(weight), "file": multipartFile});

      log("FormData: ${formData.fields}");
      final headers = {
        'Authorization': 'Bearer $tokenJwt',
        'Content-Type': 'multipart/form-data',
      };

      final response = await dio.post("$url/photo/insertProgress",
          data: formData,
          options: Options(
            headers: headers,
            validateStatus: (status) {
              return status! < 500;
            },
          ));

      if (response.statusCode == 200) {
        return 1;
      } else {
        log("statuscode = ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      throw Exception('Failed to load stutus: $e');
    }
  }

  Future<List<PhotoProgressModel>> getPhotoPregress(
      int uid, String tokenJwt) async {
    try {
      final response = await dio.get(
        '$url/progress/getProgressUser/$uid',
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJwt',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      // final List<dynamic> data = response.data;
      // log("progress Data: ${response.data}");
      if (response.data is List) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          return data.map((e) => PhotoProgressModel.fromJson(e)).toList();
        } else {
          return [];
        }
      } else if (response.data is Map && response.data.containsKey("error")) {
        log("Error: ${response.data["error"]}");
        return [];
      } else {
        throw Exception('Unexpected response format: ${response.data}');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load photo Progress: $e');
    }
  }

  Future<int> deleteImage(int uid, int pid, String tokenJwt) async {
    var json = {
      "uid": uid,
      "pid": pid,
    };

    try {
      final response = await dio.post(
        "$url/progress/deleteImageProgress",
        data: json,
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJwt',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      throw Exception('Failed to delete photo Progress: $e');
    }
  }

  Future<int> setBeforeImageProgress(int uid, int pid, String tokenJwt) async {
    var json = {
      "uid": uid,
      "pid": pid,
    };

    try {
      final response = await dio.post(
        '$url/progress/setBefore',
        data: json,
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJwt',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      throw Exception('Failed to set Before image Progress: $e');
    }
  }

  Future<List<ProgressCompareLatestModel>> getLatestProgress(
      int uid, String tokenJwt) async {
    try {
      final response = await dio.get(
        '$url/progress/getLatestProgress/$uid',
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJwt',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        // ตรวจสอบข้อมูลที่ได้รับว่าเป็น List หรือไม่
        if (response.data is List) {
          final List<dynamic> data = response.data;
          return data
              .map((e) => ProgressCompareLatestModel.fromJson(e))
              .toList();
        } else {
          // ถ้าไม่ใช่ List ให้แสดง Error ขึ้นมา
          throw Exception(
              'Expected a List but got ${response.data.runtimeType}');
        }
      } else {
        return [];
      }
    } catch (e) {
      log("check get latest $e");
      throw Exception('Failed to get latest image Progress: $e');
    }
  }

  Future<List<ProgressCompareModel>> getBeforeProgress(
      int uid, String tokenJwt) async {
    try {
      final response = await dio.get(
        '$url/progress/getBeforeProgress/$uid',
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJwt',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ProgressCompareModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get before image Progress: $e');
    }
  }

  Future<Uint8List> compressImage(File file,
      {int quality = 70, int maxWidth = 600}) async {
    // อ่านไฟล์รูปภาพจาก path
    Uint8List imageBytes = await file.readAsBytes();

    // แปลง bytes ให้เป็นรูปภาพของแพ็กเกจ `image`
    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      // ปรับขนาดรูปภาพตาม maxWidth และอัตราส่วนเดิม
      img.Image resizedImage = img.copyResize(image, width: maxWidth);

      // บีบอัดรูปภาพเป็น JPG พร้อมกำหนดคุณภาพตามค่า `quality`
      return Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));
    }

    // กรณีไม่สามารถ decode รูปภาพได้ คืนค่าไฟล์เดิม
    return imageBytes;
  }
}
