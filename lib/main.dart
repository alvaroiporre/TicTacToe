import 'package:flutter/material.dart';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> _board =
      List<List<String>>.generate(3, (_) => List<String>.filled(3, ''));
  bool _player1Turn = true;
  String _currentPlayer = 'X';
  bool _gameEnded = false;
  bool _tie = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _board = List<List<String>>.generate(3, (_) => List<String>.filled(3, ''));
    _player1Turn = true;
    _currentPlayer = 'X';
    _gameEnded = false;
    _tie = false;
  }

  void _makeMove(int row, int col) {
    if (!_gameEnded && _board[row][col] == '') {
      setState(() {
        _board[row][col] = _currentPlayer;
        _checkGameStatus();
        _togglePlayer();
      });
    }
  }

  void _checkGameStatus() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _currentPlayer &&
          _board[i][1] == _currentPlayer &&
          _board[i][2] == _currentPlayer) {
        _gameEnded = true;
        break;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_board[0][i] == _currentPlayer &&
          _board[1][i] == _currentPlayer &&
          _board[2][i] == _currentPlayer) {
        _gameEnded = true;
        break;
      }
    }

// Check diagonals
    if ((_board[0][0] == _currentPlayer &&
            _board[1][1] == _currentPlayer &&
            _board[2][2] == _currentPlayer) ||
        (_board[0][2] == _currentPlayer &&
            _board[1][1] == _currentPlayer &&
            _board[2][0] == _currentPlayer)) {
      _gameEnded = true;
    }

// Check for a tie
    if (!_board.any((row) => row.contains('')) && !_gameEnded) {
      _tie = true;
      _gameEnded = true;
    }

// Display game over message
    if (_gameEnded) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text(_tie
                ? "There is a TIE"
                : (_currentPlayer == 'X'
                    ? 'Player O Wins!'
                    : 'Player X Wins!')),
            actions: [
              TextButton(
                child: Text('New Game'),
                onPressed: () {
                  setState(() {
                    _startNewGame();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _togglePlayer() {
    _player1Turn = !_player1Turn;
    _currentPlayer = _player1Turn ? 'X' : 'O';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () => _makeMove(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        _board[row][col],
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _startNewGame();
                });
              },
              child: const Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
