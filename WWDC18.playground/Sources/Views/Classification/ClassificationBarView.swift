import Foundation
import UIKit

class ClassificationBarView: UIView {
	var confidence: Float
	var fillView: UIView?
	
	public init(frame: CGRect, confidence: Float) {
		self.confidence = confidence
		super.init(frame: frame)
		self.setupStyle()
		self.setConfidence(confidence)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupFill() {
		self.fillView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height))
		self.fillView!.backgroundColor = .orange
		self.fillView!.layer.cornerRadius = 5
		self.fillView!.layer.masksToBounds = true
		self.addSubview(self.fillView!)
	}
	
	private func setupStyle() {
		self.layer.cornerRadius = 5
		self.layer.masksToBounds = true
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor(white: 233/255, alpha: 1).cgColor
		self.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
	}
	
	public func setConfidence(_ confidence: Float) {
		self.confidence = confidence
		
		if self.fillView == nil {
			self.setupFill()
		}
		
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
			self.fillView!.frame.size.width = CGFloat(confidence) * self.frame.size.width
		})
	}
}
