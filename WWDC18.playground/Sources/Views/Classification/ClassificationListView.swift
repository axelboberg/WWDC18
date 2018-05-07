import Foundation
import UIKit
import Vision

class ClassificationListView: UIView {
	var classificationViews = [String: ClassificationView]()
	
	public init(position: CGPoint) {
		super.init(frame: CGRect(x: position.x, y: position.y, width: 120, height: 0))
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func loadClasses(identifiers: [String]) {
		var classificationHeight: CGFloat = 0
		let barspacing: CGFloat = 3
		
		for (i, identifier) in identifiers.enumerated() {
			let cView = ClassificationView(label: identifier)
			cView.frame.origin.y = cView.frame.size.height * CGFloat(i) + barspacing * CGFloat(i)
			classificationViews[identifier] = cView
			
			self.addSubview(cView)
			
			classificationHeight = cView.frame.size.height
		}
		
		self.frame.size.height = classificationHeight * CGFloat(self.classificationViews.count)
	}
	
	public func showClassifications(classifications: [VNClassificationObservation]) {
		for classification in classifications {
			guard let cView = classificationViews[classification.identifier] else {
				continue
			}

			cView.setConfidence(classification.confidence)
		}
	}
}
