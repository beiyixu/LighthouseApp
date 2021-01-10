//
//  Extensions.swift
//  Bulb
//
//  Created by Beiyi Xu on 10/12/20.
//

import UIKit
import CoreLocation
import Kingfisher

extension UIStoryboard {
  
  class func controller<T: UIViewController>(storyboard: StoryboardEnum) -> T {
    return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: T.className) as! T
  }
  
  class func initial<T: UIViewController>(storyboard: StoryboardEnum) -> T {
    return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateInitialViewController() as! T
  }
  
  enum StoryboardEnum: String {
    case auth = "Auth"
    case conversations = "Conversations"
    case profile = "Profile"
    case previews = "Previews"
    case messages = "Messages"
  }
}

extension Dictionary {
  
  var data: Data? {
    return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
  }
}


extension String {
  
  func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }
  
  var location: CLLocationCoordinate2D? {
    let coordinates = self.components(separatedBy: ":")
    guard coordinates.count == 2 else { return nil }
    return CLLocationCoordinate2D(latitude: Double(coordinates.first!)!, longitude: Double(coordinates.last!)!)
  }
}


extension UIFont {
  
  var bold: UIFont {
    return with(traits: .traitBold)
  }
  
  var regular: UIFont {
    var fontAtrAry = fontDescriptor.symbolicTraits
    fontAtrAry.remove([.traitBold])
    let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
    return UIFont(descriptor: fontAtrDetails!, size: pointSize)
  }
  
  func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
    guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
      return self
    }
    return UIFont(descriptor: descriptor, size: 0)
  }
}

extension UIColor {
    
    static var mainBlue = UIColor.rgb(red: 27, green: 75, blue: 136)
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UITableView {
  
  func scroll(to: Position, animated: Bool) {
    let sections = numberOfSections
    let rows = numberOfRows(inSection: numberOfSections - 1)
    switch to {
    case .top:
      if rows > 0 {
        let indexPath = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: animated)
      }
      break
    case .bottom:
      if rows > 0 {
        let indexPath = IndexPath(row: rows - 1, section: sections - 1)
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
      }
      break
    }
  }
  
  enum Position {
    case top
    case bottom
  }
}


extension Encodable {
  var values: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}

extension UIImageView {
  
  func setImage(url: URL?, completion: CompletionObject<UIImage?>? = nil) {
    kf.setImage(with: url) { result in
      switch result {
      case .success(let value):
        completion?(value.image)
      case .failure(_):
        completion?(nil)
      }
    }
  }
  
  func cancelDownload() {
    kf.cancelDownloadTask()
  }
}

extension UIImage {
  
  func fixOrientation() -> UIImage {
    if (imageOrientation == .up) { return self }
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    draw(in: rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
  
  func scale(to newSize: CGSize) -> UIImage? {
    let horizontalRatio = newSize.width / size.width
    let verticalRatio = newSize.height / size.height
    let ratio = max(horizontalRatio, verticalRatio)
    let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
      get {
        return layer.cornerRadius
      }
      set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
      }
    }
    
    @IBInspectable var borderWidth: CGFloat {
      get {
        return layer.borderWidth
      }
      set {
        layer.borderWidth = newValue
      }
    }
    
    @IBInspectable var borderColor: UIColor? {
      get {
        if let color = layer.borderColor {
          return UIColor(cgColor: color)
        }
        return nil
      }
      set {
        layer.borderColor = newValue?.cgColor
      }
    }
    
    @IBInspectable var shadowColor: UIColor? {
      get {
        if let color = layer.shadowColor {
          return UIColor(cgColor: color)
        }
        return nil
      }
      set {
        layer.shadowColor = newValue?.cgColor
      }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
      get {
        return layer.shadowRadius
      }
      set {
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = newValue
        layer.shadowOpacity = 0.2
      }
    }
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func applyGradient(isVertical: Bool, x: CGFloat, y: CGFloat, colorArray: [UIColor]) {
        layer.sublayers?.filter({$0 is CAGradientLayer}).forEach({$0.removeFromSuperlayer()})
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            gradientLayer.locations = [0.0, 1.0]
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.locations = [0.0,0.25,0.75,1.0]
        }
        backgroundColor = .clear
        gradientLayer.frame = CGRect(x: 0, y: 0, width: x - 24, height: y - 24)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        gradientLayer.cornerRadius = 15
        layer.addSublayer(gradientLayer)
        cornerRadius = 15.0
        borderColor = UIColor.clear
        layer.masksToBounds = true
        layer.shadowColor = UIColor.mainBlue.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.6
        layer.cornerRadius = 15.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: x, height: y), cornerRadius: layer.cornerRadius).cgPath
        
       
    }
}

extension Date {
    
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo == 0 {
            return "Just now"
        }
        if secondsAgo < minute {
            if secondsAgo == 1 {
                return "\(secondsAgo) second ago"
            } else {
                return "\(secondsAgo) seconds ago"
            }
        } else if secondsAgo < hour {
            if secondsAgo / minute == 1 {
                return "\(secondsAgo / minute) minute ago"
            } else {
                return "\(secondsAgo / minute) minutes ago"
            }
        } else if secondsAgo < day {
            if secondsAgo / hour == 1 {
                return "\(secondsAgo / hour) hour ago"
            } else {
                return "\(secondsAgo / hour) hours ago"
            }
        } else if secondsAgo < week {
            if secondsAgo / day == 1 {
                return "\(secondsAgo / day) day ago"
            } else {
                return "\(secondsAgo / day) days ago"
            }
        }
        
        if secondsAgo / week == 1 {
            return "\(secondsAgo / week) week ago"
        } else {
            return "\(secondsAgo / week) weeks ago"
        }
    }
    
    func timeAgoDisplayShort() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo == 0 {
            return "Just now"
        }
        if secondsAgo < minute {
            return "\(secondsAgo)s"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute)m"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour)h"
        } else if secondsAgo < week {
            return "\(secondsAgo / day)d"
        }
        
        return "\(secondsAgo / week)wk"
    }
}

extension NSNotification.Name {
    static var updateHomeFeed = NSNotification.Name(rawValue: "updateFeed")
    static var updateUserProfileFeed = NSNotification.Name(rawValue: "updateUserProfileFeed")
    static var updateConvos = NSNotification.Name(rawValue: "updateConvos")
}

public enum FirestoreCollectionReference: String {
  case users = "Users"
  case conversations = "Conversations"
  case messages = "Messages"
}

public enum FirestoreResponse {
  case success
  case failure
}

extension Optional {
  var isNone: Bool {
    return self == nil
  }
  
  var isSome: Bool {
    return self != nil
  }
}

extension  CLLocationCoordinate2D {
  
  var string: String {
    return "\(latitude):\(longitude)"
  }
}

extension NSObject {
  class var className: String {
    return String(describing: self.self)
  }
}

extension UIViewController {
  
  func showAlert(title: String = "Error", message: String = "Something went wrong", completion: EmptyCompletion? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
      completion?()
    }))
    present(alert, animated: true, completion: nil)
  }
}

public typealias EmptyCompletion = () -> Void
public typealias CompletionObject<T> = (_ response: T) -> Void
public typealias CompletionOptionalObject<T> = (_ response: T?) -> Void
public typealias CompletionResponse = (_ response: Result<Void, Error>) -> Void



