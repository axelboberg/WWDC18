import Foundation
import CoreGraphics

public struct Note {
	public let octave: Int
	public let name: String
	
	public init(name: String, octave: Int) {
		self.name = name.uppercased()
		self.octave = octave
	}
}

public struct LinePrediction {
	public let line: Int
	public let distance: CGFloat
	
	fileprivate init(line: Int, distance: CGFloat) {
		self.line = line
		self.distance = distance
	}
}

/**
The NoteDetection class handles the algorithm for classifying notes drawn in canvases.
*/
public class NoteDetection {
	private let canvas: Canvas
	private let toFirstLine: CGFloat
	private let betweenLines: CGFloat
	
	private let startingLine: Int = 0
	private let endingLine: Int = 5
	
	private var lineCoords = [CGFloat]()
	
	private let notesOnLines = ["F", "D", "B", "G", "E", "C"]
	private let notesBetweenLines = ["E", "C", "A", "F", "D"]
	
	public init(canvas: Canvas, distanceToFirstLine: CGFloat, distanceBetweenLines: CGFloat) {
		self.canvas = canvas
		self.toFirstLine = distanceToFirstLine
		self.betweenLines = distanceBetweenLines
		self.calculateLineCoordinates()
	}
	
	/**
	Calculates the coordinates, within the canvas view, for each of the lines and stores the values
	in an array of CGFloats where the index matches the index of the line.
	*/
	private func calculateLineCoordinates() {
		for i in self.startingLine...self.endingLine {
			self.lineCoords.append(self.toFirstLine + CGFloat(i) * betweenLines)
		}
	}
	
	/**
	Detect and classify a note drawn in the canvas using the algorithm.
	
	- returns: An optional Note object representing the classified note.
	*/
	public func detect() -> Note? {
		guard let upper = self.canvas.data.upper else {
			print("No upper")
			return nil
		}
		
		guard let lower = self.canvas.data.lower else {
			print("No lower")
			return nil
		}
		
		let middleY = upper.y + (lower.y - upper.y) / 2
		
		let closestMiddle = self.closestLine(coord: middleY)
		
		///Check if the closest line is out of bounds
		if (closestMiddle.line < 0)||(closestMiddle.line > self.lineCoords.count - 1) {
			return nil
		}
		
		var octave = 0
		
		if (abs(closestMiddle.distance) < 0.33)&&(upper.y < self.lineCoords[closestMiddle.line]) {
			
			///On line
			
			if closestMiddle.line < 2 {
				octave = 1
			}
			
			return Note(name: self.notesOnLines[closestMiddle.line], octave: octave)
		} else if (upper.y - self.lineCoords[closestMiddle.line]) > -0.33 {
			
			///Below line
			
			if closestMiddle.line < 2 {
				octave = 1
			}
			
			return Note(name: self.notesBetweenLines[closestMiddle.line], octave: octave)
		} else {
			
			///Above line
			
			if closestMiddle.line < 3 {
				octave = 1
			}
			
			return Note(name: self.notesBetweenLines[closestMiddle.line - 1], octave: octave)
		}
	}
	
	/**
	Calculate the closest line and the distance to the coordinate.
	
	- parameters:
	- coord: The coordinate on the y-axis that will be used in the calculation.
	
	- returns: A LinePrediction object with the calculated line-index and distance in fraction of the between lines distance.
	*/
	private func closestLine(coord: CGFloat) -> LinePrediction {
		let simplification = ((coord - self.toFirstLine) / self.betweenLines)
		var lineIndex = floor(simplification)
		var distanceToLine = simplification - lineIndex
		
		if distanceToLine > 0.5 {
			lineIndex += 1
			distanceToLine = 1 - distanceToLine
		}
		
		return LinePrediction(line: Int(lineIndex), distance: distanceToLine)
	}
}
