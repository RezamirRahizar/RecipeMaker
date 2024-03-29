//
//  RecipeListCell.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import Foundation
import UIKit
import SnapKit

class RecipeListCell: UITableViewCell {
    static let identifier = "RecipeListCell"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        return label
    }()
    
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        contentView.addSubviews([nameLabel, typeLabel, ingredientsLabel])
        
        nameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func setData(data: RecipeItem){
        nameLabel.text = data.name
        typeLabel.text = data.type
        if let ingredients = data.ingredients {
            ingredientsLabel.text = "Ingredients: \(ingredients)"
        }
        
        
        if let imageData = data.imagePath, let image = UIImage(data: imageData) {
            setImage(image: image)
        }
    }
    
    private func setImage(image: UIImage){
        recipeImage.image = image
        
        contentView.addSubview(recipeImage)
    }
}
