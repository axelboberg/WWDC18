import Foundation

public struct StoryData: Codable {
	public var heading: String?
	public var text: String
	public var button: String?
}

public class StoryDataLoader {
	enum StoryDataLoaderError : Error {
		case FileNotFound
	}
	
	/**
	Reads JSON data from the specified file and returns an array of parsed StoryData-objects.
	
	- parameters:
	- file: The path of the file to read
	
	- throws: An instance of StoryDataLoaderError
	
	- returns: An optional array of StoryData objects
	
	*/
	public static func dataFromFile(_ file: String) throws -> [StoryData]? {
		guard let path = StoryDataLoader.getPath(file, type: "json") else {
			throw StoryDataLoaderError.FileNotFound
		}
		
		let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
		
		let decoder = JSONDecoder()
		let sData = try decoder.decode([StoryData].self, from: data)
		
		return sData
	}
	
	/**
	Checks if a file exists by its path and type.
	
	- parameters:
	- forFile: The path to the file to check, without exstension.
	- type: The filetype
	
	- returns: An optional String representing the full path of the file, including the exstension.
	*/
	public static func getPath(_ forFile: String, type: String) -> String? {
		return Bundle.main.path(forResource: forFile, ofType: type)
	}
}
