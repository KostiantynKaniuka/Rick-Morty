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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        bindView()
        viewModel.showCharacters()

    }
    
    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindView() {
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
    
    func setUpTableView() {
        let nib = UINib(nibName: "CharacterCell", bundle: nil)
        charactersTableView.register(nib, forCellReuseIdentifier: CharacterCell.ListCellId)
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
        charactersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(CharactersListViewController.refreshData(_:)), for: .valueChanged)
    }
}


extension CharactersListViewController: UITableViewDataSource {
    
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

extension CharactersListViewController: UITableViewDelegate {
    
}

