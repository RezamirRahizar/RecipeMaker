//
//  ViewController.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class RecipeListViewController: UIViewController {
    let context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeListCell.self, forCellReuseIdentifier: RecipeListCell.identifier)
        return tableView
    }()
    
    private lazy var viewModel: RecipeListViewModel = {
        let viewModel = RecipeListViewModel(context: context, targetVC: self)
        
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        layoutViews()
        bindViewModel()
    }
    
    private func setupViews(){
        navigationItem.title = "Recipe List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addRecipe))
        view.backgroundColor = .white
        
        view.addSubview(tableView)
    }
    
    private func layoutViews(){
        tableView.frame = view.bounds
    }
    
    private func bindViewModel(){
        viewModel.recipes.bind(to: tableView.rx.items(cellIdentifier: RecipeListCell.identifier,
                                                      cellType: RecipeListCell.self)){ row, item, cell in
            cell.setData(data: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RecipeModel.self).bind { model in
            print(model.name)
            // Deselect the row after selection
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }.disposed(by: disposeBag)
        
        viewModel.fetchItems()
    }
    
    @objc func addRecipe(){
        let vc = AddRecipeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}
