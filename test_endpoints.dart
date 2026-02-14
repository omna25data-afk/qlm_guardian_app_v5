import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final client = HttpClient();
  client.badCertificateCallback = (cert, host, port) => true;

  // Try HTTPS
  final String baseUrl =
      'https://darkturquoise-lark-306795.hostingersite.com/api';

  String? token;

  print('--- 1. Testing Login ---');
  try {
    final loginUrl = Uri.parse('$baseUrl/login');
    final request = await client.postUrl(loginUrl);
    request.headers.contentType = ContentType.json;
    request.headers.set('Accept', 'application/json');
    request.write(
      jsonEncode({
        'login_identifier': 'admin@example.com',
        'password': 'admin123',
      }),
    );

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    print('Login Status: ${response.statusCode}');
    print('Login Body: $responseBody');

    if (response.statusCode == 200) {
      final json = jsonDecode(responseBody);
      final data = json['data'] ?? json;
      token = data['token'] ?? data['access_token'];
      print('Token obtained: ${token != null ? "YES" : "NO"}');
    } else {
      print('Admin login failed. Trying Director...');
      // Retry with Director
      final request2 = await client.postUrl(loginUrl);
      request2.headers.contentType = ContentType.json;
      request2.headers.set('Accept', 'application/json');
      request2.write(
        jsonEncode({
          'login_identifier': 'director@example.com',
          'password': 'password',
        }),
      );
      final response2 = await request2.close();
      final body2 = await response2.transform(utf8.decoder).join();
      print('Director Login Status: ${response2.statusCode}');
      print('Director Login Body: $body2');

      if (response2.statusCode == 200) {
        final json = jsonDecode(body2);
        final data = json['data'] ?? json;
        token = data['token'] ?? data['access_token'];
        print('Token obtained: ${token != null ? "YES" : "NO"}');
      } else {
        print('Director login failed. Aborting tests.');
        return;
      }
    }
  } catch (e) {
    print('Login Exception: $e');
    return;
  }

  if (token == null) return;

  // Helper to make authenticated requests
  Future<void> testEndpoint(String endpoint, String name) async {
    print('\n--- Testing $name ($endpoint) ---');
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final request = await client.getUrl(url);
      request.headers.set('Authorization', 'Bearer $token');
      request.headers.set('Accept', 'application/json');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      print('Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Print first 500 chars of body to see structure
        print(
          'Structure Preview: ${responseBody.substring(0, responseBody.length > 500 ? 500 : responseBody.length)}',
        );

        final json = jsonDecode(responseBody);
        if (json is Map) {
          print('Keys: ${json.keys.toList()}');
          if (json.containsKey('data')) {
            final data = json['data'];
            print('Data type: ${data.runtimeType}');
            if (data is Map) print('Data Map Keys: ${data.keys.toList()}');
            if (data is List) print('Data List Length: ${data.length}');
          }
        }
      } else {
        print('Error Body: $responseBody');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  await testEndpoint('/admin/dashboard', 'Dashboard');
  await testEndpoint('/admin/guardians?page=1', 'Guardians');
  await testEndpoint('/admin/record-books?page=1', 'Record Books');
}
