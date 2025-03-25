import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  String _currentLanguage = 'en';
  String get currentLanguage => _currentLanguage;

  final Map<String, Map<String, String>> _translations = {
    'en': {
      'uploadCSV': 'Upload CSV',
      'pasteNames': 'Paste Names',
      'pleaseUpload': 'Please Upload Namelist',
      'participants': 'Participants',
      'prizeDescription': 'Prize Description',
      'prizeHint': 'Example: First Prize - iPhone 15 Pro Max',
      'ok': 'OK',
      'pasteNamesTitle': 'Paste Names',
      'pasteNamesHint': 'Example:\nJohn\nMary\nPeter\nSarah',
    },
    'zh': {
      'uploadCSV': '上传表格',
      'pasteNames': '粘贴名单',
      'pleaseUpload': '请上传表格',
      'participants': '参与者',
      'prizeDescription': '奖品描述',
      'prizeHint': '例如: 一等奖 - iPhone 15 Pro Max',
      'ok': '确定',
      'pasteNamesTitle': '粘贴名单',
      'pasteNamesHint': '例如:\n张三\n李四\n王五\n赵六',
    },
  };

  String translate(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }

  void setLanguage(String language) {
    if (_currentLanguage != language && _translations.containsKey(language)) {
      _currentLanguage = language;
      notifyListeners();
    }
  }
} 