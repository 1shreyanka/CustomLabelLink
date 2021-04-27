//
//  CustomTextLink.swift
//  CustomTextLink
//
//  Created by Shreyanka B Honnalli on 27/04/21.
//

import Foundation
import UIKit


@IBDesignable
class CustomTextLink :UILabel{
    
    var link1:String?
    
    var link2:String?
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    //set below properties in interface builder as per the requirement
    @IBInspectable override var text: String? {
        didSet {
            self.commonInit()
        }
    }
    @IBInspectable  var text1: String? {
        didSet {
            self.commonInit()
        }
    }
    @IBInspectable  var text2: String? {
        didSet {
            self.commonInit()
        }
    }
    @IBInspectable var LinktextColor: UIColor = UIColor.red {
        didSet {
            self.commonInit()
        }
    }
    @IBInspectable var MaintextColor: UIColor = UIColor.black {
        didSet {
            self.commonInit()
        }
    }
    @IBInspectable var boldfont:CGFloat=20{
        didSet{
            commonInit()
        }
    }
    
    @IBInspectable var normalfont:CGFloat=15{
        didSet{
            commonInit()
        }
    }
    @IBInspectable var isUnderlined:Bool=false{
        didSet{
            commonInit()
        }
    }
    
    private func commonInit(){
        guard let text = text else { return }
        
        guard let text1 = text1 else { return }
        
        if let text2 = text2{
            let formattedText = String.format(strings: [text1 , text2],
                                                boldFont: UIFont.boldSystemFont(ofSize: boldfont),
                                                boldColor: LinktextColor,
                                                inString: text,
                                                font: UIFont.systemFont(ofSize: normalfont),
                                                underline: isUnderlined,
                                                color: MaintextColor)
            self.attributedText = formattedText
           
            self.numberOfLines = 0
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
            self.addGestureRecognizer(tap)
            self.isUserInteractionEnabled = true
            
        }else{
            let formattedText = String.format(strings: [text1],
                                                boldFont: UIFont.boldSystemFont(ofSize: boldfont),
                                                boldColor: LinktextColor,
                                                inString: text,
                                                font: UIFont.systemFont(ofSize: normalfont),
                                                underline: isUnderlined,
                                                color: MaintextColor)
            self.attributedText = formattedText
           
            self.numberOfLines = 0
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
            self.addGestureRecognizer(tap)
            self.isUserInteractionEnabled = true
        }
    
    }
// OnTapLink  navigate to browser and open requested URL
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        if let text1=text1{
            let termsRange = (text! as NSString).range(of: text1)
            if gesture.didTapAttributedTextInLabel(label: self, inRange: termsRange) {
                if let link=link1{
                    guard let url = URL(string: link) else { return }
                       UIApplication.shared.open(url)
                }
            
                
            }
        }
        if let text2=text2{
            let privacyRange = (text! as NSString).range(of: text2)
            if gesture.didTapAttributedTextInLabel(label: self, inRange: privacyRange) {
               // print("Tapped privacy")
                if let link=link2{
                    guard let url = URL(string: link) else { return }
                       UIApplication.shared.open(url)
                }
                
            }
        }
               print("Tapped none")
    }
   
}
extension String {
    static func format(strings: [String],
                    boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                    boldColor: UIColor = UIColor.blue,
                    inString string: String,
                    font: UIFont = UIFont.systemFont(ofSize: 14),
                    underline:Bool=false,
                    color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                    attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color,.underlineStyle: 0])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor,.underlineStyle:underline] as [NSAttributedString.Key : Any]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
}
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}

