import Foundation
import UIKit

class NoteViewer : RoundedFrame {
	
	private enum NoteViewerError : Error {
		case imageNotFound
		case imageViewNotInitiated
	}
	
	var bgImageView: UIImageView?
	
	let imageView: UIImageView?
	var image: UIImage?
	private var lineDistance: CGFloat = 10
	
	public enum Note: Int {
		//Ordered by their appearance from the middle line and downwards
		case b = 1, a, g, f, e, d, c
	}
	
	public override init(frame: CGRect) {
		self.bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
		
		self.imageView = UIImageView(frame: frame)
		self.imageView!.contentMode = .scaleAspectFit
		
		super.init(frame: frame)
		
		self.addSubview(self.bgImageView!)
		self.addSubview(self.imageView!)
	}
	
	public convenience init(frame: CGRect, note: UIImage?) {
		self.init(frame: frame)
		self.image = note
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func setBackground(_ background: UIImage?, lineDistance: CGFloat) {
		if self.bgImageView == nil {
			self.bgImageView = UIImageView(frame: self.frame)
		}
		
		guard let bgImage = background else {
			print("Background image not found")
			return
		}
		
		self.bgImageView!.image = bgImage
		self.bgImageView!.contentMode = .scaleToFill
		self.lineDistance = lineDistance
	}
	
	private func calculateNoteFrame(_ note: Note) -> CGRect {
		//The note's enum-index
		let k = note.rawValue
		
		//Calculate the center Y-coordinate in order to have an origin-point
		let centerY = self.frame.size.height / 2
		
		let height = self.lineDistance * 5
		let width = self.lineDistance * 1.75
		
		//Place the note in the middle horizontally
		let x = self.frame.size.width / 2 - width / 2
		
		//Calculate the y-coordinate by counting downwards from the origin-y-point
		let y = (centerY + self.lineDistance / 2 * CGFloat(k)) - height
		return CGRect(x: x, y: y, width: width, height: height)
	}
	
	public func show(note: Note) {
		guard let imgView = self.imageView else {
			print("No view")
			return
		}
		
		guard let image = self.image else {
			print("No image")
			return
		}
		
		imgView.frame = self.calculateNoteFrame(note)
		imgView.image = image
	}
	
	public func setNoteImage(image: UIImage?) {
		guard let img = image else {
			return
		}
		
		self.image = img
	}
}
