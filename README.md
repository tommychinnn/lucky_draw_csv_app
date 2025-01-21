# Ulala Lucky Draw

A web-based lucky draw application built with Flutter. Perfect for events, giveaways, and random selections from a list of participants.

## Features

- 🎯 Random participant selection with animation
- 🎊 Celebratory fireworks animation for winners
- 🔊 Sound effects (slot machine and winner sounds)
- 📝 Two ways to input participant lists:
  - CSV file upload
  - Direct text input (one name per line)
- 🏆 Prize description for each draw
- 📋 Winners history with prizes
- 🔄 Automatic participant removal after winning
- 🌐 Bilingual interface (Chinese/English)
- 🎵 Mutable sound effects

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Web browser (Chrome recommended for development)

### Installation

1. Clone the repository:
bash
git clone https://github.com/yourusername/lucky_draw_csv_app.git

2. Navigate to the project directory:
bash
cd lucky_draw_csv_app

3. Install dependencies:
bash
flutter pub get

4. Run the application:
bash
flutter run -d chrome


### CSV File Format

The CSV file should contain a single column of names:
csv
Name
John Doe
Jane Smith
...


## Usage

1. **Upload Participant List**:
   - Click "上传名单 Upload CSV" to upload a CSV file
   - Or click "粘贴名单 Paste Names" to input names directly

2. **Set Prize Description**:
   - Enter the prize description in the text field
   - Leave blank for default "Lucky Draw"

3. **Start Drawing**:
   - Click the "抽奖 Draw" button to start
   - Wait for the animation to complete
   - Winner will be displayed with fireworks

4. **View Winners**:
   - Winners are displayed in the bottom section
   - Each winner is shown with their corresponding prize

## Project Structure
lucky_draw_csv_app/
├── lib/
│ ├── screens/
│ │ └── home_screen.dart
│ ├── widgets/
│ │ ├── animated_draw_widget.dart
│ │ ├── file_upload_widget.dart
│ │ ├── fireworks_widget.dart
│ │ └── participant_list_widget.dart
│ └── services/
│ ├── audio_service.dart
│ └── file_service.dart
├── assets/
│ ├── audio/
│ │ ├── slot_machine.mp4
│ │ └── winner.mp4
│ └── images/
│ └── logo.png
└── web/
└── index.html


## Built With

- Flutter Web
- just_audio - For sound effects
- file_picker - For CSV file handling
- csv - For CSV parsing

## Dependencies
yaml
dependencies:
flutter:
sdk: flutter
flutter_web_plugins:
sdk: flutter
file_picker: ^6.1.1
csv: ^5.1.1
path_provider: ^2.1.2
just_audio: ^0.9.36


## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.