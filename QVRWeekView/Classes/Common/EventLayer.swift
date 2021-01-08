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
        if let gradient = event.getGradientLayer(withFrame: frame) {
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
            eventTextLayer.string = event.getDisplayString(withMainFont: layout.eventLabelFont,
                                                           infoFont: layout.eventLabelInfoFont,
                                                           andColor: layout.eventLabelTextColor)

            eventTextLayer.frame = CGRect(x: frame.origin.x + xPadding,
                                          y: frame.origin.y + yPadding,
                                          width: frame.width - 2*xPadding,
                                          height: frame.height - 2*yPadding)

        case .middle:
            eventTextLayer.string = event.getDisplayRangeString(withFont: layout.eventLabelInfoFont,
                                                                andColor: layout.eventLabelTextColor)

            let boundingSize = CGSize(
                width: frame.width - 2 * xPadding,
                height: frame.height - 2 * yPadding
            )

            let boundingRect = (eventTextLayer.string as? NSAttributedString)?.boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, context: nil)

            eventTextLayer.frame = CGRect(
                x: frame.origin.x + xPadding,
                y: frame.origin.y + yPadding,
                width: boundingRect?.size.width ?? frame.width - 2*xPadding,
                height: boundingRect?.size.height ?? frame.height - 2*yPadding)
            
            eventTextLayer.alignmentMode = .center
            eventTextLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        }
        self.addSublayer(eventTextLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
