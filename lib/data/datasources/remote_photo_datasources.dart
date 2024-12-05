import 'dart:convert';

import 'package:fd_log/fd_log.dart';
import 'package:photoidea_app/core/api_key.dart';
import 'package:photoidea_app/core/apis.dart';
import 'package:photoidea_app/core/di.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:http/http.dart' as http;

class RemotePhotoDatasources {
  static Future<(bool, String, List<PhotoModel>?)> fetchCurrated(
    int page,
    int perPage,
  ) async {
    final url = '${APIs.pexelBaseUrl}/curated?page=$page&per_page=$perPage';
    const headers = {
      'Authorization': APIKeys.pexels,
    };
    try {
      final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    sl<FDLog>().response(response);
  
    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      final rawPhotos = List.from(resBody['photos']);

      final photos = rawPhotos.map((json) {
        return PhotoModel.fromJson(json);
      }).toList();

      return (true, 'Fetch Success!!', photos);
    }

    return (false, 'fetch gagal', null);
    } catch (e){
    sl<FDLog>().basic(e.toString());
      
    return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, List<PhotoModel>?)> search(
    String query,
    int page,
    int perPage,
  ) async {
    final url = '${APIs.pexelBaseUrl}/search?query=$query&page=$page&per_page=$perPage';
    const headers = {
      'Authorization': APIKeys.pexels,
    };
    try {
      final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    sl<FDLog>().response(response);
  
    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      final rawPhotos = List.from(resBody['photos']);
      final photos = rawPhotos.map((json) {
        return PhotoModel.fromJson(json);
      }).toList();

      return (true, 'Fetch Success!!', photos);
    }
    if(response.statusCode == 404){
      return (false, 'Not Found', null);
    }

    return (false, 'search gagal', null);
    } catch (e){
    sl<FDLog>().basic(e.toString());
      
    return (false, 'Something went wrong', null);
    }
  }


  static Future<(bool, String, PhotoModel?)> fetchByid(
    int id,
    
  ) async {
    final url = '${APIs.pexelBaseUrl}/photos/$id';
    const headers = {
      'Authorization': APIKeys.pexels,
    };
    try {
      final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    sl<FDLog>().response(response);
  
    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      
      final photo = PhotoModel.fromJson(resBody);

      return (true, 'Fetch Success!!', photo);
    }
    if(response.statusCode == 404){
      return (false, 'Not Found', null);
    }

    return (false, 'fetch gagal', null);
    } catch (e){
    sl<FDLog>().basic(e.toString());
      
    return (false, 'Something went wrong', null);
    }
  }

}


