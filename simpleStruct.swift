struct Trailer: Contentable {
    let id: String
    let title: String
    let images: [ContentImage]
    var contentType: ContentType
    var bookmarkPosition: Int = 0
    let duration: Int
    let url: PlayerUrl
    let releasedYear: Int
    var resourceId: String = ""
    var isFavorite: Bool = false
    var hd: Bool = false
    var cc: Bool = false
    var isCatchup: Bool = true
    var description: String = ""
    var genre: String = ""
    var credits: Credit
    var parentalLevel: ParentalLevel
    var dueDate: TimeInterval?
    var trailerId: String?
    
    func getId() -> String {
        return id
    }
    
    func getContentType() -> ContentType {
        return contentType
    }
}
