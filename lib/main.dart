import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
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
          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _pickImage(isNos),
          child: CircleAvatar(
            backgroundColor:
                Colors.grey[300], // Fundo cinza para o ícone da câmera
            backgroundImage: teamImage != null
                ? FileImage(teamImage)
                : null, // Ícone da câmera preto
            radius: 60,
            child: teamImage == null
                ? const Icon(Icons.camera_alt, size: 60, color: Colors.black)
                : null,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width:
              90, // Aumentando a largura do Container (ajuste este valor conforme necessário)
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.red, // Fundo vermelho para o ícone +
                  child: Icon(Icons.add,
                      size: 30, color: Colors.white), // Ícone + branco
                ),
                onPressed: () => _incrementCounter(isNos),
              ),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.black, // Fundo preto para o ícone -
                  child: Icon(Icons.remove,
                      size: 30, color: Colors.white), // Ícone - branco
                ),
                onPressed: () => _decrementCounter(isNos),
              ),
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
                style: const TextStyle(
                    color: Colors.white))), // Centralizando o título
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
        child: TextButton(
          onPressed: _playRandomTrucoSound,
          child: const Text('TRUCO!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30)), // Aumentando o texto "TRUCO!"
        ),
      ),
    );
  }
}
