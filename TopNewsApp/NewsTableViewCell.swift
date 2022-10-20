//
//  NewsTableViewCell.swift
//  TopNewsApp
//
//  Created by Enes Sancar on 20.10.2022.
//

import UIKit

// Önbelleğe almak için tekrar inmemesi için

class NewsTableViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil

    init(
        title:String,
        subtitle: String,
        imageUrl: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageUrl
    }
}

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.size.width - 170,
                                      height: 70 )
        
        subtitleLabel.frame = CGRect(x: 10,
                                     y: 70,
                                     width: contentView.frame.size.width - 170,
                                     height: contentView.frame.size.height/2)
        
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 200,
                                     y: 5,
                                     width: 140,
                                     height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil 
    }
    
    func configure(with viewModel: NewsTableViewModel) {
        
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        // Image
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            
            URLSession.shared.dataTask(with: url) {  data, response , error in
                
                guard let data = data else { return }
                
                if error == nil {
                    
                    viewModel.imageData = data
                    DispatchQueue.main.async {
                        self.newsImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
