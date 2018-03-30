import Foundation
import UIKit
import Vision

class Drawing : RoundedFrame {
	let canvas: Canvas?
	let classifier: Classifier?
	
	public override init(frame: CGRect) {
		//Init canvas
		self.canvas = Canvas(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), background: UIImage(named: "lines_clean"))
		
		//Init classifier
		self.classifier = Classifier()
		
		super.init(frame: frame)
		
		//Setup classification callback
		self.classifier!.onClassification(self.onClassificationHandler)
		
		//Setup snapshot callback
		self.canvas!.onSnapshot(self.onSnapshotHandler)
		
		self.addSubview(self.canvas!)
		
		//Setup undo-button
		self.setupHistoryControls()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/* Drawing */
	
	private func onSnapshotHandler(_ snapshot: UIImage?) {
		guard let image = snapshot else {
			return
		}
		
		//Classify the canvas-snapshot
		self.classifier!.classify(image)
	}
	
    /**
    Called when a successful classification is made, handles the update within the class.
     
    - parameters:
    - classifications: An optional array of VNClassificationObservation-objects for the classification.
    */
	private func onClassificationHandler(_ classifications: [VNClassificationObservation]) {
		let noteClass = classifications[0].identifier
		print(noteClass + String(classifications[0].confidence))
		print(classifications[1].identifier + String(classifications[1].confidence))
		print(classifications[2].identifier + String(classifications[2].confidence))
		print("----")
	}
	
    /**
    Registers a handler to be called upon successful classification by calling the onClassification method
    on the classification-object.
     
    - parameters:
    - handler: The handler to be registered.
    */
	public func onClassification(_ handler: @escaping(_ classification: [VNClassificationObservation]) -> Void){
		if self.classifier != nil {
			self.classifier!.onClassification(handler)
		}
	}
	
    /**
    Sets up the undo-button
    */
	private func setupHistoryControls() {
		
		//Undo-button (triggers the undo-action of the canvas)
		let undoButton = UIButton(type: .custom)
		
		//Styling
		undoButton.frame = CGRect(x: self.frame.size.width - 35, y: 10, width: 25, height: 25)
		undoButton.setImage(UIImage(named: "btn_undo"), for: .normal)

		//Action
		undoButton.addTarget(nil, action: #selector(self.canvasBack), for: .touchUpInside)
		
		self.addSubview(undoButton)
	}
	
	/**
    Triggers the undo-action when the undo-button is clicked.
    */
	@IBAction func canvasBack() {
		if self.canvas == nil {
			return
		}
	
		self.canvas!.goBack(1)
	}

}
