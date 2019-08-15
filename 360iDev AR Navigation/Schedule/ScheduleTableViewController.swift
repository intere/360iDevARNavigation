//
//  ScheduleTableViewController.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/14/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DateEnum.allSorted[section].rawValue
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
        sessionCell.textLabel?.text = schedule[indexPath.row].postTitle


        return sessionCell
    }


}
