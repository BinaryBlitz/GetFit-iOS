import RealmSwift

class Like: Object {
  dynamic var createdAt: NSDate = NSDate()
  
  // One-to-one in Realm is hard
  private let posts = LinkingObjects(fromType: Post.self, property: "like")
  var post: Post? {
    return posts.first
  }
}
