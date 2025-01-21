import 'package:flutter/material.dart';
import '../services/file_service.dart';
import '../widgets/file_upload_widget.dart';
import '../widgets/participant_list_widget.dart';
import '../widgets/animated_draw_widget.dart';

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
          ? '幸运抽奖 Lucky Draw' 
          : _prizeController.text;
      winners.add(Winner(name: winner, prize: prizeDescription));
      participants.remove(winner);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final winnersListHeight = screenHeight * 0.6;

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
              'Ulala Lucky Draw',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FileUploadWidget(onFileUploaded: onFileUploaded),
              const SizedBox(height: 20),
              Text(
                participants.isEmpty 
                    ? '请上传名单 Please Upload Namelist'
                    : '参与者 Participants: ${participants.length}',  // Added English
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
                  labelText: '奖品描述 Prize Description',
                  border: const OutlineInputBorder(),
                  hintText: '例如: 一等奖 - iPhone 15 Pro Max',
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
                      ? '幸运抽奖 Lucky Draw' 
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
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: winners.isEmpty ? 100 : winnersListHeight,
                    minHeight: 100,
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
              ),
              const SizedBox(height: 20),
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