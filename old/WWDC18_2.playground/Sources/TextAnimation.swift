import Foundation
import UIKit

public protocol TextAnimation {
	func animateIn(text: TextPart, duration: TimeInterval, delay: TimeInterval, onAnimationComplete: (() -> Void)?)
	func animateOut(text: TextPart, duration: TimeInterval, delay: TimeInterval, onAnimationComplete: (() -> Void)?)
}
