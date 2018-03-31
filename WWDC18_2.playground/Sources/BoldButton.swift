import Foundation
import UIKit

public class BoldButton : UIButton {
	private let defaultSize: CGSize = CGSize(width: 125, height: 35)
	
	public enum ContentTheme {
		case dark, light
	}
	
	public required init(center: CGPoint) {
		super.init(frame: CGRect(x: center.x - defaultSize.width / 2, y: center.y - defaultSize.height / 2, width: defaultSize.width, height: defaultSize.height))
		self.doSetup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
	Set the theme of the button.
	
	- parameters:
	- theme: The ContentTheme to set.
	*/
	public func setContentTheme(_ theme: ContentTheme) {
		switch theme {
		case ContentTheme.light:
			self.backgroundColor = UIColor.white
			self.setTitleColor(UIColor.black, for: .normal)
			break
		default:
			self.backgroundColor = UIColor.black
			self.setTitleColor(UIColor.white, for: .normal)
		}
	}
	
	private func doSetup() {
		
		///Set the default content-theme
		self.setContentTheme(.dark)
		
		///Setup the label
		self.titleLabel?.sizeToFit()
		self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
		
		///Setup the corners
		self.layer.cornerRadius = 5
		self.layer.masksToBounds = true
	}
}
