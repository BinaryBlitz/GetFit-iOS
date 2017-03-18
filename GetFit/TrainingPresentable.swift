protocol TrainingPresentable {
  var trainingTitle: String { get }
  var trainingInfo: String { get }
  var trainingExercisesCount: String { get }
  var trainingDurationString: String { get }
  var trainingDateString: String { get }
  var completed: Bool { get }
}
