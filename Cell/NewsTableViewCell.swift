//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Islam  EU on 24/1/24.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String,
         subtitle: String,
         imageURL: URL?) {
        
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
    
}


class NewsTableViewCell: UITableViewCell {
    
   static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
       let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 22, weight: .semibold)
        return view
    }()
    
    private let subTitleLabel: UILabel = {
       let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 17, weight: .light)
        return view
    }()
    
    private let newsImageView: UIImageView = {
       let view = UIImageView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.backgroundColor = .secondarySystemBackground
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier  )
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.size.width - 170,
                                      height: 70)
        
        subTitleLabel.frame = CGRect(x: 10,
                                      y: 70,
                                      width: contentView.frame.size.width - 170,
                                      height: contentView.frame.size.height/2)
        
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 150,
                                      y: 5,
                                     width: 140,
                                      height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewmodel: NewsTableViewCellViewModel) {
        
        newsTitleLabel.text = viewmodel.title
        subTitleLabel.text = viewmodel.subtitle
        
        //Image
        if let data = viewmodel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewmodel.imageURL {
            //fetch
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                   return
                }
                viewmodel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
