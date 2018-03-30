import Foundation
import UIKit
import Vision

public class DemoController : UIViewController {
	var noteViewer: NoteViewer?
	var lastNote: VNClassificationObservation?
	var notePlayer: NotePlayer = NotePlayer(path: "sound/", ext: "aif")
	
	//Should or should not try to prevent hickups by the model
	public var preventClassificationLocking: Bool = true
	
	public override func loadView() {
		self.view = UIView()
		self.view.backgroundColor = .white
		
		let drawing = Drawing(frame: CGRect(x: 20, y: 20, width: 150, height: 227))
		
		let noteViewer = NoteViewer(frame: CGRect(x: 190, y: 20, width: 150, height: 227), note: UIImage(named: "quarter_clean"))
		noteViewer.setBackground(UIImage(named: "lines"), lineDistance: 28.375)
		noteViewer.show(note: .a)
		
		self.noteViewer = noteViewer
		
		self.view.addSubview(drawing)
		self.view.addSubview(noteViewer)
		
		drawing.onClassification(self.onClassificationHandler)
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
		
		//Play the sound
		guard let noteSound = NotePlayer.Note(rawValue: note.identifier) else {
			print("No notesound enum found")
			return
		}
		
		self.notePlayer.play(note: noteSound)
	}
	
	private func showNoteInNoteViewer(_ noteClass: String) {
		if self.noteViewer == nil {
			return
		}
		
		var note: NoteViewer.Note?
		switch noteClass {
		case "gg":
			note = NoteViewer.Note.g
			break
		case "ga":
			note = NoteViewer.Note.a
			break
		case "gb":
			note = NoteViewer.Note.b
			break
		case "gc":
			note = NoteViewer.Note.c
			break
		case "gd":
			note = NoteViewer.Note.d
			break
		case "ge":
			note = NoteViewer.Note.e
			break
		case "gf":
			note = NoteViewer.Note.f
			break
		default:
			return
		}
		
		if note != nil {
			self.noteViewer!.show(note: note!)
		}
	}
}
