//
//  EventLayer.swift
//  QVRWeekView
//
//  Created by Reinert Lemmens on 25/08/2019.
//

import Foundation

class EventLayer: CALayer {
    override init(layer: Any) {
        super.init(layer: layer)
    }

    init(withFrame frame: CGRect, layout: DayViewCellLayout, andEvent event: EventData) {
        super.init()
        self.bounds = frame
        self.frame = frame

        // Configure gradient and colour layer
        if let gradient = event.getGradientLayer(withFrame: getGradientFrame(for: frame, layout: layout)) {
            self.backgroundColor = UIColor.clear.cgColor
            self.addSublayer(gradient)
        } else {
            self.backgroundColor = event.color.cgColor
        }

        // Configure event text layer
        let eventTextLayer = CATextLayer()
        eventTextLayer.isWrapped = true
        eventTextLayer.contentsScale = UIScreen.main.scale

        let xPadding = layout.eventLabelHorizontalTextPadding
        let yPadding = layout.eventLabelVerticalTextPadding

        switch event.position {
        case .top:
//            if frame.height - 2*yPadding
            let attributedString = event.getDisplayString(
                withMainFont: layout.eventLabelFont,
                infoFont: layout.eventLabelInfoFont,
                andColor: layout.eventLabelTextColor
            )
            eventTextLayer.string = attributedString
            let boundingSize = CGSize(
                width: frame.width - 2 * xPadding,
                height: frame.height - 2 * yPadding
            )
            eventTextLayer.frame = CGRect(x: frame.origin.x + xPadding,
                                          y: frame.origin.y + yPadding,
                                          width: boundingSize.width,
                                          height: boundingSize.height)

            let boundingRect = attributedString.boundingRect(with: CGSize(width: boundingSize.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            if event.hideOnScale {
                eventTextLayer.isHidden = boundingSize.height < boundingRect.height
            }
        case .middle:
            let attributedString = event.getDisplayRangeString(
                withFont: layout.eventLabelInfoFont,
                andColor: layout.eventLabelTextColor
            )
            eventTextLayer.string = attributedString

            let boundingSize = CGSize(
                width: frame.width - 2 * xPadding,
                height: frame.height - 2 * yPadding
            )

            let boundingRect = attributedString.boundingRect(with: CGSize(width: boundingSize.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)

            eventTextLayer.frame = CGRect(
                x: frame.origin.x + xPadding,
                y: frame.origin.y + yPadding,
                width: boundingSize.width,
                height: boundingSize.height)

            eventTextLayer.alignmentMode = .center
            eventTextLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            if event.hideOnScale {
                eventTextLayer.isHidden = boundingSize.height < boundingRect.height
            }
        }
        self.addSublayer(eventTextLayer)
    }

    private func getGradientFrame(for frame: CGRect, layout: DayViewCellLayout) -> CGRect {
        var gradientFrame = frame
        gradientFrame.origin.x += layout.eventLayerLeftPadding
        gradientFrame.origin.y += layout.eventLayerTopPadding
        gradientFrame.size.width -= (layout.eventLayerLeftPadding + layout.eventLayerRightPadding)
        gradientFrame.size.height -= (layout.eventLayerTopPadding + layout.eventLayerBottomPadding)

        return gradientFrame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
