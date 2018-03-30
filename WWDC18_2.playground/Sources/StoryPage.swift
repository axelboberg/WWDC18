import Foundation
import UIKit

public class StoryPage : UIView {
	private var text: TextViewer?
	private var textMargin: CGFloat = 100
	
	private var button: BoldButton?
	private var onButtonClickHandlers = [() -> Void]()
	
	public init(frame: CGRect, heading: String?, text: String, buttonLabel: String?, textMargin: CGFloat) {
		super.init(frame: frame)
		self.textMargin = textMargin
		self.setup(text: text)
		
		if heading != nil {
			self.setup(heading: heading!)
		}
		
		if buttonLabel != nil {
			self.setupButton(with: buttonLabel!)
		}
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/**
	Sets up the TextViewer for the main content of the page.
	*/
	private func setup(text: String) {
		self.text = TextViewer(frame: TextViewerFrame(x: textMargin, y: textMargin, width: self.frame.size.width - 2 * textMargin))
		self.text!.setText(text)
		self.addSubview(self.text!)
	}
	
	/**
	Calculates the sum of the TextViewer's Y-coordinate and its height.
	
	- returns: The sum of the TextViewer's Y-coordinate and height as a CGFloat.
	*/
	private func getTextYOffset() -> CGFloat {
		guard let textViewer = self.text else {
			return 0
		}
		
		let textYCoord = textViewer.vFrame.origin.y
		let textHeight = textViewer.vFrame.size.height
		
		return textYCoord + textHeight
	}
	
	/**
	Sets up the heading of the page.
	*/
	private func setup(heading: String) {
		let headingLabel = UILabel(frame: CGRect(x: textMargin, y: textMargin - 70, width: self.frame.size.width - 2 * textMargin, height: 40))
		headingLabel.text = heading
		headingLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
		self.addSubview(headingLabel)
	}
	
	/**
	Sets up the button of the page, of type BoldButton.
	*/
	private func setupButton(with text: String) {
		self.button = BoldButton(center: CGPoint(x: self.frame.size.width / 2, y: self.getTextYOffset() + CGFloat(85)))
		self.button!.setTitle(text, for: .normal)
		self.button!.addTarget(nil, action: #selector(self.dispatchButtonClickHandlers), for: .touchUpInside)
		self.addSubview(self.button!)
	}
	
	/**
	Fades in the page and calls the showContent method of the page's main content TextViewer,
	triggering the specified animationIn of each TextPart assiciated with the TextView.
	*/
	public func show() {
		self.alpha = 0
		UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseOut, animations: {
			self.alpha = 1
		}, completion: {(_ done: Bool) -> Void in
			if self.text != nil {
				self.text!.showContent()
			}
		})
	}
	
	/**
	Calls the hideContent method of the page's main content TextViewer,
	triggering the specified animationIn of each TextPart assiciated with the TextView.
	*/
	public func hide() {
		self.hide(completion: nil)
	}
	
	/**
	Calls the hideContent method of the page's main content TextViewer,
	triggering the specified animationIn of each TextPart assiciated with the TextView.
	Fades out page after animation has finished.
	
	- parameters:
	- completion: A completion-handler to call when the content has finished animating.
	*/
	public func hide(completion: (() -> Void)?) {
		if self.text != nil {
			self.text!.hideContent(completion: {() in
				self.fadeOut()
				
				if completion != nil {
					completion!()
				}
			})
		}
	}
	
	/**
	Fades out the page and its contents.
	*/
	private func fadeOut() {
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
			self.alpha = 0
		})
	}
	
	/**
	Adds a function to the dispatch-queue called when the button of the page is clicked/touched.
	
	- parameters:
	- handler: The handler to register.
	*/
	public func onButtonClick(_ handler: @escaping() -> Void) {
		self.onButtonClickHandlers.append(handler)
	}
	
	/**
	Dispatches the button click handlers, one at a time, from the queue.
	*/
	@IBAction private func dispatchButtonClickHandlers() {
		for handler in self.onButtonClickHandlers {
			handler()
		}
	}
}

