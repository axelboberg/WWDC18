import Foundation
import UIKit

public class NoteViewer : RoundedFrame {
	
	private enum NoteViewerError : Error {
		case imageNotFound
		case imageViewNotInitiated
	}
	
	///View displaying the background-lines
	var bgImageView: UIImageView?
	
	///View displaying the rendered image
	let imageView: UIImageView?
	var image: UIImage?
	
	///Line distance used to position the notes. Needs to be on par with the background.
	private var lineDistance: CGFloat = 10
	
	let noteMap = ["B", "A", "G", "F", "E", "D", "C"]
	
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
	
	/**
	Set the background of the note-viewer including the distance between the lines in the image.
	This method assumes that the background's lines are evenly distributed with an even space before and after the first and last line
	as a multiple of the line-distance.
	
	- parameters:
	- background: An optional UIImage being the background image.
	- lineDistance: The distance in pixels between the lines in the background image as a CGFloat.
	*/
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
	
	/**
	Calculate the frame in which to show the image of the note.
	Where the y-coordinate is responsible for positioning the note on the correct line.
	
	- parameters:
	- note: A Note-object representing the note to display.
	
	- returns: An optional CGRect representing the frame for the note.
	*/
	private func calculateNoteFrame(_ note: Note) -> CGRect? {
		///The note's enum-index
		guard let noteIndex = noteMap.index(of: note.name) else {
			return nil
		}
		let k = noteIndex + 1 - note.octave * 7
		
		///Calculate the center Y-coordinate in order to have an origin-point
		let centerY = self.frame.size.height / 2
		
		let height = self.lineDistance * 5
		let width = self.lineDistance * 1.75
		
		///Place the note in the middle horizontally
		let x = self.frame.size.width / 2 - width / 2
		
		///Calculate the y-coordinate by counting downwards from the origin-y-point
		let y = (centerY + self.lineDistance / 2 * CGFloat(k)) - height
		return CGRect(x: x, y: y, width: width, height: height)
	}
	
	/**
	Use the NoteViewer to display the provided note.
	
	- parameters:
	- note: The Note-object to display.
	*/
	public func show(note: Note) {
		guard let imgView = self.imageView else {
			print("No view")
			return
		}
		
		guard let image = self.image else {
			print("No image")
			return
		}
		
		guard let nFrame = self.calculateNoteFrame(note) else {
			return
		}
		imgView.frame = nFrame
		imgView.image = image
	}
	
	/**
	Set the image to be used as the note by the viewer.
	
	- parameters:
	- image: A UIImage to use as note.
	*/
	public func setNoteImage(image: UIImage?) {
		guard let img = image else {
			return
		}
		
		self.image = img
	}
}

public class MLNoteViewer: NoteViewer {
	/**
	Use the NoteViwer to display the note-class as a note by first converting the class into a
	Note with the octave 0.
	
	- parameters:
	- noteClass: The note class to convert into a Note as a String.
	*/
	public func show(noteClass: String) {
		super.show(note: Note(name: String(noteClass[noteClass.index(noteClass.startIndex, offsetBy: 1)]), octave: 0))
	}
}
