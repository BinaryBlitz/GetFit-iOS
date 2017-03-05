enum TrainerCategory: String {
  case Coach = "trainer"
  case Doctor = "physician"
  case Nutritionist = "nutritionist"

  var name: String {
    switch self {
    case .Coach:
      return "Coach"
    case .Doctor:
      return "Doctor"
    case .Nutritionist:
      return "Nutritionist"
    }
  }

  func pluralName() -> String {
    switch self {
    case .Coach:
      return "Coaches"
    case .Doctor:
      return "Doctors"
    case .Nutritionist:
      return "Nutritionists"
    }
  }
}
