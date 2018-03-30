import Foundation
import UIKit

public class FadeFloat : TextAnimation {
	/**
	Animates the text with a simple "float-and-fade" animation using a standard UIView-animation
	*/
	public func animateIn(text: TextPart, duration: TimeInterval, delay: TimeInterval, onAnimationComplete: (() -> Void)?) {
		
		//Set starting parameters
		text.transform = CGAffineTransform(translationX: 0, y: 20)
		text.alpha = 0.0
		
		//Do animation
		UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
			text.transform = CGAffineTransform(translationX: 0, y: 0)
			text.alpha = 1.0
		}, completion: {(_ done: Bool) -> Void in
			// Call the onAnimationComplete-handler if one is provided
			if onAnimationComplete == nil {
				return
			}
			onAnimationComplete!()
		})
	}
	
	/**
	Animates the text with a simple "float-and-fade" animation, exactly the same as the in-animation but reversed.
	*/
	public func animateOut(text: TextPart, duration: TimeInterval, delay: TimeInterval, onAnimationComplete: (() -> Void)?) {
		
		//Set starting parameters
		text.transform = CGAffineTransform(translationX: 0, y: 0)
		text.alpha = 1.0
		
		//Do animation
		UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
			text.transform = CGAffineTransform(translationX: 0, y: 20)
			text.alpha = 0.0
		}, completion: {(_ done: Bool) -> Void in
			// Call the onAnimationComplete-handler if one is provided
			if onAnimationComplete == nil {
				return
			}
			onAnimationComplete!()
		})
	}
}
