//
//  AladinSearchMainViewController.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/14/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class AladinSearchMainViewController: UIViewController, View {
    
    typealias Reactor = AladinSearchReactor
    
    var disposeBag: DisposeBag = DisposeBag()

    weak var delegate: MyViewControllerDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    let loadingSpinner = UIActivityIndicatorView()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    typealias DataSource = UITableViewDiffableDataSource<Int, AladinData?>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, AladinData?>
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupUI()
        setupSearchController()

    }
    
    func setupUI() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(loadingSpinner)
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        setupDiffableDataSource()
    }
    
    func setupSearchController() {
        
        searchController.searchBar.placeholder = "상품을 검색하세요."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["전체", "국내도서", "외국도서", "eBook", "중고샵", "음반", "블루레이"]
        
        let attrFontSetting = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]
        searchController.searchBar.setScopeBarButtonTitleTextAttributes(attrFontSetting, for: .normal)
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    func bind(reactor: AladinSearchReactor) {
        
        tableView.rx.itemSelected
            .map { Reactor.Action.selectedProcut($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .compactMap { [weak self] cell, indexPath in
                guard let snapShot = self?.dataSource.snapshot() else { return false  }
                guard let lastSection = snapShot.sectionIdentifiers.last else { return false }
                
                if indexPath.section == snapShot.numberOfSections - 1 && indexPath.row == snapShot.numberOfItems(inSection: lastSection) - 1 {
                    return true
                }
                return false
            }
            .filter { $0 }
            .map { [weak self] _ in
                return Reactor.Action.loadNextPage(self?.searchController.searchBar.selectedScopeButtonIndex ?? 0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        
        //일반적인 dataSource 사용할때 사용
//        reactor.state
//            .compactMap { $0.searchResult }
//            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: ProductViewCell.self)) { _ , result, cell in
//                cell.configure(with: result)
//            }
//            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.searchResult }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] aladinDatas in
                self?.updateTableView(with: aladinDatas, section: aladinDatas.first?.startIndex)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.productData }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] productData in
                self?.delegate?.myViewControllerDidRequestNavigation(with: productData)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: loadingSpinner.rx.isAnimating)
            .disposed(by: disposeBag)
    }


    private func setupDiffableDataSource() {
        tableView.register(ProductViewCell.self, forCellReuseIdentifier: "ProductViewCell")
        
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductViewCell", for: indexPath) as? ProductViewCell
            
            guard let item = itemIdentifier else { return cell }
           
            cell?.configure(with: item)
            
            return cell
        })
    }
    
    private func updateTableView(with data: [AladinData], section : String? = "0") {
        var snapshot = dataSource.snapshot()
        
        let section = Int(section ?? "0") ?? 0
        snapshot.appendSections([Int(section)])
        snapshot.appendItems(data)
        
        if #available(iOS 15, *) {
            dataSource?.applySnapshotUsingReloadData(snapshot)
        }
        else {
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
}


extension AladinSearchMainViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let snapshot = Snapshot()
        dataSource.apply(snapshot, animatingDifferences: false)
        
        print("scope ---", searchBar.selectedScopeButtonIndex)
        self.reactor?.action.onNext(.search(searchBar.text ?? "", searchBar.selectedScopeButtonIndex))
        searchController.isActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}
