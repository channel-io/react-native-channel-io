//
//  LanguageOptionViewController.swift
//  ChannelIO
//
//  Created by Haeun Chung on 09/04/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

class LanguageOptionViewController: BaseViewController {
  let tableView = UITableView(frame: CGRect.zero, style: .grouped).then {
    $0.separatorStyle = .none
  }
  
  let locales = [CHLocaleString.korean, CHLocaleString.english, CHLocaleString.japanese]
  let currentLocale: CHLocaleString? = CHUtils.getLocale()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initNavigation()
    self.initTableView()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    self.tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  func initTableView() {
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.sectionHeaderHeight = 30
    self.tableView.register(cellType: CheckableLabelCell.self)
    self.tableView.backgroundColor = CHColors.lightSnow
    self.view.addSubview(self.tableView)
  }
  
  func initNavigation() {
    self.title = CHAssets.localized("ch.language")
    self.navigationItem.leftBarButtonItem = NavigationItem(
      image:  CHAssets.getImage(named: "back"),
      alignment: .left,
      textColor: mainStore.state.plugin.textUIColor,
      actionHandler: { [weak self] in
        _ = self?.navigationController?.popViewController(animated: true)
      })
  }
}

extension LanguageOptionViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.locales.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CheckableLabelCell = tableView.dequeueReusableCell(for: indexPath)
    let locale = self.locales[indexPath.row]
    cell.checked = self.currentLocale == locale
    
    if locale == .korean {
      cell.titleLabel.text = CHAssets.localized("ch.language.korean")
    } else if locale == .english {
      cell.titleLabel.text = CHAssets.localized("ch.language.english")
    } else if locale == .japanese {
      cell.titleLabel.text = CHAssets.localized("ch.language.japanese")
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 52
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.5
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.addBorders(edges: .bottom, color: CHColors.darkTwo, thickness: 0.5)
    return view
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView().then {
      $0.backgroundColor = CHColors.darkTwo
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let locale = self.locales[indexPath.row]
    mainStore.dispatch(UpdateLocale(payload: locale))
    tableView.deselectRow(at: indexPath, animated: true)
    self.navigationController?.popViewController(animated: true)
  }
}
