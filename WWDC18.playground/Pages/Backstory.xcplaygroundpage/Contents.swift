//: # Backstory
//: ## Note
//: *use of unresolved identifier 'BackstoryController'*
//: This is an error raised when the files in the *Sources* folder hasn't been loaded and hence those classes have not been declared. Wait a while and the program should start running. If it doesn't, try recompiling and you should be able to run the code.
import PlaygroundSupport
import UIKit
let controller = BackstoryController()
//: ## What this is
//: A compressed story of why, and how, I'm developing this model, dynamically loaded from the .json file "storyData".
controller.loadPages(from: "storyData")
controller.preferredContentSize = CGSize(width: 800, height: 600)
PlaygroundPage.current.liveView = controller
//: [Next](@next)
