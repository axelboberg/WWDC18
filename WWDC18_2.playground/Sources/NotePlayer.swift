import Foundation
import AVFoundation

public class NotePlayer {
	private var player: AVAudioPlayer?
	
	public enum Note: String {
		case gb, ga, gg, gf, ge, gd, gc
	}
	
	private let ext: String
	private let path: String
	
	public init(path: String, ext: String) {
		self.path = path
		self.ext = ext
	}
	
	/**
	Constructs the local url for the sound of the provided note.
	
	- parameters:
	- note: The note to get the URL for. A case of the Note enumeration.
	
	- returns: An optional URL pointing to the soundfile for the note, nil if file is not found.
	*/
	private func getURLForNoteSound(_ note: Note) -> URL? {
		guard let path = Bundle.main.path(forResource: self.path + note.rawValue + "." + self.ext, ofType: nil) else {
			print("Not a valid sound path")
			return nil
		}
		return URL(fileURLWithPath: path)
	}
	
	/**
	Plays the sound for a note.
	
	- parameters:
	- note: The note to play. A case of the Note enumeration.
	*/
	public func play(note: Note) {
		
		///Get the url for the file
		guard let url = self.getURLForNoteSound(note) else {
			print("Not a valid sound url")
			return
		}
		
		do {
			///Create a player and play it. This will cause a slight delay since the player hasn't had time to buffer.
			let player = try AVAudioPlayer(contentsOf: url)
			player.play()
			
			self.player = player
		} catch {
			print("Note audiofile with url: " + url.description + " was not found")
		}
	}
}
