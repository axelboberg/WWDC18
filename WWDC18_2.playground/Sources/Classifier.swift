import Foundation
import UIKit
import CoreML
import Vision

public class Classifier {
	var VNRequest: VNCoreMLRequest!
	var onObservationHandlers = [([VNClassificationObservation]) -> Void]()
	
	public init() {
		do {
			//Set the model to an instance of the TenorModel.
			let model = try VNCoreMLModel(for: TenorModel_rev13().model)
			
			//Create the Vision-request for the initialized model.
			self.VNRequest = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
				self?.processClassifications(for: request, error: error)
			})
			self.VNRequest.imageCropAndScaleOption = .scaleFit
		} catch {
			print("Error loading model")
		}
	}
	
	/**
	Adds a handler to be called on every successful classification.
	
	- parameters:
	- handler: The handler to register. Will access the array of VNClassificationObservation objects. Returns Void.
	*/
	public func onClassification(_ handler: @escaping(_ classification: [VNClassificationObservation]) -> Void){
		self.onObservationHandlers.append(handler)
	}
	
	/**
	Calls all registered OnClassification-handlers with the array of VNClassificationObservation objects.
	
	- parameters:
	- with: The array of VNClassificationObservation objects to include in the calls.
	*/
	private func dispatchOnClassificationHandlers(_ with: [VNClassificationObservation]){
		for handler in self.onObservationHandlers {
			handler(with)
		}
	}
	
	/**
	Classifies an image as a note
	
	- parameters:
	- image: A UIImage to classify.
	*/
	public func classify(_ image: UIImage) {
		DispatchQueue.global(qos: .userInitiated).async {
			let handler = VNImageRequestHandler(ciImage: CIImage(image: image)!, orientation: .up)
			do {
				try handler.perform([self.VNRequest!])
			} catch {
				print("Failed to perform classification.\n\(error.localizedDescription)")
			}
		}
	}
	
	/**
	Processes the classifications for the VNRequest. Dispatches the OnClassification-handlers.
	*/
	func processClassifications(for request: VNRequest, error: Error?) {
		DispatchQueue.main.async {
			guard let results = request.results else {
				print("Unable to classify image.\n\(error!.localizedDescription)")
				return
			}
			
			let classifications = results as! [VNClassificationObservation]
			self.dispatchOnClassificationHandlers(classifications)
		}
	}
}
