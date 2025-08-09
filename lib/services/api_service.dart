import 'dart:math';
import 'package:dio/dio.dart';

class ApiService {
  static late final Dio dio;
  static late final ApiService instance;

  static Future<void> initMock() async {
    dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final path = options.path;
      await Future.delayed(Duration(milliseconds: 200));
      if (path.endsWith('/api/auth/login') && options.method == 'POST') {
        final data = options.data ?? {};
        final email = data['email'] ?? 'guest@ehson.uz';
        return handler.resolve(Response(requestOptions: options, statusCode: 200, data: {
          'token': 'mock_token_${Random().nextInt(99999)}',
          'user': {'id': 1, 'name': 'Demo User', 'email': email, 'phone': '+998901234567'}
        }));
      }
      if (path.endsWith('/api/campaigns') && options.method == 'GET') {
        List campaigns = List.generate(8, (i) => {
          'id': i + 1,
          'title': 'Kampaniya #${i+1}',
          'description': 'Bu kampaniya ${i+1} uchun ma\'lumot. Yordamga muhtojlar uchun.',
          'target': 100000 + (i * 50000),
          'collected': (i+1) * 12000,
          'status': i % 2 == 0 ? 'active' : 'pending',
        });
        return handler.resolve(Response(requestOptions: options, statusCode: 200, data: {'campaigns': campaigns}));
      }
      if (path.endsWith('/api/donate') && options.method == 'POST') {
        return handler.resolve(Response(requestOptions: options, statusCode: 200, data: {'success': true, 'message': 'Ehson qabul qilindi', 'donation_id': Random().nextInt(10000)}));
      }
      if (path.endsWith('/api/user/profile') && options.method == 'GET') {
        return handler.resolve(Response(requestOptions: options, statusCode: 200, data: {
          'id': 1,
          'name': 'Demo User',
          'email': 'demo@ehson.uz',
          'phone': '+998901234567',
          'donations': [
            {'id': 1, 'campaign': 'Kampaniya #1', 'amount': 50000, 'date': DateTime.now().subtract(Duration(days:10)).toIso8601String()},
            {'id': 2, 'campaign': 'Kampaniya #3', 'amount': 20000, 'date': DateTime.now().subtract(Duration(days:40)).toIso8601String()},
          ]
        }));
      }
      if (path.endsWith('/api/statistics') && options.method == 'GET') {
        return handler.resolve(Response(requestOptions: options, statusCode: 200, data: {
          'total_donations': 523000,
          'monthly': List.generate(6, (i) => {'month': i+1, 'amount': (i+1)*40000}),
          'top_donors': [{'name':'Ali','amount':70000},{'name':'Gulbahor','amount':50000}]
        }));
      }
      if (path.endsWith('/api/request-aid') && options.method == 'POST') {
        return handler.resolve(Response(requestOptions: options, statusCode: 201, data: {'success': true, 'request_id': Random().nextInt(9999), 'status': 'pending'}));
      }
      return handler.resolve(Response(requestOptions: options, statusCode: 404, data: {'message': 'Mock route not found ' + path}));
    }));
    instance = ApiService._internal();
  }

  ApiService._internal();

  Future<Response> post(String path, [Map<String, dynamic>? data]) => dio.post(path, data: data);
  Future<Response> get(String path, [Map<String, dynamic>? query]) => dio.get(path, queryParameters: query);
}
