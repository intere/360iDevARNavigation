//
//  SessionCell.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import Cartography
import Kingfisher
import UIKit

class SessionCell: UITableViewCell {

    let timeLabel = UILabel()
    let titleLabel = UILabel()
    let locationLabel = UILabel()
    let moreInfoButton = UIButton()
    var speakerViews = [SpeakerView]()

    var session: Session? {
        didSet {
            timeLabel.text = session?.timeLabelText
            titleLabel.text = session?.postTitle.stringByDecodingHTMLEntities
            locationLabel.text = session?.location
            buildView()
        }
    }

    override func prepareForReuse() {
        timeLabel.text = nil
        titleLabel.text = nil
        locationLabel.text = nil
    }

    private func buildView() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        guard let session = session else {
            return
        }
        speakerViews = session.speakers.map { speaker in
            let view = SpeakerView()
            view.speaker = speaker
            return view
        }

        [timeLabel, titleLabel, locationLabel, moreInfoButton].forEach {
            contentView.addSubview($0)
        }
        speakerViews.forEach { contentView.addSubview($0) }
        titleLabel.numberOfLines = 0

        titleLabel.textColor = UIColor(rgb: 0x859d25)
        moreInfoButton.backgroundColor = .black
        moreInfoButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        moreInfoButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        constrain(contentView, timeLabel, titleLabel, locationLabel, moreInfoButton) { (view, timeLabel, titleLabel, locationLabel, moreInfoButton) in

            timeLabel.top == view.top + 4
            timeLabel.left == view.left + 8

            locationLabel.top == timeLabel.top
            locationLabel.left == timeLabel.right + 8
            locationLabel.right == view.right - 8

            titleLabel.top == moreInfoButton.top
            titleLabel.left == timeLabel.left
            titleLabel.right <= moreInfoButton.left - 8

            moreInfoButton.right == view.right - 8
            moreInfoButton.top == locationLabel.bottom + 8
            moreInfoButton.height == 44
        }

        var lastSpeakerView: SpeakerView?
        speakerViews.forEach { speakerView in
            defer {
                lastSpeakerView = speakerView
            }
            if let lastSpeakerView = lastSpeakerView {
                constrain(lastSpeakerView, speakerView) { lastSpeakerView, speakerView in
                    speakerView.top == lastSpeakerView.bottom + 8
                    speakerView.left == lastSpeakerView.left
                }
            } else {
                constrain(titleLabel, moreInfoButton, speakerView) { titleLabel, moreInfoButton, speakerView in
                    titleLabel.bottom <= speakerView.top - 8
                    moreInfoButton.bottom <= speakerView.top - 8
                    speakerView.left == titleLabel.left
                }
            }

            if speakerView == speakerViews.last {
                constrain(contentView, speakerView) { view, speakerView in
                    speakerView.bottom == view.bottom - 8
                }
            }
        }

        if lastSpeakerView == nil {
            constrain(contentView, titleLabel, moreInfoButton) { view, titleLabel, moreInfoButton in
                titleLabel.bottom <= view.bottom - 8
                moreInfoButton.bottom <= view.bottom - 8

            }
        }

        moreInfoButton.setTitle("More info", for: .normal)
        moreInfoButton.addTarget(self, action: #selector(tappedMoreInfo(_:)), for: .touchUpInside)
    }

    @IBAction
    func tappedMoreInfo(_ source: Any) {
        guard let session = session, let url = URL(string: session.url) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

}

class SpeakerView: UIView {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()

    var speaker: Speaker? {
        didSet {
            if let speaker = speaker, let imageUrlString = speaker.imageUrlString,
                let imageUrl = URL(string: imageUrlString) {
                imageView.kf.setImage(with: imageUrl)
            } else {
                imageView.image = nil
            }
            nameLabel.text = speaker?.postTitle
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildView()
    }

    private func buildView() {
        [imageView, nameLabel].forEach { addSubview($0) }

        constrain(self, imageView, nameLabel) { view, imageView, nameLabel in
            imageView.left == view.left
            imageView.top == view.top
            imageView.bottom == view.bottom
            imageView.width == 80
            imageView.height == 80

            nameLabel.centerY == imageView.centerY
            nameLabel.left == imageView.right + 4
            nameLabel.right == view.right
        }
        nameLabel.numberOfLines = 0

        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
    }
}

// MARK: - Session Extensions

extension Session {

    var timeLabelText: String {
        return "\(time) - \(endTime)"
    }

}
