//
//  Book.swift
//  LibraryApp
//
//  Created by Anders Carling on 16-12-18.
//  Copyright © 2016 Example. All rights reserved.
//

import Foundation

struct Book {
    let id: Int
    let author: String
    let title: String

    var label:String {
        return "\(author) - \(title)"
    }
}
