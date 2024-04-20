import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'Signature.dart';

class RekognitionHandler {
  late String _accessKey, _secretKey;
  final String _region = 'us-west-2';

  RekognitionHandler(){
    _accessKey = dotenv.env['PUBLIC'] ?? "";
    _secretKey = dotenv.env['SECRET'] ?? "";

    if (_accessKey == "" || _accessKey == "") {
      print('Access key not found');
    }
  }

  Future<String> _rekognitionHttp(String amzTarget, String body) async {
    String endpoint = "https://rekognition.$_region.amazonaws.com/";
    String host = "rekognition.$_region.amazonaws.com";
    String httpMethod = "POST";
    String service = "rekognition";

    var now = DateTime.now().toUtc();
    var amzFormatter = DateFormat("yyyyMMdd'T'HHmmss'Z'");
    String amzDate =
        amzFormatter.format(now); // format should be '20170104T233405Z"

    var dateFormatter = DateFormat('yyyyMMdd');
    String dateStamp = dateFormatter.format(
        now); // Date w/o time, used in credential scope. format should be "20170104"

    int bodyLength = body.length;

    String queryStringParamters = "";
    Map<String, String> headerParamters = {
      "content-length": bodyLength.toString(),
      "content-type": "application/x-amz-json-1.1",
      "host": host,
      "x-amz-date": amzDate,
      "x-amz-target": amzTarget
    };

    String signature = Signature.generateSignature(
        endpoint,
        service,
        _region,
        _secretKey,
        httpMethod,
        now,
        queryStringParamters,
        headerParamters,
        body);

    String authorization =
        "AWS4-HMAC-SHA256 Credential=$_accessKey/$dateStamp/$_region/$service/aws4_request, SignedHeaders=content-length;content-type;host;x-amz-date;x-amz-target, Signature=$signature";
    headerParamters.putIfAbsent('Authorization', () => authorization);

    //String labelsArray = "";
    StringBuffer builder = StringBuffer();
    try {
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(endpoint));

      request.headers.set('content-length', headerParamters['content-length'] as Object);
      request.headers.set('content-type', headerParamters['content-type'] as Object);
      request.headers.set('host', headerParamters['host'] as Object);
      request.headers.set('x-amz-date', headerParamters['x-amz-date'] as Object);
      request.headers.set('x-amz-target', headerParamters['x-amz-target'] as Object);
      request.headers.set('Authorization', headerParamters['Authorization'] as Object);

      request.write(body);

      HttpClientResponse response = await request.close();

      await for (String a in utf8.decoder.bind(response)) {
        builder.write(a);
      }
    } catch (e) {
      print(e);
    }

    return Future.value(builder.toString());
  }

  Future<String> detectBooks(File imageFile) async {
    try {
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      String body = '{"Image":{"Bytes": "$base64Image"}}';
      String amzTarget = "RekognitionService.DetectLabels";

      String response = await _rekognitionHttp(amzTarget, body);
      return response;
    } catch (e) {
      print(e);
      return "{}";
    }
  }

  Future<String> detectTexts(File imageFile) async {
    try{
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      String body = '{"Image":{"Bytes": "$base64Image"}}';
      String amzTarget = "RekognitionService.DetectText";

      String response = await _rekognitionHttp(amzTarget, body);
      return response;
    } catch (e) {
      print(e);
      return "{}";
    }
  }

}
