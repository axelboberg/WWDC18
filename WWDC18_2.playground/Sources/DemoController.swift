import Foundation
import UIKit
import Vision

public class DemoController : UIViewController {
	var mlNoteViewer: MLNoteViewer?
	var algoNoteViewer: NoteViewer?
	var lastNote: VNClassificationObservation?
	var notePlayer: NotePlayer = NotePlayer(path: "sound/", ext: "aif")
	
	var algo: NoteDetection?
	
	//Should or should not try to prevent hickups by the model
	public var preventClassificationLocking: Bool = true
	
	public override func loadView() {
		self.view = UIView()
		self.view.backgroundColor = .white
		
		let drawing = Drawing(frame: CGRect(x: 20, y: 20, width: 150, height: 227))
		
		//Init note-detection
		if drawing.canvas != nil {
			self.algo = NoteDetection(canvas: drawing.canvas!, distanceToFirstLine: drawing.frame.size.height / 8 * 2, distanceBetweenLines: drawing.frame.size.height / 8)
		}
		
		//MLNoteViewer
		let mlNoteViewer = MLNoteViewer(frame: CGRect(x: 190, y: 20, width: 150, height: 227), note: UIImage(named: "quarter_clean"))
		mlNoteViewer.setBackground(UIImage(named: "lines_ml"), lineDistance: 28.375)
		mlNoteViewer.show(noteClass: "ga")
		
		//AlgoNoteViewer
		let algoNoteViewer = NoteViewer(frame: CGRect(x: 360, y: 20, width: 150, height: 227), note: UIImage(named: "quarter_clean"))
		algoNoteViewer.setBackground(UIImage(named: "lines"), lineDistance: 28.375)
		algoNoteViewer.show(note: Note(name: "a", octave: 0))
		
		self.mlNoteViewer = mlNoteViewer
		self.algoNoteViewer = algoNoteViewer
		
		self.view.addSubview(drawing)
		self.view.addSubview(mlNoteViewer)
		self.view.addSubview(algoNoteViewer)
		
		//ML results view
		let resultListView = ClassificationListView(position: CGPoint(x: 20, y: 300))
		resultListView.loadClasses(identifiers: ["ga", "gb", "gc", "gd", "ge", "gf", "gg"])
		self.view.addSubview(resultListView)
		
		//Handlers
		drawing.onClassification(self.onClassificationHandler)
		drawing.onClassification(resultListView.showClassifications)
	}
	
	private func onClassificationHandler(_ classifications: [VNClassificationObservation]) {
		var note = classifications[0]
		
		//The if-statement that tries to prevent hickups
		if self.preventClassificationLocking && self.lastNote != nil {
			if self.lastNote!.identifier == note.identifier && classifications[1].confidence > 0.1 {
				note = classifications[1]
			}
		}
		
		//Store the last "recognized" note, for later use by the if-statements above
		self.lastNote = note
		
		//Show the note in the viewer
		self.showNoteInNoteViewer(note.identifier)
		
		self.runAlgorithm()
		
		//Play the sound
		guard let noteSound = NotePlayer.Note(rawValue: note.identifier) else {
			print("No notesound enum found")
			return
		}
		
		self.notePlayer.play(note: noteSound)
	}
	
	private func showNoteInNoteViewer(_ noteClass: String) {
		if self.mlNoteViewer == nil {
			return
		}
		
		self.mlNoteViewer!.show(noteClass: noteClass)
	}
	
	private func runAlgorithm() {
		guard let algo = self.algo else {
			return
		}
		
		guard let result = algo.detect() else {
			return
		}
		
		if self.algoNoteViewer != nil {
			self.algoNoteViewer!.show(note: result)
		}
	}
}
