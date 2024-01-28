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

    override init(frame: CGRect) {
        super.init(frame:frame)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
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
        backgroundColor = .darkGray
        layer.cornerRadius = cornerRadius
        layer.opacity = 0.6
    }
    func setText(text: String) {
            label.text = text
            setNeedsDisplay()
        }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
