//
//  ProfileCollectionViewCell.swift
//  ProfileSofi
//
//  Created by Phil Wright on 6/12/22.
//

import UIKit

public protocol LongPressDelegate: AnyObject {
    func longPressGesturedTapped()
    func toggleButtonsOff()
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!

    public weak var delegate: LongPressDelegate?

    var profile: Profile? {
        didSet {
            if let url = profile?.photoURL {
                self.imageView.imageFromUrl(url: url)
                self.closeButton.isHidden = true
            } else {
                self.imageView.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.imageView.layer.cornerRadius = 8.0
        self.imageView.layer.masksToBounds = true
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressTapped(_:)))
        recognizer.minimumPressDuration = 0.5
        self.contentView.addGestureRecognizer(recognizer)
    }

    @IBAction func closeTapped(_ sender: UIButton) {
        self.imageView.backgroundColor = UIColor.lightGray
        self.imageView.image = nil
        delegate?.toggleButtonsOff()
    }

    @objc func longPressTapped(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.longPressGesturedTapped()
        }
    }

    public func hideCloseButton() {
        self.closeButton.isHidden = true
    }

    public func showCloseButton() {
        self.closeButton.isHidden = false
    }
}
