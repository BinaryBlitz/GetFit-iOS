import RealmSwift

enum SenderType: String {
  case Trainer = "trainer"
  case User = "user"
  case Notifier = "notifier"
}

class Conversation: Object {

  dynamic var id: Int = 0
  dynamic var senderId: Int = 0
  dynamic var senderTypeValue: String = SenderType.Trainer.rawValue

  // MARK: - Properties

  var senderType: SenderType {
    get {
      return SenderType(rawValue: senderTypeValue)!
    }
    set {
      senderTypeValue = newValue.rawValue
    }
  }

  let messages = List<Message>()
}
