//
//  BookAPIClient.swift
//  LibraryApp
//
//  Created by Anders Carling on 16-12-18.
//  Copyright © 2016 Example. All rights reserved.
//

import Foundation

import Alamofire
import LibraryAPI


class BookAPIClient {
    static let url = "http://localhost:8080/books"
    func load(_ completion: @escaping ([Book]?) -> Void) {
        let req = Alamofire.request(BookAPIClient.url)
        req.responseProtobuf { (response: DataResponse<LibraryAPI_Responses_GetBooks>) in
            guard let msg = response.result.value else {
                completion(nil)
                return
            }

            let books = msg.booksArray
                .flatMap { $0 as? LibraryAPI_Book }
                .map { Book(id: Int($0.id_p), author: $0.author, title: $0.title)}
            completion(books)
        }
    }

    func post(_ book: Book) -> Void {
        let req = Alamofire.request(BookAPIClient.url, method: .post, encoding: ProtobufEncoding(message: serialize(book)))
        req.response {
            if $0.error != nil {
                print("OH NOES! :(:( - \($0)")
            }
        }
    }

    private func serialize(_ book: Book) -> LibraryAPI_Book {
        let message = LibraryAPI_Book()
        message.id_p = Int32(book.id)
        message.author = book.author
        message.title = book.title
        return message
    }
}
