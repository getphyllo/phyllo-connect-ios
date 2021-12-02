
import UIKit

enum AssetsColor {
    case app_bg
    case light_grey_bg
    case dark_grey_bg
    case line_color
    case txt_orange
    case txt_dark_grey
    case txt_light_grey
    case app_dim
    case txt_black
    case round_bg
    case address_buttons_bg
    case address_titles
    case dropdown_selected
    case gray_scale
    case alert_sub_text_color
    case image_bg
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
            case .app_bg:
                return UIColor(named: "app_bg")
            case .light_grey_bg:
                return UIColor(named: "light_grey_bg")
            case .dark_grey_bg:
                return UIColor(named: "dark_grey_bg")
            case .line_color:
                return UIColor(named: "line_color")
            case .txt_orange:
                return UIColor(named: "txt_orange")
            case .txt_dark_grey:
                return UIColor(named: "txt_dark_grey")
            case .txt_light_grey:
                return UIColor(named: "txt_light_grey")
            case .app_dim:
                return UIColor(named: "app_dim")
            case .round_bg:
                return UIColor(named: "round_bg")
            case .txt_black:
                return UIColor(named: "txt_black")
            case .address_buttons_bg:
                return UIColor(named: "address_buttons_bg")
            case .address_titles:
                return UIColor(named: "address_titles")
            case .dropdown_selected:
                return UIColor(named: "dropdown_selected")
            case .gray_scale:
                return UIColor(named: "gray_scale")
            case .alert_sub_text_color:
                return UIColor(named: "alert_sub_text_color")
            case .image_bg:
                return UIColor(named: "image_bg")
        }
    }
}

@IBDesignable  class CustomImageView: UIImageView {
    override func awakeFromNib() {
        decorate()
    }
    
    override func prepareForInterfaceBuilder() {
        decorate()
    }
    
    func decorate() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
}

@IBDesignable  class LineView: UIView {
    override func awakeFromNib() {
        decorate()
    }

    override func prepareForInterfaceBuilder() {
        decorate()
    }

    func decorate() {
        self.backgroundColor = UIColor.appColor(.line_color)
    }
}

@IBDesignable class BlurView: UIView {
    override func awakeFromNib() {
        decorate()
    }

    override func prepareForInterfaceBuilder() {
        decorate()
    }

    func decorate() {
        var blurEffect: UIBlurEffect!
        blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = 0.6
        blurEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(blurEffectView)
    }
}

//MARK:- Extensions
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    mutating func replace(_ pattern: String, replaceWith: String) -> String{
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return self;
        }
    }
}
extension Dictionary {
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}

extension String {
    var getImageName:String{
        let name = self.components(separatedBy: "juzies/")[1]
        return name
    }
}

extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}

extension UIImageView {
    func setGIFImage(name: String, repeatCount: Int = 0 ) {
        DispatchQueue.global().async {
            if let gif = UIImage.makeGIFFromCollection(name: name, repeatCount: repeatCount) {
                DispatchQueue.main.async {
                    self.setImage(withGIF: gif)
                    self.startAnimating()
                }
            }
        }
    }

    private func setImage(withGIF gif: GIF) {
        animationImages = gif.images
        animationDuration = gif.durationInSec
        animationRepeatCount = gif.repeatCount
    }
}

extension UIImage {
    class func makeGIFFromCollection(name: String, repeatCount: Int = 0) -> GIF? {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
            print("Cannot find a path from the file \"\(name)\"")
            return nil
        }

        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        guard let d = data else {
            print("Cannot turn image named \"\(name)\" into data")
            return nil
        }

        return makeGIFFromData(data: d, repeatCount: repeatCount)
    }

    class func makeGIFFromData(data: Data, repeatCount: Int = 0) -> GIF? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Source for the image does not exist")
            return nil
        }

        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration = 0.0

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)

                let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                                source: source)
                duration += delaySeconds
            }
        }

        return GIF(images: images, durationInSec: duration, repeatCount: repeatCount)
    }

    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.0

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        delay = delayObject as? Double ?? 0

        return delay
    }
}

class GIF: NSObject {
    let images: [UIImage]
    let durationInSec: TimeInterval
    let repeatCount: Int

    init(images: [UIImage], durationInSec: TimeInterval, repeatCount: Int = 0) {
        self.images = images
        self.durationInSec = durationInSec
        self.repeatCount = repeatCount
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dissmissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyBoard() {
        view.endEditing(true)
    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.removeFromParent()
        child.view.removeFromSuperview()
    }
}


// Shimmer Animation
extension UIImageView {
     func startShimmeringEffect() {
        let light = UIColor.white.cgColor
        let alpha = UIColor(red: 206/255, green: 10/255, blue: 10/255, alpha: 0.7).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
        gradient.colors = [light, alpha, light]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0,y: 0.5)
        gradient.locations = [0.35, 0.50, 0.65]
        self.layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9,1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmeringEffect() {
        self.layer.mask = nil
    }
}
// userDefaultKeys
class UserDefaultsKeys {
    static var uploadToNetwork: String {
        return "uploadToNetwork"
    }
    static var uploadProfileImageToNetwork: String{
        return "uploadProImageToNetwork"
    }
    static var uploadJuziImageToNetwork: String{
        return "uploadJuziImageToNetwork"
    }
    static var netWorkCall: String{
        return "netWorkCall"
    }
    static var numberOfLaunches: String {
        return "numberOfLaunches"
    }
}
extension UIButton {
  func imageToRight() {
      transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      self.imageView?.contentMode = .scaleAspectFit
  }
}
extension UIRefreshControl {
    func addProperties(){
        self.tintColor = UIColor.appColor(.txt_orange)
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}


