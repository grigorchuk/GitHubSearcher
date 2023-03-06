//
//  SearchView.swift
//  UI
//
//  Created by Alex on 01.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import UIKit

public final class SearchView: BaseView {
    
    public let tableView = UITableView()
    public let searchBar = UISearchBar()
    
    public override init() {
        super.init()
        
        setupView()
        backgroundColor = .white
    }
    
    private func setupView() {
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Enter repository name"
        
        addSubview(searchBar)
        searchBar.layout {
            $0.top.equal(to: safeAreaLayoutGuide.topAnchor)
            $0.leading.equal(to: leadingAnchor)
            $0.trailing.equal(to: trailingAnchor)
            $0.height.equal(to: 48.0)
        }
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        
        addSubview(tableView)
        tableView.layout {
            $0.top.equal(to: searchBar.bottomAnchor)
            $0.leading.equal(to: leadingAnchor)
            $0.trailing.equal(to: trailingAnchor)
            $0.bottom.equal(to: bottomAnchor)
        }
    }
}
