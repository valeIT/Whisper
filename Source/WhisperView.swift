import UIKit

public protocol NotificationControllerDelegate: class {
  func notificationControllerWillHide()
}

public class WhisperView: UIView {

  struct Dimensions {
    static let height: CGFloat = 24
    static let offsetHeight: CGFloat = height * 2
    static let imageSize: CGFloat = 14
    static let loaderTitleOffset: CGFloat = 5
  }

  lazy private(set) var transformViews: [UIView] = [self.titleLabel, self.complementImageView]

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .Center
    label.font = UIFont(name: "HelveticaNeue", size: 13)
    label.frame.size.width = UIScreen.mainScreen().bounds.width - 60

    return label
    }()

  lazy var complementImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFill

    return imageView
    }()

  public weak var delegate: NotificationControllerDelegate?
  public var height: CGFloat
  var whisperImages: [UIImage]?

  // MARK: - Initializers

  init(size: CGSize, message: Message) {
    self.height = size.height
    self.whisperImages = message.images
    super.init(frame: CGRectZero)

    titleLabel.text = message.title
    titleLabel.textColor = message.textColor
    backgroundColor = message.backgroundColor

    if let images = whisperImages where images.count > 1 {
      complementImageView.animationImages = images
      complementImageView.animationDuration = 0.7
      complementImageView.startAnimating()
    } else {
      complementImageView.image = whisperImages?.first
    }

    frame = CGRectMake(0, height, size.width, Dimensions.height)
    for subview in transformViews { addSubview(subview) }

    titleLabel.sizeToFit()
    setupFrames()
    clipsToBounds = true
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    setupFrames()
  }
}

// MARK: - Layout

extension WhisperView {

  func setupFrames() {
    if whisperImages != nil {
      titleLabel.frame = CGRect(
        x: (frame.width - titleLabel.frame.width) / 2 + 20,
        y: 0,
        width: titleLabel.frame.width,
        height: frame.height)

      complementImageView.frame = CGRect(
        x: titleLabel.frame.origin.x - Dimensions.imageSize - Dimensions.loaderTitleOffset,
        y: (Dimensions.height - Dimensions.imageSize) / 2,
        width: Dimensions.imageSize,
        height: Dimensions.imageSize)
    } else {
      titleLabel.frame = CGRect(
        x: (frame.width - titleLabel.frame.width) / 2,
        y: 0,
        width: titleLabel.frame.width,
        height: frame.height)
    }
    guard let superviewWidth = superview?.frame.width else { return }
    frame.size = CGSize(width: superviewWidth, height: frame.height)
  }
}
