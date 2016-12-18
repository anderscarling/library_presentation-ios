//
//  ViewController.swift
//  Library API
//
//  Created by Anders Carling on 16-12-18.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    let bookAPI = BookAPIClient()
    var data:[Book] = []

    // MARK: Events

    @IBAction func refresh(_ sender: Any) {
        bookAPI.load { books in
            self.data = books ?? []
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    @IBAction func newBook(_ sender: Any) {
        let id = data.map { $0.id }.reduce(0) { res, val in
            res > val ? res : val
        }
        let book = Book(id: id, author: "New Bookwriter", title: "New Title")
        bookAPI.post(book)
    }

    // MARK: TableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row].label
        return cell
    }


}

