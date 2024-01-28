//
//  RoundRectLabel.swift
//  quChina
//
//  Created by 235 on 1/24/24.
//

import UIKit

//protocol RoundRectLabelDelegate: AnyObject {
//    func labelDidTap(_ text: String)
//}
class RoundedRectLabel: UIView {
    let label = UILabel()
    let cornerRadius: CGFloat = 5.0
    let padding: CGFloat = 5
    var text: String = ""
    var textlineArray: [String] = []
//    weak var delegate: RoundRectLabelDelegate?

    override init(frame: CGRect) {
        super.init(frame:frame)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = text
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                 label.topAnchor.constraint(equalTo: topAnchor, constant: padding),
                 label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                 label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                 label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
             ])
        backgroundColor = .gray
        layer.cornerRadius = cornerRadius
        layer.opacity = 0.4
    }
//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(text )
    }
    func setText(text: String) {
            label.text = text
            setNeedsDisplay()
        }
//    func setText(text: String) {
//        textlineArray = text.components(separatedBy: "\n")
//        var previousLabel: UILabel?
//        for text in textlineArray {
//            let labeling = UILabel()
//            labeling.textColor = .red
//            labeling.font = UIFont.systemFont(ofSize: 16)
//            labeling.textAlignment = .left
//            labeling.numberOfLines = 0
//            labeling.text = text
//            addSubview(labeling)
//            labeling.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                     labeling.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
//                     labeling.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//                 ])
//            if let previousLabel = previousLabel {
//                     // Set topAnchor of the current label to the bottomAnchor of the previous label with padding
//                     labeling.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: padding).isActive = true
//                 } else {
//                     // If it's the first label, set topAnchor to the topAnchor of the RoundedRectLabel
//                     labeling.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
//                 }
//                 previousLabel = labeling
//            labeling.isUserInteractionEnabled = true
//            labeling.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_ :))))
//        }
//        setNeedsDisplay()
//    }
//    @objc private func labelTapped(_ gesture: UITapGestureRecognizer) {
//        guard let tappedLabel = gesture.view as? UILabel, let taptext = tappedLabel.text else {
//            return
//        }
//        delegate?.labelDidTap(taptext)
//
//
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
