import UIKit

class History: UIViewController {
    let historyTable = UITableView()
    var data: [String] {
        return Items.HistoryArrayShared.historyArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: .historyArrayUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTable() {
        view.addSubview(historyTable)
        historyTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        historyTable.delegate = self
        historyTable.dataSource = self
        historyTable.rowHeight = 30
        historyTable.backgroundColor = .lightGray

        historyTable.translatesAutoresizingMaskIntoConstraints = false
        historyTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        historyTable.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        historyTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        historyTable.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }

    
    @objc func updateTable() {
        historyTable.reloadData()
    }
}

extension History: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
