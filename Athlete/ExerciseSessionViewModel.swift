struct ExerciseSessionViewModel {
  let exerciseSession: ExerciseSession
}

extension ExerciseSessionViewModel: ExerciseSessionPresentable {
  var exerciseName: String {
    return exerciseSession.name
  }
  
  var repetitions: String? {
    guard let reps = exerciseSession.reps.value else { return nil }
    return "\(reps) times".uppercaseString
  }
  
  var weight: String? {
    guard let weight = exerciseSession.weight.value else { return nil }
    return "\(weight) kg".uppercaseString
  }
  
  var distance: String? {
    guard let dist = exerciseSession.distance.value else { return nil }
    return "\(dist) m".uppercaseString
  }
  
  var sets: String? {
    guard let sets = exerciseSession.sets.value else { return nil }
    return "\(sets) sets".uppercaseString
  }
  
  var completed: Bool {
    return exerciseSession.completed
  }
}
