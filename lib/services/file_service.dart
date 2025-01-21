import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

class FileService {
  static Future<List<String>> readCSV(PlatformFile file) async {
    try {
      final String fileContent = String.fromCharCodes(file.bytes!);
      final List<List<dynamic>> rowsAsListOfValues = 
          const CsvToListConverter().convert(fileContent);

      // Extract names from the first column
      final List<String> names = rowsAsListOfValues
          .map((row) => row.isNotEmpty ? row[0].toString().trim() : '')
          .where((name) => name.isNotEmpty)
          .toList();

      if (names.isEmpty) {
        throw Exception('No valid names found in the CSV file');
      }

      return names;
    } catch (e) {
      throw Exception('Error reading CSV file: ${e.toString()}');
    }
  }
} 