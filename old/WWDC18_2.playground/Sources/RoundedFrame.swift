import Foundation
import UIKit

class RoundedFrame : UIView {
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupStyle()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupStyle() {
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true
		self.layer.borderWidth = 2.0
		self.layer.borderColor = UIColor(white: 233/255, alpha: 1).cgColor
	}
}
