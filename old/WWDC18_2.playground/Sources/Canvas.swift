import Foundation
import UIKit

public class CanvasData {
	private var _upper: CGPoint?
	private var _lower: CGPoint?
	
	public var upper: CGPoint? {
		get {
			return self._upper
		}
	}
	
	public var lower: CGPoint? {
		get {
			return self._lower
		}
	}
	
	public init() {}
	
	/**
	Analyze the provided points and set the upper and/or lower coordinates
	if any new point is above/blow the previous values.
	
	- parameters:
	- points: An array of CGPoint to analyze.
	*/
	fileprivate func analyzePoints(_ points: [CGPoint]) {
		for point in points {
			
			if (self.upper == nil)||(point.y < self.upper!.y) {
				self._upper = point
			}
			
			if (self.lower == nil)||(point.y > self.lower!.y) {
				self._lower = point
			}
		}
	}
	
	/**
	Clears the data by setting the upper and lower coordinates to nil.
	*/
	fileprivate func clearData() {
		self._upper = nil
		self._lower = nil
	}
}

public class Canvas : UIView {
	
	private var fillColor: UIColor
	private var lastPoint: CGPoint?
	private var renderer: UIGraphicsImageRenderer?
	private var f: UIImageView?
	
	private var snapshots = [UIImage]()
	private var subframe: UIImage?
	private var background: UIImage?
	private var historySize: Int = 5
	
	private var onSnapshotHandlers = [(UIImage?) -> Void]()
	
	public let data: CanvasData = CanvasData()
	
	public override init(frame: CGRect) {
		self.fillColor = UIColor.black
		self.renderer = UIGraphicsImageRenderer(size: frame.size)
		
		super.init(frame: frame)
	}
	
	public convenience init(frame: CGRect, background: UIImage?){
		self.init(frame: frame)
		
		guard let backgroundImg = background else {
			print("No background")
			return
		}
		
		self.background = backgroundImg
		self.subframe = backgroundImg
		
		self.draw(points: [], previousFrame: backgroundImg)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	///Events
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			self.lastPoint = touch.location(in: self)
		}
	}
	
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let points = touches.map{ touch -> CGPoint in
			let loc = touch.location(in: self)
			self.drawLine(from: self.lastPoint!, to: loc)
			
			self.lastPoint = loc
			
			return loc
		}
		
		self.data.analyzePoints(points)
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.addSnapshot(self.subframe!)
	}
	
	/**
	Register a handler to be called when a snapshot is made.
	
	- parameters:
	- handler: A handler to be called with the snapshot as an optional UIImage as parameter. Should return Void.
	*/
	public func onSnapshot(_ handler: @escaping(_ snapshot: UIImage?) -> Void) {
		self.onSnapshotHandlers.append(handler)
	}
	
	/**
	Call all registered onSnapshotHandlers with the provided snapshot.

	- parameters:
	- snapshot: The snapshot to pass as a parameter to all handlers, as an optional UIImage.
	*/
	private func dispatchSnapshotHandlers(snapshot: UIImage?) {
		guard let img = snapshot else {
			return
		}
		
		for handler in self.onSnapshotHandlers {
			handler(img)
		}
	}
	
	///Drawing
	private func drawLine(from: CGPoint, to: CGPoint){
		let points = [from, to]
		self.draw(points: points, previousFrame: self.subframe)
	}
	
	/**
	Draw lines between the points on the canvas, use the previous frame as a background.
	Also updates the subframe.
	
	- parameters:
	- points: An array of CGPoint to draw lines between.
	- previousFrame: An optional UIImage to use as background.
	*/
	private func draw(points: [CGPoint], previousFrame: UIImage?){
		self.subframe = self.renderer!.image { (ctx) in
			if previousFrame != nil {
				previousFrame!.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), blendMode: .normal, alpha: 1)
			} else {
				print("No subframe")
			}
			
			ctx.cgContext.setLineWidth(4)
			ctx.cgContext.setStrokeColor(self.fillColor.cgColor)
			
			ctx.cgContext.addLines(between: points)
			ctx.cgContext.drawPath(using: .stroke)
		}
		
		self.display(self.subframe!)
	}
	
	/**
	Displays the provided UIImage in the canvas's UIImageView.
	
	- parameters:
	- image: A UIImage to display.
	*/
	private func display(_ image: UIImage){
		if self.f == nil {
			self.f = UIImageView(image: image)
			self.f!.contentMode = .scaleAspectFit
			self.addSubview(self.f!)
		}
		self.f!.image = image
	}
	
	///History
	
	/**
	Sets the size of the history buffer to num snapshots.
	
	- parameters:
	- num: The number of snapshots to store in the history-buffer. Must be at least 1 and not more than 20.
	*/
	public func setHistorySize(_ num: Int){
		if num > 20 || num < 1 {return}
		self.historySize = num
	}
	
	/**
	Adds a UIImage as a snapshot. Triggers a call to all onSnapshotHandlers.
	
	- parameters:
	- image: UIImage representing the snapshot to add.
	*/
	private func addSnapshot(_ image: UIImage){
		if self.snapshots.count >= self.historySize {
			self.snapshots.removeFirst(self.snapshots.count - self.historySize)
		}
		self.snapshots.append(image)
		
		self.dispatchSnapshotHandlers(snapshot: image)
	}
	
	/**
	Returns the last snapshot.
	
	- returns: The last snapshot as an optional UIImage.
	*/
	public func lastSnapshot() -> UIImage? {
		let count = self.snapshots.count
		if count == 0 && self.background != nil {
			return self.background!
		} else if count == 0 {
			return nil
		}
		
		return self.snapshots[count - 1]
	}
	
	/**
	Undo the actions in the canvas certain steps back.
	
	- parameters:
	- steps: The number of steps to go back as an integer.
	*/
	public func goBack(_ steps: Int){
		let count = self.snapshots.count
		if count == 0 {return}
		
		var numBack = steps
		if numBack >= count {
			numBack = count
			
			self.data.clearData()
		}
		
		self.snapshots.removeLast(numBack)
		self.draw(points: [], previousFrame: self.lastSnapshot())
	}
}
