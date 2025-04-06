class QuizQuestion {
  const QuizQuestion(this.text, this.answers);

  final String text;
  final List<String> answers;

  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers); // Create a copy of the answers list
    shuffledList.shuffle(); // Shuffle the copied list
    return shuffledList; // Return the shuffled list
    // This way, the original answers list remains unchanged.
  }
}
