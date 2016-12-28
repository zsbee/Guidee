import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	let duration = 0.6
	var presenting = true
	var originFrame = CGRect.zero
	var dismissCompletion: (()->Void)?
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let containerView = transitionContext.containerView
		let toView = transitionContext.view(forKey: .to)!
		let eventView = presenting ? toView : transitionContext.view(forKey: .from)!
		
		let initialFrame = presenting ? originFrame : eventView.frame
		let finalFrame = presenting ? eventView.frame : originFrame
		
		let xScaleFactor = presenting ? (initialFrame.width / finalFrame.width) : (finalFrame.width / initialFrame.width)
		let yScaleFactor = presenting ?	(initialFrame.height / finalFrame.height) : (finalFrame.height / initialFrame.height)
		
		let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
		
		if presenting {
			eventView.transform = scaleTransform
			eventView.clipsToBounds = true
		}
		containerView.addSubview(toView)
		containerView.bringSubview(toFront: eventView)
		eventView.alpha = self.presenting ? 0 : 1
		UIView.animate(withDuration: duration, delay:0.0,
		               usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0,
		               animations: {
						eventView.alpha = self.presenting ? 1 : 0
						eventView.transform = self.presenting ? CGAffineTransform.identity : CGAffineTransform.identity
		},
		               completion:{_ in
						if !self.presenting {
							self.dismissCompletion?()
						}
						transitionContext.completeTransition(true)}
		)
	}
}
