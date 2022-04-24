import UIKit

protocol TableViewCellDelegate {
    func favoriteButtonTapped(cell: UITableViewCell)
}

class SearchResultTableViewCell: UITableViewCell {
    
    var cellDelegation: TableViewCellDelegate?
    private let titleLabel = UILabel()
    private let favoriteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpFavoriteButton()
        setUpTitleLabel()
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor).isActive = true
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
    }
    
    private func setUpFavoriteButton() {
        contentView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        favoriteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        cellDelegation?.favoriteButtonTapped(cell: self)
    }
    
    func bindTableViewCell(item: FoodViewModel) {
        titleLabel.text = item.name
        favoriteButton.setImage(item.image, for: .normal)
    }
}
