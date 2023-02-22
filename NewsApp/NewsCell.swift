//
//  NewsCell.swift
//  NewsApp
//
//  Created by Enes Sancar on 21.02.2023.
//

import UIKit

class NewsCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, subtitle: String, imageURL: URL?, imageData: Data?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.imageData = imageData
    }
}

class NewsCell: UITableViewCell {
    static let identifier: String = "NewsCell"
    
    //MARK: - Properties
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 4
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .secondarySystemBackground
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        return image
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ERROR")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            newsImageView.widthAnchor.constraint(equalToConstant: 140),
            newsImageView.heightAnchor.constraint(equalToConstant: contentView.frame.size.height - 14),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            newsTitleLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        if let imageData = viewModel.imageData {
            newsImageView.image = UIImage(data: imageData)
        }
        else if let imageUrl = viewModel.imageURL {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                guard let data = data , error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
