//
//  ScheduleTableViewController.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import Cartography
import UIKit

class ScheduleTableViewController: UITableViewController {

    class func loadFromStoryboard() -> ScheduleTableViewController {
        return UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "ScheduleTableViewController") as! ScheduleTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return DateEnum.allSorted.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderView()
        view.date = DateEnum.allSorted[section]
        view.buildView()

        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let schedule = ScheduleService.shared.schedule[DateEnum.allSorted[section]]
        return schedule?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Session", for: indexPath)

        guard let sessionCell = cell as? SessionCell,
            let schedule = ScheduleService.shared.schedule[DateEnum.allSorted[indexPath.section]],
            indexPath.row < schedule.count else {
                return cell
        }
        sessionCell.session = schedule[indexPath.row]


        return sessionCell
    }

}

class HeaderView: UIView {
    private let label = UILabel()
    var date: DateEnum? {
        didSet {
            label.text = date?.rawValue
        }
    }

    func buildView() {
        addSubview(label)
        label.textColor = .black
        backgroundColor = .lightGray

        constrain(self, label) { view, label in
            label.top == view.top + 8
            label.left == view.left + 8
            label.right == view.right - 8
            label.bottom == view.bottom + 8
        }

        label.font = UIFont.boldSystemFont(ofSize: 20)
    }
}
