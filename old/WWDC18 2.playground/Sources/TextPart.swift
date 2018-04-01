import Foundation
import UIKit

public class TextPart : UILabel {
	public var animation: TextAnimation = FadeFloat()
	
	public init(frame: CGRect, withText: String) {
		super.init(frame: frame)
		self.text = withText
		self.sizeToFit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/**
	Adds the TextPart as a subview to the provided UIView, without animation.
	
	- parameters:
	- parent: The UIView which will hold the TextPart. Usually a TextViewer.
	*/
	public func show(in parent: UIView) {
		parent.addSubview(self)
	}
	
	/**
	Shows the TextPart with the specified animation (defauls to "FadeFloat")
	
	- parameters:
	- parent: The UIView which will hold the TextPart. Usually a TextViewer.
	- duration: Duration of the animation as a TimeInterval.
	- delay: Delay of the animation as a TimeInterval.
	*/
	public func show(in parent: UIView, duration: TimeInterval, delay: TimeInterval) {
		self.show(in: parent)
		self.animation.animateIn(text: self, duration: duration, delay: delay, onAnimationComplete: nil)
	}
	
	/**
	Hide TextPart without animation
	*/
	public func hide() {
		self.removeFromSuperview()
	}
	
	/**
	Hides the TextPart with the specified animation (defaults to "FadeFloat")
	
	- parameters:
	- duration: Duration of the animation as a TimeInterval.
	- delay: Delay of the animation as a TimeInterval.
	*/
	public func hide(duration: TimeInterval, delay: TimeInterval) {
		self.hide(duration: duration, delay: delay, completion: nil)
	}
	
	/**
	Hides the TextPart with the specified animation (defaults to "FadeFloat")
	
	- parameters:
	- duration: Duration of the animation as a TimeInterval.
	- delay: Delay of the animation as a TimeInterval.
	- completion: Handler to call when animation is finished.
	*/
	public func hide(duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)?) {
		self.animation.animateOut(text: self, duration: duration, delay: delay, onAnimationComplete: {() in
			self.hide()
			
			if completion != nil {
				completion!()
			}
		})
	}
}
