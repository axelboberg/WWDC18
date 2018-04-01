import Foundation
import UIKit

public class BackstoryController : UIViewController {
	var pages = [StoryPage]()
	var currentPage: Int = 0
	var animating: Bool = false
	
	public override func loadView() {
		self.view = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
		self.view.backgroundColor = .white
	}
	
	/**
	Load pages into the controller from the specified JSON-file.
	
	- parameters:
	- file: The file from which to load the pages.
	*/
	public func loadPages(from file: String) {
		do {
			guard let stories = try StoryDataLoader.dataFromFile(file) else {
				return
			}
			self.renderPages(from: stories)
		} catch {
			print(error)
		}
	}
	
	/**
	Create and render a page for every StoryData object in the provided array.
	Will show the first page when all pages are rendered.
	
	- parameters:
	- data: An array of StoryData objects to render.
	*/
	private func renderPages(from data: [StoryData]) {
		let pageFrame = CGRect(x: 0, y: 70, width: 800, height: 500)
		
		for pageData in data {
			let page = StoryPage(frame: pageFrame, heading: pageData.heading, text: pageData.text, buttonLabel: pageData.button, textMargin: 100)
			page.onButtonClick(self.nextPage)
			self.pages.append(page)
		}
		
		if data.count != 0 {
			self.showPage(0)
		}
	}
	
	/**
	Show a page loaded into the controller by its index with animation.
	
	- parameters:
	- index: The index of the page to show.
	*/
	private func showPage(_ index: Int) {
		if ((index >= self.pages.count)||(index < 0)) {
			return
		}
		
		self.currentPage = index
		self.view.addSubview(self.pages[index])
		self.pages[index].show()
	}
	
	/**
	Hide a page, with animation, that's currently visible by its index.
	
	- parameters:
	- index: The index of the page to hide.
	- completion: An optional handler to call when the animation has finished.
	*/
	private func hidePage(_ index: Int, completion: (() -> Void)?) {
		if ((index >= self.pages.count)||(index < 0)) {
			return
		}
		
		self.pages[index].hide(completion: completion)
	}
	
	/**
	Hide the current page and show the next one loaded into the controller, with animation.
	*/
	private func nextPage() {
		if !self.animating {
			self.animating = true
			self.hidePage(self.currentPage, completion: { () in
				self.animating = false
				self.showPage(self.currentPage + 1)
			})
		}
	}
}
