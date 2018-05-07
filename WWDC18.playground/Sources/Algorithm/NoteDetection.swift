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
	public let note: Int
	public let distance: CGFloat
	
	fileprivate init(note: Int, distance: CGFloat) {
		self.note = note
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
	
	private let notes = ["F", "E", "D", "C", "B", "A", "G"]
	
	public init(canvas: Canvas, distanceToFirstLine: CGFloat, distanceBetweenLines: CGFloat) {
		self.canvas = canvas
		self.toFirstLine = distanceToFirstLine
		self.betweenLines = distanceBetweenLines
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
		
		var octave = 0
		
		let lineCoordinate = self.getCoordinateForLineWithIndex(index: closestMiddle.note / 2)
		let absoluteDistanceTopToLine = abs((upper.y - lineCoordinate)/self.betweenLines)
		
		if (abs(closestMiddle.distance) < 0.33)&&(absoluteDistanceTopToLine > abs(closestMiddle.distance)) {
			
			///Note is on line
			octave = calculateOctave(notesFromBarrier: closestMiddle.note - 3)
			
			let note = self.notes[self.getIndexFromRepeatingArray(array: self.notes, index: closestMiddle.note)]
			return Note(name: note, octave: octave)
		} else if (upper.y - lineCoordinate)/self.betweenLines > -0.33 {
			
			///Note is below line
			octave = calculateOctave(notesFromBarrier: closestMiddle.note - 2)
			
			let note = self.notes[self.getIndexFromRepeatingArray(array: self.notes, index: closestMiddle.note + 1)]
			return Note(name: note, octave: octave)
		} else {
			
			///Note is above line
			octave = calculateOctave(notesFromBarrier: closestMiddle.note - 4)
			
			let note = self.notes[self.getIndexFromRepeatingArray(array: self.notes, index: closestMiddle.note - 1)]
			return Note(name: note, octave: octave)
		}
	}
	
	/**
	Calculate the octave where 0 being the middle octave on a piano, upwards from the middle C
	and 1 being the next octave upwards.
	
	- parameters:
	- notesFromBarrier: The number of notes from the start of the octave.
	
	- returns: The calculated octave as an integer.
	*/
	private func calculateOctave(notesFromBarrier: Int) -> Int {
		return Int(floor(Float(notesFromBarrier) / -7.0)) + 1
	}
	
	/**
	Translates an index of an array into the index that matches that same value
	as if the array was repeating in both directions.
	
	- parameters:
	- array: The array of strings to find the value of the index in.
	- index: The index to find which index to find, as an integer.
	
	- returns: The index as an integer.
	*/
	private func getIndexFromRepeatingArray(array: [String], index: Int) -> Int {
		if index >= 0 {
			return index % array.count
		} else {
			return (array.count + index) % array.count
		}
	}
	
	/**
	Calculates the y-coordinate of the line with index.

	- parameters:
	- line: Integer describing the line where 0 is the first line of the 5 standard ones.
	
	- returns: A CGFloat representing the y-coordinate of the line.
	*/
	private func getCoordinateForLineWithIndex(index: Int) -> CGFloat {
		return self.toFirstLine + CGFloat(index) * self.betweenLines
	}
	
	/**
	Calculate the closest note on a line and the distance to the coordinate.
	
	- parameters:
	- coord: The coordinate on the y-axis that will be used in the calculation.
	
	- returns: A LinePrediction object with the calculated note-index and distance in fraction of the between lines distance.
	*/
	private func closestLine(coord: CGFloat) -> LinePrediction {
		let simplification = ((coord - self.toFirstLine) / self.betweenLines)
		var lineIndex = floor(simplification)
		var distanceToLine = simplification - lineIndex
		
		if distanceToLine > 0.5 {
			lineIndex += 1
			distanceToLine = 1 - distanceToLine
		}
		
		return LinePrediction(note: Int(lineIndex) * 2, distance: distanceToLine)
	}
}
