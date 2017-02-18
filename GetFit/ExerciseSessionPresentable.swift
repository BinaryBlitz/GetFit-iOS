protocol ExerciseSessionPresentable {
  var exerciseName: String { get }
  var repetitions: String? { get }
  var weight: String? { get }
  var distance: String? { get }
  var sets: String? { get }
  var completed: Bool { get }
}
