import 'package:flutter/material.dart';
import 'dart:async'; // Required for Timer

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 50; // Advanced Feature 2: Energy State
  Timer? _gameTimer;
  int _winDuration = 0; // Tracks seconds for win condition
  bool _gameOver = false;
  
  // Controller for the name input field
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start the game timer
    _startGameTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel(); // Prevent memory leaks
    _nameController.dispose();
    super.dispose();
  }

  // Timer handles Auto-Hunger (Part 1) and Win/Loss checking
  void _startGameTimer() {
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_gameOver) {
        timer.cancel();
        return;
      }

      setState(() {
        // Increase hunger every 30 seconds
        if (timer.tick % 30 == 0) {
          hungerLevel = (hungerLevel + 5).clamp(0, 100);
          _checkLossCondition();
        }

        // Win Condition: Happiness > 80 for 3 minutes (180 seconds)
        if (happinessLevel > 80) {
          _winDuration++;
          if (_winDuration >= 180) { // 3 minutes
            _gameOver = true;
            _showDialog("You Won!", "You kept your pet happy for 3 minutes!");
          }
        } else {
          _winDuration = 0; // Reset if happiness drops
        }
      });
    });
  }

  void _checkLossCondition() {
    // Loss: Hunger 100 AND Happiness 10
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      setState(() {
        _gameOver = true;
      });
      _showDialog("Game Over", "Your pet is too hungry and unhappy.");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper to update Name (Part 1)
  void _updateName() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        petName = _nameController.text;
      });
    }
  }

  // Logic for Playing
  void _playWithPet() {
    if (_gameOver) return;
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      // Advanced Feature 2: Playing decreases energy
      energyLevel = (energyLevel - 10).clamp(0, 100);
      _updateHunger();
    });
  }

  // Logic for Feeding
  void _feedPet() {
    if (_gameOver) return;
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      // Advanced Feature 2: Feeding restores energy slightly
      energyLevel = (energyLevel + 5).clamp(0, 100); 
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel >= 100) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Part 1: Mood Indicator Logic
  String _getMoodText() {
    if (happinessLevel > 70) return "Happy 😃";
    if (happinessLevel >= 30) return "Neutral 😐";
    return "Unhappy 😢";
  }

  // Part 1: Dynamic Color Logic
  Color _getMoodColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Part 1: Image with ColorFilter
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    _getMoodColor(),
                    BlendMode.modulate,
                  ),
                  child: Image.asset(
                    'assets/pet_image.png', 
                    height: 200,
                    width: 200,
                    errorBuilder: (context, error, stackTrace) {
                       return Container(
                         height: 200, 
                         width: 200, 
                         color: Colors.grey, 
                         child: Center(child: Text("Image Not Found")),
                       );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                
                // Part 1: Mood Indicator
                Text(
                  'Mood: ${_getMoodText()}',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),

                Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
                
                // Part 1: Name Customization Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(hintText: "Enter new name"),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: _updateName,
                      )
                    ],
                  ),
                ),
                
                SizedBox(height: 16.0),
                Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
                Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
                
                // Advanced Feature 1: Energy Bar
                SizedBox(height: 16.0),
                Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 8.0),
                LinearProgressIndicator(
                  value: energyLevel / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 10,
                ),

                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _playWithPet,
                  child: Text('Play with Your Pet'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _feedPet,
                  child: Text('Feed Your Pet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}