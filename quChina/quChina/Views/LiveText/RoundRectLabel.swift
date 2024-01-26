//
//  RoundRectLabel.swift
//  quChina
//
//  Created by 235 on 1/24/24.
//

import UIKit

class RoundedRectLabel: UIView {
    let label = UILabel()
    let cornerRadius: CGFloat = 5.0
    let padding: CGFloat = 5
    var text: String = ""

    override init(frame: CGRect) {
        super.init(frame:frame)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
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
        backgroundColor = .black
               layer.cornerRadius = cornerRadius
               layer.opacity = 0.75
    }
    func setText(text: String) {
        label.text = text
        setNeedsDisplay()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
