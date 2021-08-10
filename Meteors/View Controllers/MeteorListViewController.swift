//
//  ViewController.swift
//  Meteors
//
//  Created by bhuvan on 06/08/2021.
//

import UIKit

class MeteorListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var meteorTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    // MARK: - Properties
    internal var meteorViewModel = MeteorViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setup
        setupTableViewAndCell()
        setupSortAndFilterButtons()
        
        // Override light mode
        overrideUserInterfaceStyle = .light
        
        // Fetch meteors from the server if not saved in the user defaults
        fetchMeteorsIfNotAvailable()
        
        // Show placeholder
        setupEmptyListPlaceholderlabel()
    }
    
    // MARK: - Fetch Meteors List
    fileprivate func fetchMeteorsIfNotAvailable() {
        // Fetch meteor list from the server
        if meteorViewModel.getSavedMeteors().count == 0 {
            meteorViewModel.fetchMeteors(completion: handleMeteorResponse)
        } else {
            refreshList()
        }
    }
    
    /// Reload table view after fetching meteors from ths server.
    fileprivate func handleMeteorResponse() {
        // Reload table view
        DispatchQueue.main.async {
            LoaderView.dismiss()
            self.refreshList()
        }
    }
    
    // MARK: - Setup Views
    /// Register table view cell and configure table view.
    fileprivate func setupTableViewAndCell() {
        // Register meteor cell
        let meteorCell = UINib(nibName: "MeteorTableViewCell", bundle: nil)
        meteorTableView.register(meteorCell, forCellReuseIdentifier: MeteorTableViewCell.identifier)
        
        // Table delegate and datasource
        meteorTableView.dataSource = self
        meteorTableView.delegate = self
        meteorTableView.estimatedRowHeight = 250.0
    }
    
    
    /// Styles sort and filter buttons.
    fileprivate func setupSortAndFilterButtons() {
        // Sort and Filter button updates
        let sortImage = UIImage(named: "Sort")!.withRenderingMode(.alwaysTemplate)
        let filterImage = UIImage(named: "Filter")!.withRenderingMode(.alwaysTemplate)
        sortButton.setImage(sortImage, for: .normal)
        filterButton.setImage(filterImage, for: .normal)
        
        // Spacing between image and title
        let spacing: CGFloat = 10
        let sortAndFilterButtons = [sortButton, filterButton]
        sortAndFilterButtons.forEach { button in
            button?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
            button?.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        }
    }
    
    /// Show / Hide placeholder label when there is no meteor available.
    fileprivate func setupEmptyListPlaceholderlabel() {
        if meteorViewModel.getMeteors(for: segmentControl.selectedSegmentIndex).count == 0 {
            let emptyListLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            emptyListLabel.numberOfLines = 0
            emptyListLabel.textAlignment = .center
            emptyListLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
            emptyListLabel.textColor = .darkGray
            emptyListLabel.text = meteorViewModel.getPlaceholderText(segmentControl.selectedSegmentIndex)
            meteorTableView.tableHeaderView = emptyListLabel
        } else {
            meteorTableView.tableHeaderView = nil
        }
    }
    
    // It will reload table view and add placeholder label when no meteors available.
    fileprivate func refreshList() {
        meteorTableView.reloadData()
        setupEmptyListPlaceholderlabel()
    }
    
    // MARK: - Actions
    @IBAction func segmentControlPressed(_ sender: Any) {
        // Reset filter and sorting selection when segment changed
        meteorViewModel.selectedFilterModel = nil
        meteorViewModel.selectedSortByCategory = nil
        refreshList()
    }
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        let sortVC = Storyboard.Main.instantiate(SortMeteorViewController.self)
        sortVC.modalPresentationStyle = .overFullScreen
        sortVC.delegate = self
        sortVC.selectedSortByCategory = meteorViewModel.selectedSortByCategory
        present(sortVC, animated: false, completion: nil)
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let filterVC = Storyboard.Main.instantiate(FilterMeteorViewController.self)
        filterVC.modalPresentationStyle = .overFullScreen
        filterVC.delegate = self
        filterVC.selectedFilterModel = meteorViewModel.selectedFilterModel
        present(filterVC, animated: false, completion: nil)
    }
    
    @IBAction func refreshListButtonPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: meteorViewModel.refreshAlertTitle,
                                        message: meteorViewModel.refreshAlertMessage,
                                        preferredStyle: .alert)
        let yesAction = UIAlertAction(title: meteorViewModel.refreshAlertYesAction,
                                      style: .default) { [weak self] _ in
            
            // Show loader before fetching new meteor list from the server
            LoaderView.show()
            
            // Fetch meteors
            guard let strongSelf = self else { return }
            strongSelf.meteorViewModel.fetchMeteors(completion: strongSelf.handleMeteorResponse)
        }
        let noAction = UIAlertAction(title: meteorViewModel.refreshAlertNoAction,
                                     style: .destructive,
                                     handler: nil)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Table Datasource
extension MeteorListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meteorViewModel.getMeteors(for: segmentControl.selectedSegmentIndex).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meteorCell = tableView.dequeueReusableCell(withIdentifier: MeteorTableViewCell.identifier) as! MeteorTableViewCell
        let meteor = meteorViewModel.getMeteors(for: segmentControl.selectedSegmentIndex) [indexPath.row]
        meteorCell.meteor = meteor
        meteorCell.updateView()
        
        // Pass the delegate only for "Favourite" segment control
        if segmentControl.selectedSegmentIndex == 1 {
            meteorCell.delagate = self
        }
        return meteorCell
    }
}

// MARK: - Table Delegate
extension MeteorListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meteor = meteorViewModel.getMeteors(for: segmentControl.selectedSegmentIndex) [indexPath.row]
        let mapViewController = Storyboard.Main.instantiate(MeteorMapViewController.self)
        mapViewController.meteor = meteor
        mapViewController.delegate = self
        present(mapViewController, animated: true, completion: nil)
    }
}

// MARK: - MeteorTableViewCell Delegate
extension MeteorListViewController: MeteorTableViewCellDelegate {
    func reload(cell: MeteorTableViewCell) {
        refreshList()
    }
}

// MARK: - Filter By Delegate
extension MeteorListViewController: FilterByDelegate {
    func filterBy(_ filterModel: FilterModel) {
        meteorViewModel.selectedFilterModel = filterModel
        refreshList()
    }
}

// MARK: - Sort By Delegate
extension MeteorListViewController: SortByCategoryDelegate {
    
    func sortByCategory(category: Int) {
        meteorViewModel.selectedSortByCategory = category
        refreshList()
    }
}

// MARK: - Meteor Map Delegate
extension MeteorListViewController: MeteorMapDelegate {
    func reloadTableView() {
        refreshList()
    }
}
