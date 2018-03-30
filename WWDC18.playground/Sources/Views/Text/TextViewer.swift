import Foundation
import UIKit

public class TextViewerFrameSize {
    public var width: CGFloat = 0 {
        didSet {
            if self.frame != nil {
                self.frame!.updateRect()
            }
        }
    }
    public var height: CGFloat = 0 {
        didSet {
            if self.frame != nil {
                self.frame!.updateRect()
            }
        }
    }
    public var frame: TextViewerFrame?
    
    fileprivate func setFrame(_ frame: TextViewerFrame) {
        self.frame = frame
    }
}

public class TextViewerFrameOrigin {
    public var x: CGFloat = 0 {
        didSet {
            if self.frame != nil {
                self.frame!.updateRect()
            }
        }
    }
    public var y: CGFloat = 0 {
        didSet {
            if self.frame != nil {
                self.frame!.updateRect()
            }
        }
    }
    public var frame: TextViewerFrame?
    
    fileprivate func setFrame(_ frame: TextViewerFrame) {
        self.frame = frame
    }
}

public class TextViewerFrame {
    var origin: TextViewerFrameOrigin
    var size: TextViewerFrameSize
    
    private var _rect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var rect: CGRect {
        get {
            self.updateRect()
            return self._rect
        }
    }
    
    var hasBeenCalculated: Bool = false
    
    init(x: CGFloat, y: CGFloat, width: CGFloat) {
        self.origin = TextViewerFrameOrigin()
        self.size = TextViewerFrameSize()
        
        self.origin.setFrame(self)
        self.size.setFrame(self)
        
        self.origin.x = x
        self.origin.y = y
        self.size.width = width
    }
    
    /**
    Sets the calculated height of the TextViewerFrame, according to the height of the text-content.
     
    - parameters:
    - height: The new, calculated, height
    */
    fileprivate func setCalculated(height: CGFloat) {
        self.size.height = height
        self.hasBeenCalculated = true
    }
    
    /**
    Updates the TextViewerFrame's rectangle to match the frame's properties
    */
    fileprivate func updateRect() {
        print("Updating text rectangle, new height:")
        print(self.size.height)
        
        self._rect.size.width = self.size.width
        self._rect.size.height = self.size.height
        self._rect.origin.x = self.origin.x
        self._rect.origin.y = self.origin.y
    }
}

public class TextViewer : UIView {
	private var splitterFunction: ((String) -> [TextPart])?
	private var text: String?
	private var parts = [TextPart]()
	
	var wordSpacing: CGFloat = 3
	var rowSpacing: CGFloat = 3
    
    public let vFrame: TextViewerFrame
	
	public init(frame: TextViewerFrame) {
        self.vFrame = frame
        super.init(frame: frame.rect)
		self.splitterFunction = self.defaultSplitter
	}
	
	public convenience init(frame: TextViewerFrame, splitter: @escaping (String) -> [TextPart]) {
		self.init(frame: frame)
		self.splitterFunction = splitter
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/**
		The default splitter function that splits the input text into TextPart objects to render.
		Can be replaced by setting the "splitterFunction" variable after initialization of the TextViewer.
	
		- parameters:
		- text: The text to split
	
		- returns: An array of TextPart objects
	*/
	private func defaultSplitter(text: String) -> [TextPart] {
		
		//Split the text into words by splitting at spaces
		let strArr = text.components(separatedBy: " ")
		
		//Setup basic parameters
		var nextXPos: CGFloat = 0
		var row: Int = 0
		let height: CGFloat = 8
		
		var parts = [TextPart]()
		for word in strArr {
			switch word {
			case "\n":
				nextXPos = 0
				row += 1
				break
			default:
				//Create a new text-part with a frame where only the x- and y-coordinate, as well as the height is valid,
				//a width will be automatically calculated by the UILabel
				let part = TextPart(frame: CGRect(x: nextXPos, y: CGFloat(row) * rowSpacing * height, width: 100, height: height), withText: word)
				
				//Calculate the next x-position in order to render the words with correct spacing
				nextXPos += part.frame.size.width + wordSpacing
				
				//If the next x-position exceeds the width of the text-viewer,
				//increment the row-counter and reset the x-position
				if nextXPos >= self.frame.size.width - 70 {
					nextXPos = 0
					row += 1
				}
				
				parts.append(part)
			}
		}
		
        //Update the frame with the new calculated height
        self.didCalculateHeight(height * CGFloat(row))
        
		return parts
	}
	
	/**
	Sets the text of the TextViewer.
	
	- parameters:
	- text: The text to show as the viewer's content, as a String.
	*/
	public func setText(_ text: String) {
		self.text = text
		
		if self.splitterFunction == nil {
			return
		}
		
		self.parts = self.splitterFunction!(text)
	}
	
	/**
	Shows the content of the view with a basic animation
	*/
	public func showContent() {
		for (i, part) in self.parts.enumerated() {
			part.show(in: self, duration: 0.5, delay: 0.015 * Double(i))
		}
	}
	
	/**
	Hides the content of the view with a basic animation
	*/
	public func hideContent() {
		self.hideContent(completion: nil)
	}
	
	/**
	Hides the content of the view with a basic animation
	
	- parameters:
	- completion: The completion-handler to call when the last TextPart is done animating.
	*/
	public func hideContent(completion: (() -> Void)?) {
		for (i, part) in self.parts.reversed().enumerated() {
			
			var onFinishAnimating: (() -> Void)?
			if i == self.parts.count - 1 { onFinishAnimating = completion }
			
			part.hide(duration: 0.5, delay: 0.015 * Double(i), completion: onFinishAnimating)
		}
	}
    
    /**
    Updates the viewer's frame to match the new, calculated, height.
     
    - parameters:
    - height: The new height as a CGFloat.
    */
    public func didCalculateHeight(_ height: CGFloat) {
        self.vFrame.setCalculated(height: height)
    }
}
