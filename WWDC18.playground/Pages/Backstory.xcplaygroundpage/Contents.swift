//: # Backstory
//: A compressed story of why, and how, I'm developing this model.
import PlaygroundSupport
import UIKit

let controller = BackstoryController();

controller.loadPages(from: "storyData")

controller.preferredContentSize = CGSize(width: 800, height: 600)
PlaygroundPage.current.liveView = controller
//: [Next](@next)
