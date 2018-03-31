import Foundation
import UIKit

public class ClassificationView: UIView {
	let label: String
	var barView: ClassificationBarView?
	
	public init(label: String) {
		self.label = label
		super.init(frame: CGRect(x: 0, y: 0, width: 120, height: 10))
		
		self.setup(label: label)
		self.setupConfidenceBar()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup(label: String) {
		let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 10))
		labelView.text = label.uppercased()
		labelView.font = UIFont.boldSystemFont(ofSize: 12.0)
		
		self.addSubview(labelView)
	}
	
	private func setupConfidenceBar() {
		self.barView = ClassificationBarView(frame: CGRect(x: 30, y: 2, width: 90, height: 6), confidence: 0)
		self.addSubview(self.barView!)
	}
	
	public func setConfidence(_ confidence: Float) {
		if self.barView == nil {
			self.setupConfidenceBar()
		}
		
		self.barView!.setConfidence(confidence)
	}
}
