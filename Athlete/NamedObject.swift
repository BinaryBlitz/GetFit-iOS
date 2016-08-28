protocol NamedObject {
  var objectName: String { get }
}

extension Trainer: NamedObject {
  var objectName: String {
    return name
  }
}

extension Program: NamedObject {
  var objectName: String {
    return name
  }
}

extension ProgramViewModel: NamedObject {
  var objectName: String {
    return program.name
  }
}
