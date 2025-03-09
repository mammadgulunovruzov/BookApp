//
//  BookmarksViewController.swift
//  BookApp
//
//  Created by Mammadgulu Novruzov on 08.03.25.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var bookmarkedBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 140
        
        loadBookmarkedBooks()
    }
    
    
    func loadBookmarkedBooks() {
        bookmarkedBooks = CoreDataManager.shared.fetchBookmarkedBooks()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadBookmarkedBooks()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let book = bookmarkedBooks[indexPath.row]
        content.text = book.title
        content.secondaryText = book.description
        content.image = UIImage(named: book.imageName)
        
        cell.contentConfiguration = content
        
        let bookmarkButton = UIButton(type: .custom)
        let iconName = book.isBookmarked ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: iconName), for: .normal)
        bookmarkButton.tintColor = .systemBlue
        bookmarkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        bookmarkButton.addTarget(self, action: #selector(toggleBookmark(_:)), for: .touchUpInside)
        cell.accessoryView = bookmarkButton
        
        return cell
        
        
    }
    
    @objc func toggleBookmark(_ sender: UIButton) {
        let index = sender.tag
        let book = bookmarkedBooks[index]
        
        if book.isBookmarked {
            CoreDataManager.shared.removeBookmark(book: book)
        } else {
            CoreDataManager.shared.addBookmark(book: book)
            
            
        }
        
        loadBookmarkedBooks()
    }
    
    
    
    

}
