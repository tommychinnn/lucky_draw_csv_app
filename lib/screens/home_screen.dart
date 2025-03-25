import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/file_service.dart';
import '../services/language_service.dart';
import '../widgets/file_upload_widget.dart';
import '../widgets/participant_list_widget.dart';
import '../widgets/animated_draw_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';

@JS('switchLanguage')
external void switchLanguageJS(String lang);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> participants = [];
  List<Winner> winners = [];
  bool isLoading = false;
  final TextEditingController _prizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen for language changes from JavaScript
    if (kIsWeb) {
      // Add JavaScript event listener for language changes
      js.context['flutter_inappwebview']?.callHandler = allowInterop((String name, dynamic args) {
        if (name == 'switchLanguage') {
          final lang = args[0] as String;
          Provider.of<LanguageService>(context, listen: false).setLanguage(lang);
        }
      });
    }
  }

  @override
  void dispose() {
    _prizeController.dispose();
    super.dispose();
  }

  void onFileUploaded(List<String> names) {
    setState(() {
      participants = names;
      winners = [];
      _prizeController.clear();
    });
  }

  void onWinnerSelected(String winner, String prize) {
    setState(() {
      final prizeDescription = _prizeController.text.isEmpty 
          ? context.read<LanguageService>().translate('luckyDraw')
          : _prizeController.text;
      winners.add(Winner(name: winner, prize: prizeDescription));
      participants.remove(winner);
    });
  }

  void handleUploadCSV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      try {
        final names = await FileService.readCSV(result.files.first);
        onFileUploaded(names);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  void handlePasteNames() {
    final languageService = context.read<LanguageService>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageService.translate('pasteNamesTitle')),
        content: TextField(
          maxLines: 8,
          decoration: InputDecoration(
            hintText: languageService.translate('pasteNamesHint'),
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            // Split the pasted text into lines and remove empty lines
            final names = value
                .split('\n')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            onFileUploaded(names);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.translate('ok')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final winnersListHeight = screenHeight * 0.6;
    final languageService = context.watch<LanguageService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              'Wulala Lucky Draw',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 60),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              margin: const EdgeInsets.only(right: 8),
                              child: ElevatedButton(
                                onPressed: () => handleUploadCSV(),
                                child: Text(languageService.translate('uploadCSV')),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 48,
                              margin: const EdgeInsets.only(left: 8),
                              child: ElevatedButton(
                                onPressed: () => handlePasteNames(),
                                child: Text(languageService.translate('pasteNames')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      participants.isEmpty 
                          ? languageService.translate('pleaseUpload')
                          : '${languageService.translate('participants')}: ${participants.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE31837),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _prizeController,
                      enabled: participants.isNotEmpty,
                      decoration: InputDecoration(
                        labelText: languageService.translate('prizeDescription'),
                        border: const OutlineInputBorder(),
                        hintText: languageService.translate('prizeHint'),
                        filled: participants.isEmpty,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (participants.isEmpty)
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.grey[100]!,
                              Colors.white,
                              Colors.grey[100]!,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '等待抽奖 Waiting for Draw',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      AnimatedDrawWidget(
                        participants: participants,
                        onWinnerSelected: onWinnerSelected,
                        prizeDescription: _prizeController.text.isEmpty 
                            ? context.read<LanguageService>().translate('luckyDraw')
                            : _prizeController.text,
                        animationDuration: const Duration(seconds: 5),
                      ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      child: winners.isEmpty
                          ? const Center(
                              child: Text(
                                '🎊 获奖者 Winners 🎊\n\n等待抽奖结果 Waiting for Winners',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ParticipantListWidget(
                              title: '🎊 获奖者 Winners 🎊',
                              winners: winners,
                            ),
                    ),
                    const SizedBox(height: 20),

                    // Add Google Ads
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const HtmlElementView(
                        viewType: 'google-ads',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Copyright footer
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '© 2024 Wulala Lucky Draw. All Rights Reserved.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE31837),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),  // Small spacing between lines
                          Text(
                            'Developed by Tommy Chin',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFE31837),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Winner {
  final String name;
  final String prize;

  Winner({required this.name, required this.prize});
} 