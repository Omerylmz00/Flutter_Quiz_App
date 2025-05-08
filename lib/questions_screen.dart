import 'package:adv_basics/answer_button.dart';
import 'package:adv_basics/models/quiz_question.dart';
import 'package:adv_basics/services/api_services.dart';
import 'package:flutter/material.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final GeminiService _apiService = GeminiService();

  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    try {
      final data = await _apiService.fetchQuizQuestions();

      setState(() {
        _questions = data.map((item) => QuizQuestion.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('HATA: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void answerQuestion() {
    setState(() {
      _currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError || _questions.isEmpty) {
      return const Center(child: Text("Sorular yüklenemedi."));
    }

    if (_currentQuestionIndex >= _questions.length) {
      return const Center(child: Text("Quiz tamamlandı!"));
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...currentQuestion.getShuffledAnswers().map((answer) {
              return AnswerButton(
                answerText: answer,
                onTap: answerQuestion,
              );
            })
          ],
        ),
      ),
    );
  }
}
