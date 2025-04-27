//
//  HistoryArrayShared.swift
//  lifecounter
//
//  Created by George Lee on 4/26/25.
//

import Foundation

class Items {
    static let HistoryArrayShared = Items()
    var historyArray = [String]()

    func addItem(_ item: String) {
        historyArray.append(item)
        NotificationCenter.default.post(name: .historyArrayUpdated, object: nil)
    }
    
    func clearTableView() {
        historyArray.removeAll()
        NotificationCenter.default.post(name: .historyArrayUpdated, object: nil)
    }
}


extension Notification.Name {
    static let historyArrayUpdated = Notification.Name("historyArrayUpdated")
}
