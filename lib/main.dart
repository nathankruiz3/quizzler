import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';

// package to create a Alert when the game is finished
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text(
            'Quizzler',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // holds the icons created when an answer is chosen
  List<Icon> scoreKeeper = [];
  // holds the value of correct answers for displaying
  // the percentage at the end of the game
  List<bool> rightAns = [];

  // function to check if the users answer was correct
  void checkAnswer(bool userAnswer) {
    bool correctAnswer = quizBrain.getAnswer();
    setState(() {
      // First checking if the game is finshed
      if (quizBrain.isFinished()) {
        // string to hold the percentage value of how
        // many answers the user got right
        String percentage = ((rightAns.length / 13) * 100).toStringAsFixed(0);
        // Create the alert if the game is finshed
        Alert(
          context: context,
          title: 'Finished!',
          desc: 'You\'ve reached the end of the quiz with $percentage%.',
        ).show();
        // call the reset function from quizBrain to go back to question 1
        quizBrain.reset();
        // clear the scorekeeper
        scoreKeeper = [];
        // clear the amount of correct answers
        rightAns = [];
      }
      // runs if the game isn't finished
      else {
        // check if the answer is correct
        if (correctAnswer == userAnswer) {
          // if it is correct, display a green checkmark Icon
          scoreKeeper.add(Icon(
            Icons.check,
            color: Colors.green,
          ));
          // add a value to the right answers
          rightAns.add(true);
        }
        // if the answer is wrong
        else {
          // display a red x Icon
          scoreKeeper.add(Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        // go to the next question
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: scoreKeeper)
      ],
    );
  }
}
