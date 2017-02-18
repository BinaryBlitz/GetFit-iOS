enum TrainerCategory: String {
  case Coach = "trainer"
  case Doctor = "physician"
  case Nutritionist = "nutritionist"

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
