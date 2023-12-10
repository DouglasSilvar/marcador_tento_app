import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_session/audio_session.dart' as audio_session;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = await audio_session.AudioSession.instance;
  await session.configure(const audio_session.AudioSessionConfiguration(
    avAudioSessionCategory: audio_session.AVAudioSessionCategory.playAndRecord,
    avAudioSessionCategoryOptions:
        audio_session.AVAudioSessionCategoryOptions.mixWithOthers,
    avAudioSessionMode: audio_session.AVAudioSessionMode.defaultMode,
    avAudioSessionRouteSharingPolicy:
        audio_session.AVAudioSessionRouteSharingPolicy.defaultPolicy,
    avAudioSessionSetActiveOptions:
        audio_session.AVAudioSessionSetActiveOptions.none,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador de Tentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '♣️ ♥️ CONTADOR DE TENTOS ♠️ ♦️'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _nosCounter = 0;
  int _elesCounter = 0;
  File? _nosImage;
  File? _elesImage;
  String _centralButtonText = 'TRUCO !!!';
  bool _isTrucoVisible = false;

  final Random _random = Random();

  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playRandomTrucoSound() {
    int randomNumber = _random.nextInt(7) + 1;
    _audioPlayer
        .play(AssetSource('audios/$randomNumber.mp3'))
        .catchError((error) {
      print('Error playing random truco sound: $error');
    });
  }

  void _playRandomSeisSound() {
    int randomNumber = _random.nextInt(7) + 61;
    _audioPlayer
        .play(AssetSource('audios/$randomNumber.mp3'))
        .catchError((error) {
      print('Error playing random truco sound: $error');
    });
  }

  void _playRandomNoveSound() {
    int randomNumber = _random.nextInt(7) + 1;
    _audioPlayer
        .play(AssetSource('audios/$randomNumber.mp3'))
        .catchError((error) {
      print('Error playing random truco sound: $error');
    });
  }

  void _playRandomDozeSound() {
    int randomNumber = _random.nextInt(7) + 1;
    _audioPlayer
        .play(AssetSource('audios/$randomNumber.mp3'))
        .catchError((error) {
      print('Error playing random truco sound: $error');
    });
  }

  void _playRandomCorroSound() {
    int randomNumber = _random.nextInt(7) + 1;
    _audioPlayer
        .play(AssetSource('audios/$randomNumber.mp3'))
        .catchError((error) {
      print('Error playing random truco sound: $error');
    });
  }

  void _handleButtonPress(String buttonPressed) {
    setState(() {
      if (buttonPressed == 'CORRO ...') {
        _isTrucoVisible = false;
        _centralButtonText = 'TRUCO !!!';
      } else if (buttonPressed == 'TRUCO !!!') {
        _playRandomTrucoSound();
        _isTrucoVisible = true;
      } else if (buttonPressed == 'SEIS !!!' &&
          _centralButtonText == 'TRUCO !!!') {
        _centralButtonText = 'SEIS !!!';
        _playRandomSeisSound();
      } else if (buttonPressed == 'SEIS !!!' &&
          _centralButtonText == 'SEIS !!!') {
        _playRandomSeisSound();
      } else if (buttonPressed == 'NOVE !!!' &&
          _centralButtonText == 'SEIS !!!') {
        _centralButtonText = 'NOVE !!!';
      } else if (buttonPressed == 'DOZE !!!' &&
          _centralButtonText == 'NOVE !!!') {
        _centralButtonText = 'DOZE !!!';
        _isTrucoVisible = false;
      }
    });
  }

  Future<void> _pickImage(bool isNos) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        if (isNos) {
          _nosImage = File(image.path);
        } else {
          _elesImage = File(image.path);
        }
      });
    }
  }

  void _incrementCounter(bool isNos) {
    setState(() {
      if (isNos) {
        if (_nosCounter < 12) _nosCounter++;
      } else {
        if (_elesCounter < 12) _elesCounter++;
      }
    });
  }

  void _decrementCounter(bool isNos) {
    setState(() {
      if (isNos) {
        if (_nosCounter > 0) _nosCounter--;
      } else {
        if (_elesCounter > 0) _elesCounter--;
      }
    });
    _playDecrementSound();
  }

  void _playDecrementSound() {
    _audioPlayer.play(AssetSource('audios/x.mp3')).catchError((error) {
      print('Error playing decrement sound: $error');
    });
  }

  Widget _buildTeamColumn(String teamName, int score, bool isNos) {
    File? teamImage = isNos ? _nosImage : _elesImage;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          teamName,
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _pickImage(isNos),
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            backgroundImage: teamImage != null ? FileImage(teamImage) : null,
            radius: 60,
            child: teamImage == null
                ? const Icon(Icons.camera_alt, size: 60, color: Colors.black)
                : null,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 90,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.add, size: 30, color: Colors.white),
                ),
                onPressed: () => _incrementCounter(isNos),
              ),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.remove, size: 30, color: Colors.white),
                ),
                onPressed: () => _decrementCounter(isNos),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
            child: Text(widget.title,
                style: const TextStyle(color: Colors.white))),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildTeamColumn('Nós', _nosCounter, true),
            _buildTeamColumn('Eles', _elesCounter, false),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (_isTrucoVisible || _centralButtonText != 'TRUCO !!!')
              _buildActionButton('CORRO ...'),
            _buildActionButton(_centralButtonText),
            if (_isTrucoVisible && _centralButtonText != 'DOZE !!!')
              _buildActionButton(_centralButtonText == 'TRUCO !!!'
                  ? 'SEIS !!!'
                  : _centralButtonText == 'SEIS !!!'
                      ? 'NOVE !!!'
                      : 'DOZE !!!'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return ElevatedButton(
      onPressed: () => _handleButtonPress(text),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
