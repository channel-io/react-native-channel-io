//
//  ManagerState.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

struct ManagersState: StateType {
  var managerDictionary: [String: CHManager] = [:]
  var followingManagers: [CHManager] = []
  
  func findBy(id: String?) -> CHManager? {
    guard let id = id else { return nil }
    return self.managerDictionary[id]
  }

  func findBy(ids: [String]) -> [CHManager] {
    return self.managerDictionary.filter({ ids.index(of: $0.key) != nil }).map({ $1 })
  }
  
  mutating func upsertFollowing(managers: [CHManager]) -> ManagersState {
    self.followingManagers = managers
    return self
  }
  
  mutating func upsert(managers: [CHManager]) -> ManagersState {
    managers.forEach({ self.managerDictionary[$0.id] = $0 })
    return self
  }
  
  mutating func remove(managerId: String) -> ManagersState {
    self.managerDictionary.removeValue(forKey: managerId)
    return self
  }
  
  mutating func clear() -> ManagersState {
    self.managerDictionary.removeAll()
    self.followingManagers.removeAll()
    return self
  }
  
}
