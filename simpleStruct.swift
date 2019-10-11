struct DetectiveTutorialModel {
    let image: UIImage
    let title: NSAttributedString
    let description: NSAttributedString
    let imageWithCorners: Bool
    
    init(image: UIImage, title: NSAttributedString, description: NSAttributedString, imageWithCorners: Bool = false) {
        self.image = image
        self.title = title
        self.description = description
        self.imageWithCorners = imageWithCorners
    }
}
