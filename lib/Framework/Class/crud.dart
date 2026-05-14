import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:uninotify_project/Framework/Class/statusrequest.dart';
import 'package:uninotify_project/Framework/Funcution/checkInternet.dart';

class Crud {
  Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
    try {
      if (!await checkInternet()) {
        return const Left(StatusRequest.offlineFailure);
      }

      // ✅ حوّلي البيانات لـ Map<String,String> عشان تكون Form صحيحة 100%
      final Map<String, String> body = data.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );

      final response = await http.post(
        Uri.parse(linkurl),
        body: body, // ✅ form-urlencoded
        headers: {
          "Accept": "application/json",
          
        },
      );

      // ✅ اطبعي التشخيص
      print("🌐 POST => $linkurl");
      print("📨 BODY => $body");
      print("📡 STATUS => ${response.statusCode}");
      print("🧾 RAW => ${response.body}");

      // ✅ حتى لو مو 200، رجّعي serverFailure (بس الآن بتعرفي السبب من RAW)
      if (response.statusCode != 200 && response.statusCode != 201) {
        return const Left(StatusRequest.serverFailure);
      }

      // ✅ جرّبي تفكيك JSON بشكل آمن
      final decoded = jsonDecode(response.body);

      if (decoded is Map) {
        return Right(decoded);
      } else {
        // لو رجع JSON لكن مش Map
        return Right(
            {"status": false, "message": "Unexpected response format"});
      }
    } catch (e) {
      // ✅ اطبعي الاستثناء الحقيقي
      print("❌ Crud Exception => $e");
      return const Left(StatusRequest.serverFailure);
    }
  }
}
