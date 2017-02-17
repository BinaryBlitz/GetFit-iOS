struct ExerciseSessionViewModel {
  let exerciseSession: ExerciseSession
}

extension ExerciseSessionViewModel: ExerciseSessionPresentable {
  var exerciseName: String {
    return exerciseSession.name
  }
  
  var repetitions: String? {
    guard let reps = exerciseSession.reps.value else { return nil }
    return "\(reps) times".uppercased()
  }
  
  var weight: String? {
    guard let weight = exerciseSession.weight.value else { return nil }
    return "\(weight) kg".uppercased()
  }
  
  var distance: String? {
    guard let dist = exerciseSession.distance.value else { return nil }
    return "\(dist) m".uppercased()
  }
  
  var sets: String? {
    guard let sets = exerciseSession.sets.value else { return nil }
    return "\(sets) sets".uppercased()
  }
  
  var completed: Bool {
    return exerciseSession.completed
  }
}
