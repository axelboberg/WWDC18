import Foundation
import UIKit

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
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//Events
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			self.lastPoint = touch.location(in: self)
		}
	}
	
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let loc = touch.location(in: self)
			self.drawLine(from: self.lastPoint!, to: loc)
			
			self.lastPoint = loc
		}
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.addSnapshot(self.subframe!)
	}
	
	public func onSnapshot(_ handler: @escaping(_ snapshot: UIImage?) -> Void) {
		self.onSnapshotHandlers.append(handler)
	}
	
	private func dispatchSnapshotHandlers(snapshot: UIImage?) {
		guard let img = snapshot else {
			return
		}
		
		for handler in self.onSnapshotHandlers {
			handler(img)
		}
	}
	
	//Drawing
	private func drawLine(from: CGPoint, to: CGPoint){
		let points = [from, to]
		self.draw(points: points, previousFrame: self.subframe)
	}
	
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

	private func display(_ image: UIImage){
		if self.f == nil {
			self.f = UIImageView(image: image)
			self.f!.contentMode = .scaleAspectFit
			self.addSubview(self.f!)
		}
		self.f!.image = image
	}
	
	//History
	public func setHistorySize(_ num: Int){
		if num > 20 || num < 1 {return}
		self.historySize = num
	}
	
	private func addSnapshot(_ image: UIImage){
		if self.snapshots.count >= self.historySize {
			self.snapshots.removeFirst(self.snapshots.count - self.historySize)
		}
		self.snapshots.append(image)
		
		self.dispatchSnapshotHandlers(snapshot: image)
	}
	
	public func lastSnapshot() -> UIImage? {
		let count = self.snapshots.count
		if count == 0 && self.background != nil {
			return self.background!
		} else if count == 0 {
			return nil
		}
		
		return self.snapshots[count - 1]
	}
	
	public func goBack(_ steps: Int){
		let count = self.snapshots.count
		if count == 0 {return}
		
		var numBack = steps
		if numBack >= count {
			numBack = count
		}
		
		self.snapshots.removeLast(numBack)
		self.draw(points: [], previousFrame: self.lastSnapshot())
	}
}
