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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchItems()
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
        
        //Go to details page
        tableView.rx.modelSelected(RecipeModel.self).bind { model in
            print(model.name)
            // Deselect the row after selection
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
            
            
        }.disposed(by: disposeBag)
        
        //Handle deletion
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard var currentData = self?.viewModel.recipes.value else { return }
                currentData.remove(at: indexPath.row)
                self?.context?.delete(currentData[indexPath.row])
                self?.viewModel.recipes.accept(currentData)
                do {
                    try self?.context?.save()
                }catch {
                    //print error
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    @objc func addRecipe(){
        let vc = AddRecipeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}

