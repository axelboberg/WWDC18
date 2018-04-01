//: # Demo
//: A quick demo of the current state of my Tenor-model.
//: A work in progress that's supposed to recognize the basic notes from photographs of a score by image classification.
import PlaygroundSupport
import UIKit

let controller = DemoController();
//: The model is intended to classify photographs, not drawings. Therefore I made a separate dataset with less noise in order to better resemble drawings, with data from the complete dataset.
//: However. That dataset contains only 700 images, spread across the 7 classes (middle c, up to b). The model gained an accuracy score of 0.92.
 
//: Since the model isn't as accurate as it would be in production, it will get stuck at notes. Probably as a result of overfitting.
//: Change this variable to `true` in order to display the second most likely classification in the viewer if the first one is shown twice in a row and the probability of the second most likely case is above 0.1.
controller.preventClassificationLocking = false
//: Notice the classifications shown to the right, most often they will follow the direction of the drawing, proving the potential functionality of the model.
controller.preferredContentSize = CGSize(width: 800, height: 600)
PlaygroundPage.current.liveView = controller
