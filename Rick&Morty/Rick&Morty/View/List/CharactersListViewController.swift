//
//  CharactersListViewController.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import UIKit
import Combine

final class CharactersListViewController: UIViewController, LoaderPresenting {
    @IBOutlet weak var charactersTableView: UITableView!
    
    private let viewModel: CharactersListViewModel
    private var subscribers = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        bindView()
        viewModel.showCharacters()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Binding
    private func bindView() {
        viewModel.fetchedError
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else  {
                    return
                }
                self.showError(error as NSError)
            }.store(in: &subscribers)
        
        
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else {
                    return
                }
                isLoading ? self.showLoader() : self.stopLoader()
                
            }.store(in: &subscribers)
        
        viewModel.displayedCharacters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.refreshControl.endRefreshing()
                self.charactersTableView.reloadData()
            }.store(in: &subscribers)
    }
    
    @objc private func refreshData(_ sender: Any) {
        viewModel.showCharacters()
    }
}

private extension CharactersListViewController {
    
    //MARK: - TableViewSettings
    func setUpTableView() {
        let cellNib = UINib(nibName: "CharacterCell", bundle: nil)
        charactersTableView.register(cellNib, forCellReuseIdentifier: CharacterCell.ListCellId)
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
        charactersTableView.refreshControl = refreshControl
        charactersTableView.register(ListHeaderView.self, forHeaderFooterViewReuseIdentifier: ListHeaderView.headerID)
        refreshControl.addTarget(self, action: #selector(CharactersListViewController.refreshData(_:)), for: .valueChanged)
    }
    
    func showError(_ error: NSError) {
        let alertController = UIAlertController(title: "Oops", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - TableViewDataSource
extension CharactersListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ListHeaderView.headerID) as? ListHeaderView else {
               return UITableViewHeaderFooterView()
           }
        header.configure(firstText: viewModel.listHeaderName)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.ListCellId,
                                                            for: indexPath) as? CharacterCell else { return UITableViewCell() }
        let character = viewModel.displayedCharacters.value[indexPath.row]
        cell.setUpData(data: character)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedCharacters.value.count
    }
    
}

//MARK: - TableViewDelegate
extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailScreen = DetailViewController(viewModel: DetailViewModel(characterData: viewModel.displayedCharacters.value[indexPath.row]))
    
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
}
