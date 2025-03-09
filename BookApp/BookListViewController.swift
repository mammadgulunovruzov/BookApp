//
//  BookListViewController.swift
//  BookApp
//
//  Created by Mammadgulu Novruzov on 08.03.25.
//

import UIKit
import CoreData

class BookListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    
    
    var userName: String?
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 140
        
        
        welcomeLabel.text = "Welcome \(userName ?? "")"
        
        // Add Bookmarks button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .bookmarks,
            target: self,
            action: #selector(bookmarksButtonTapped)
        )
        
        books = [
            Book(title: "Idiot",
                 author: "Fyodor Dostoevski",
                 description: "Dostoyevski bu romanıyla ideal bir insan olaraq yaşamanın çətinliklərinə toxunur.",
                 imageName: "idiot",
                 isBookmarked: false),
            Book(title: "Zərdüşt Belə Dedi",
                 author: "Fridrix Nitsşe",
                 description: "Əsərin dili şeir ilə adi yazı arasındadır.",
                 imageName: "zerdust",
                 isBookmarked: false),
            Book(title: "Milçəklərin Tanrısı",
                 author: "Vilyam Qoldinq",
                 description: "Qoldinqin romanındakı uşaqlar sivil cəmiyyəti qurmağa çalışırlar.",
                 imageName: "milcekler",
                 isBookmarked: false),
            Book(title: "Mutlu Prens",
                 author: "Oscar Wilde",
                 description: "Oscar Wilde uşaqlar üçün məşhur hekayə.",
                 imageName: "mutluprens",
                 isBookmarked: false),
            Book(title: "Tutunamayanlar",
                 author: "Oğuz Atay",
                 description: "Türk ədəbiyyatının ən mühüm romanlarından biri.",
                 imageName: "tutunamayanlar",
                 isBookmarked: false),
            Book(title: "Əli və Nino",
                 author: "Yusif Vəzir Çəmənzəminli",
                 description: "Azərbaycanlı oğlan və gürcü qızın sevgi hekayəsi.",
                 imageName: "aliNino",
                 isBookmarked: false)
        ]
        
        for i in 0..<books.count {
            let bookmarked = CoreDataManager.shared.isBookBookmarked(book: books[i])
            books[i].isBookmarked = bookmarked
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func bookmarksButtonTapped() {
        performSegue(withIdentifier: "toBookmarks", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let book = books[indexPath.row]
        
        cell.backgroundColor = UIColor.systemGray4

        
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.description
        
        
        cell.imageView?.image = UIImage(named: book.imageName)
        
        let bookmarkIcon = book.isBookmarked ? "bookmark.fill" : "bookmark"
        cell.accessoryView = UIImageView(image: UIImage(systemName: bookmarkIcon))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var book = books[indexPath.row]
        
        if book.isBookmarked {
            CoreDataManager.shared.removeBookmark(book: book)
            book.isBookmarked = false
        } else {
            CoreDataManager.shared.addBookmark(book: book)
            book.isBookmarked = true
        }
        
        books[indexPath.row] = book
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    

}


