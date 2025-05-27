import 'dart:convert';
import 'dart:io';

void main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
  print('✅ Dart server running at http://0.0.0.0:3000');

  await for (HttpRequest request in server) {
    if (request.method == 'POST' &&
        (request.uri.path == '/attendance/checkin' || request.uri.path == '/attendance/checkout')) {
      final action = request.uri.pathSegments.last;
      final body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body);

      final studentId = data['studentId'];
      final classId = data['classId'];
      final timestamp = data['timestamp'];
      final latitude = data['latitude'];
      final longitude = data['longitude'];

      print('📥 $action from $studentId for $classId at $timestamp');
      print('📍 Location: $latitude, $longitude');

      request.response
        ..statusCode = HttpStatus.ok
        ..write('$action successful')
        ..close();
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Endpoint not found')
        ..close();
    }
  }
}
