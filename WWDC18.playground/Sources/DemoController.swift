import Foundation
import UIKit
import Vision

public class DemoController : UIViewController {
	var lastNote: VNClassificationObservation?
	var notePlayer: NotePlayer = NotePlayer(path: "sound/", ext: "aif")
	var algo: NoteDetection?
	
	/**
	Prevents the ml-model's NoteViewer from showing the same note twice if the second most likely classification's
	probability score is above 0.1.
	*/
	public var preventClassificationLocking: Bool = true
	
	/**
	The NoteViewer showing the note identified by the algorithm.
	*/
	private var _algoNoteViewer: NoteViewer = {
		let algoNoteViewer = NoteViewer(frame: CGRect(x: 430, y: 315, width: 150, height: 227), note: UIImage(named: "quarter_clean"))
		algoNoteViewer.setBackground(UIImage(named: "lines"), lineDistance: 28.375)
		algoNoteViewer.show(note: Note(name: "a", octave: 0))
		
		return algoNoteViewer
	}()
	public var algoNoteViewer: NoteViewer {
		get {
			return self._algoNoteViewer
		}
	}
	
	/**
	The NoteViewer showing the note identified by the machine-learning model.
	*/
	private var _mlNoteViewer: MLNoteViewer = {
		let mlNoteViewer = MLNoteViewer(frame: CGRect(x: 430, y: 55, width: 150, height: 227), note: UIImage(named: "quarter_clean"))
		mlNoteViewer.setBackground(UIImage(named: "lines_ml"), lineDistance: 28.375)
		mlNoteViewer.show(noteClass: "ga")
		
		return mlNoteViewer
	}()
	public var mlNoteViewer: MLNoteViewer {
		get {
			return self._mlNoteViewer
		}
	}
	
	/**
	The background image
	*/
	private var background: UIImageView = {
		let background = UIImageView(image: UIImage(named: "bg_demo"))
		
		let width: CGFloat = 308
		let height: CGFloat = 348
		
		background.frame = CGRect(x: 400 - width / 2, y: 300 - height / 2, width: width, height: height)
		
		return background
	}()
	
	/**
	The ClassificationListView showing bars representing the probability for all classes
	as predicted by the ml-model
	*/
	private var mlClassificationsListView: ClassificationListView = {
		let resultListView = ClassificationListView(position: CGPoint(x: 600, y: 120))
		resultListView.loadClasses(identifiers: ["ga", "gb", "gc", "gd", "ge", "gf", "gg"])
		
		return resultListView
	}()
	
	/**
	The label containing the brief instructions.
	*/
	private var instructions: UILabel = {
		let label = UILabel(frame: CGRect(x: 90, y: 282, width: 160, height: 70))
		label.text = "Draw a notehead and observe the classifications, be bold."
		label.textColor = UIColor(white: 0.4, alpha: 1)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 3
		label.font = UIFont.systemFont(ofSize: 11.0)
		return label
	}()
	
	/**
	The label showing the result of the algorithm.
	*/
	private var algoResultLabel: UILabel = {
		let label = UILabel(frame: CGRect(x: 660, y: 395, width: 50, height: 70))
		label.text = ""
		label.font = UIFont.boldSystemFont(ofSize: 35.0)
		return label
	}()
	
	public override func loadView() {
		self.view = UIView()
		self.view.backgroundColor = .white
		
		let drawing = Drawing(frame: CGRect(x: 90, y: 55, width: 150, height: 227))
		
		///Init note-detection on drawing
		if drawing.canvas != nil {
			self.algo = NoteDetection(canvas: drawing.canvas!, distanceToFirstLine: drawing.frame.size.height / 8 * 2, distanceBetweenLines: drawing.frame.size.height / 8)
		}
		
		///Add views
		self.view.addSubview(self.background)
		self.view.addSubview(drawing)
		self.view.addSubview(self.mlNoteViewer)
		self.view.addSubview(self.algoNoteViewer)
		self.view.addSubview(self.mlClassificationsListView)
		self.view.addSubview(self.instructions)
		self.view.addSubview(self.algoResultLabel)
		
		///Handlers
		drawing.onClassification(self.onClassificationHandler)
		drawing.onClassification(self.mlClassificationsListView.showClassifications)
	}
	
	/**
	The handler responsible for updating views with the new classifications. Called on every successful classification.
	
	- parameters:
	- classifications: An array of VNClassificationObservation.
	*/
	private func onClassificationHandler(_ classifications: [VNClassificationObservation]) {
		var note = classifications[0]
		
		///Trying to prevent hickups by using the second most likely classification if the same result is
		///achieved multiple times in a row and the second most likely classification has a score of over 0.1.
		if self.preventClassificationLocking && self.lastNote != nil {
			if self.lastNote!.identifier == note.identifier && classifications[1].confidence > 0.1 {
				note = classifications[1]
			}
		}
		
		///Store the last "recognized" note, for later use by the if-statements above
		self.lastNote = note
		
		///Show the note in the viewer
		self.showNoteInNoteViewer(note.identifier)
		
		self.runAlgorithm()
		
		///Play the sound
		guard let noteSound = NotePlayer.Note(rawValue: note.identifier) else {
			print("No notesound enum found")
			return
		}
		
		self.notePlayer.play(note: noteSound)
	}
	
	/**
	Displays a note in the mlNoteViewer
	
	- parameters:
	- noteClass: The classified note's class as identified by the ml-model.
	*/
	private func showNoteInNoteViewer(_ noteClass: String) {
		self.mlNoteViewer.show(noteClass: noteClass)
	}
	
	/**
	Triggers the algorithm to calculate the note in the drawing. Also shows it in the algoritm's note-viewer
	and writes out the letter in the result label.
	*/
	private func runAlgorithm() {
		guard let algo = self.algo else {
			return
		}
		
		guard let result = algo.detect() else {
			return
		}
		
		self.algoResultLabel.text = result.name
		self.algoNoteViewer.show(note: result)
	}
}
