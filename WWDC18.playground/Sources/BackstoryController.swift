import Foundation
import UIKit

public class BackstoryController : UIViewController {
	var pages = [StoryPage]()
	var currentPage: Int = 0
	
	public override func loadView() {
		self.view = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
		self.view.backgroundColor = .white
	}
	
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
	
	private func renderPages(from data: [StoryData]) {
		let pageFrame = CGRect(x: 0, y: 70, width: 800, height: 500)

		for pageData in data {
			let page = StoryPage(frame: pageFrame, heading: pageData.heading, text: pageData.text, buttonLabel: pageData.button, textMargin: 100)
			page.onButtonClick(self.nextPage)
			self.pages.append(page)
		}
		
		self.showPage(0)
	}
	
	private func showPage(_ index: Int) {
		if ((index >= self.pages.count)||(index < 0)) {
			return
		}
		
		self.currentPage = index
		self.view.addSubview(self.pages[index])
		self.pages[index].show()
	}
	
	private func hidePage(_ index: Int, completion: (() -> Void)?) {
		if ((index >= self.pages.count)||(index < 0)) {
			return
		}
		
		self.pages[index].hide(completion: completion)
	}
	
	private func nextPage() {
		self.hidePage(self.currentPage, completion: { () in
			self.showPage(self.currentPage + 1)
		})
	}
}
