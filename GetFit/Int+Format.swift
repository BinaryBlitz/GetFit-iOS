extension Int {
  
  func format() -> String {
    if self >= 1000000 {
      return "\(self / 1000000)m"
    } else if self >= 5000 {
      return "\(self / 1000)k"
    } else {
      return "\(self)"
    }
  }
}
