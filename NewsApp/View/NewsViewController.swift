//
//  ViewController.swift
//  NewsApp
//
//  Created by Islam  EU on 24/1/24.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    private let newsTableView: UITableView = {
        let view  = UITableView()
        view.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return view
    }()
    
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupUI()
        getData()
        setupConstraints()
    }

    private func setupUI() {
        title = "News"
        view.backgroundColor = .systemBackground
        
        view.addSubview(newsTableView)
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    private func getData() {
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "No Description",
                                               imageURL: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func setupConstraints() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newsTableView.frame = view.bounds
    }
    
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)  as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsTableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
