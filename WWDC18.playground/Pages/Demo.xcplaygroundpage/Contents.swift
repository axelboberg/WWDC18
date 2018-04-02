//: # Demo
//: This is a quick demo of the current state of my Tenor-model.
//: The model is intended to classify photographs, not drawings. Therefore I made a separate dataset with less noise in order to better resemble drawings, with data from the complete dataset.
//: However. This, smaller, dataset contains only 700 images, spread across the 7 classes (the middle c on a piano, up to b, all in g-clef). The model gained an accuracy score of 0.92.
import PlaygroundSupport
import UIKit
//: ## Getting started
//: In case you're not very familiar with notes, here's a chart of those that I trained the model with: \
//: ![Chart of notes middle c to b](noteChart.png) \
//: Try it out! Draw a notehead in the canvas, you can always use the undo-button to go back or clear the drawing area.\
//: Notice the classifications shown to the right, most often they will follow the direction of the drawing, proving the potential functionality of the model. You can also compare the result from the model with the algorithm's output shown just below it.
let controller = DemoController()
//: ## It's stuck
//: Since the model isn't as accurate as it would be in production, it will get stuck at notes. Probably as a result of overfitting.
controller.preventClassificationLocking = false
//: Change this variable to `true` in order to have the viewer alternate between the first and second most likely cases, as classified by the model. If the second most likely case has a probability of over 0.1.
controller.preferredContentSize = CGSize(width: 800, height: 600)
PlaygroundPage.current.liveView = controller
