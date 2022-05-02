//
//  RepositoryListCell.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import UIKit

class RepositoryListCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with item: Repository) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        createdDateLabel.text = "Created At - \(item.created_at.formattedDate)"
    }

}
