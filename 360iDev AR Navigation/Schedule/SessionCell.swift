//
//  SessionCell.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import Cartography
import UIKit

class SessionCell: UITableViewCell {

    let timeLabel = UILabel()
    let titleLabel = UILabel()
    let locationLabel = UILabel()
    let moreInfoButton = UIButton()

    var session: Session? {
        didSet {
            timeLabel.text = session?.timeLabelText
            titleLabel.text = session?.postTitle.stringByDecodingHTMLEntities
            locationLabel.text = session?.location.rawValue
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildView()
    }

    override func prepareForReuse() {
        timeLabel.text = nil
        titleLabel.text = nil
        locationLabel.text = nil
    }

    private func buildView() {
        [timeLabel, titleLabel, locationLabel, moreInfoButton].forEach {
            contentView.addSubview($0)
        }
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
            titleLabel.bottom <= view.bottom - 8

            moreInfoButton.right == view.right - 8
            moreInfoButton.top == locationLabel.bottom + 8
            moreInfoButton.height == 44

            moreInfoButton.bottom <= view.bottom - 8
        }

        moreInfoButton.setTitle("More Info", for: .normal)
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
    // 859d25
}

// MARK: - Session Extensions

extension Session {

    var timeLabelText: String {
        return "\(time) - \(endTime)"
    }

}
