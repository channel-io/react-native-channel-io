//
//  ProfileViewController.swift
//  CHPlugin
//
//  Created by Haeun Chung on 18/05/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SVProgressHUD
import SnapKit
import RxSwift
import ReSwift

private enum ProfileSection: Int {
  case action
}

private enum UserInfoRow: Int {
  case name
  case phone
}

private enum ActionRow: Int {
  case languageOption
  case translateOption
  case closedChats
  case soundOption
}

final class ProfileViewController: BaseViewController {
  struct Constant {
    static let sectionCount = 2
    static let userInfoCount = 2
    static let actionCount = 3
  }
  
  let tableView = UITableView()
  let footerView = UIView()
  let logoImageView = UIImageView().then {
    $0.image = CHAssets.getImage(named: "channelSymbol")
    $0.contentMode = .center
  }
  let versionLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 10)
    $0.textColor = CHColors.blueyGrey
  }
  
  let headerView = ProfileHeaderView()
  let deleteSubject = PublishSubject<Any?>()
  let disposeBag = DisposeBag()
  
  //var panGestureRecognizer: UIPanGestureRecognizer? = nil
  //var originalPosition: CGPoint?
  //var currentPositionTouched: CGPoint?
  
  var hideOptions = false
  var showCompleted = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    self.initNavigation()
    self.initTableView()
    self.initViews()
    self.handleActions()
    
    self.footerView.addSubview(self.versionLabel)
    self.footerView.addSubview(self.logoImageView)
    self.view.addSubview(self.tableView)
    self.view.addSubview(self.footerView)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainStore.subscribe(self)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mainStore.unsubscribe(self)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    self.tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    self.footerView.snp.makeConstraints { (make) in
      make.height.equalTo(48)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    self.logoImageView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(10)
    }
    
    self.versionLabel.snp.makeConstraints { [weak self] (make) in
      make.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo((self?.logoImageView.snp.bottom)!)
    }
  }
  
  func initNavigation() {
    self.navigationItem.leftBarButtonItem = NavigationItem(
      image: CHAssets.getImage(named: "exit"),
      textColor: mainStore.state.plugin.textUIColor,
      actionHandler: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      }
    )
  }
  
  func initTableView() {
    if #available(iOS 11.0, *) {
      self.tableView.contentInsetAdjustmentBehavior = .never
    } else {
      self.automaticallyAdjustsScrollViewInsets = false
    }
    
    self.tableView.separatorStyle = .none
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.isScrollEnabled = false
    
    let channel = mainStore.state.channel
    let height:CGFloat = channel.homepageUrl != "" || channel.phoneNumber != "" ? 180 : 110
    self.headerView.frame = CGRect(
      x: 0, y: 0,
      width: self.tableView.width,
      height: height
    )
    self.tableView.tableHeaderView = self.headerView
  }
  
  func initViews() {
    if let version = Bundle(for: ChannelIO.self)
      .infoDictionary?["CFBundleShortVersionString"] as? String {
      self.versionLabel.text = "v\(version)"
    }
  }
  
  func handleActions() {
    self.logoImageView.signalForClick()
      .subscribe(onNext: { _ in
        let channel = mainStore.state.channel
        let channelName = channel.name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = CHUtils.getUrlForUTM(source: "plugin_exposure", content: channelName)

        if let url = URL(string: urlString) {
          url.open()
        }
      }).disposed(by: self.disposeBag)
  }
  
  func signalForDelete() -> Observable<Any?> {
    return self.deleteSubject
  }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.hideOptions ? Constant.sectionCount - 1 : Constant.sectionCount
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case ProfileSection.action.rawValue:
      if self.hideOptions {
        return 0
      }
      
      return Constant.actionCount
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
    case (ProfileSection.action.rawValue,
          ActionRow.languageOption.rawValue):
      let cell = LabelCell()
      cell.arrowImageView.isHidden = false
      
      let locale = CHUtils.getLocale()
      if locale == .english {
        cell.titleLabel.text = CHAssets.localized("ch.language.english")
      } else if locale == .korean {
        cell.titleLabel.text = CHAssets.localized("ch.language.korean")
      } else if locale == .japanese {
        cell.titleLabel.text = CHAssets.localized("ch.language.japanese")
      }
      
      return cell
    case (ProfileSection.action.rawValue,
          ActionRow.translateOption.rawValue):
      let cell = SwitchCell()
      let isOn = mainStore.state.userChatsState.showTranslation
      cell.switchSignal.subscribe { event in
        mainStore.dispatch(UpdateVisibilityOfTranslation(show: event.element!))
      }.disposed(by: self.disposeBag)
      cell.selectionStyle = .none
      cell.configure(title: CHAssets.localized("ch.settings.show_translation"), isOn: isOn)
      return cell
    case (ProfileSection.action.rawValue,
          ActionRow.closedChats.rawValue):
      let cell = SwitchCell()
      let isOn = mainStore.state.userChatsState.showCompletedChats
      cell.switchSignal.subscribe { event in
        mainStore.dispatch(UpdateVisibilityOfCompletedChats(show: event.element))
      }.disposed(by: self.disposeBag)
      cell.selectionStyle = .none
      cell.configure(title: CHAssets.localized("ch.settings.show_closed_chat"), isOn: isOn)
      return cell
    default:
      return  UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (ProfileSection.action.rawValue,
          ActionRow.languageOption.rawValue):
      let controller = LanguageOptionViewController()
      self.navigationController?.pushViewController(controller, animated: true)
    default:
      break
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case ProfileSection.action.rawValue:
      return LabelCell.height()
    default:
      return 40
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case ProfileSection.action.rawValue:
      return 10
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case ProfileSection.action.rawValue:
      return UIView()
    default:
      return nil
    }
  }
}

extension ProfileViewController : StoreSubscriber {
  func newState(state: AppState) {
    self.title = CHAssets.localized("ch.settings.title")
    
    let height:CGFloat = state.channel.homepageUrl != "" || state.channel.phoneNumber != "" ? 180 : 110
    self.headerView.frame = CGRect(
      x: 0, y: 0,
      width: self.tableView.width,
      height: height
    )
    self.headerView.configure(
      plugin: state.plugin,
      channel: state.channel
    )

    let showCompleted = state.userChatsState.showCompletedChats
    if self.showCompleted != showCompleted {
      self.showCompleted = showCompleted
      self.fetchUserChats(showCompleted)
    }
    
    self.tableView.reloadData()
  }

  func fetchUserChats(_ showCompleted: Bool) {
    SVProgressHUD.show()
    
    UserChatPromise.getChats(since: nil, limit: 30, showCompleted: showCompleted)
      .subscribe(onNext: { (data) in
        mainStore.dispatch(GetUserChats(payload: data))
      }, onError: { [weak self] error in
        dlog("Get UserChats error: \(error)")
        SVProgressHUD.dismiss()
        self?.tableView.reloadData()
      }, onCompleted: { [weak self] in
        dlog("Get UserChats complete")
        SVProgressHUD.dismiss()
        self?.tableView.reloadData()
      }).disposed(by: self.disposeBag)
  }
  
  func openAgreement() {
    let locale = CHUtils.getLocale() ?? .korean
    let url = "https://channel.io/" +
      locale.rawValue +
      "/terms_user?channel=" +
      (mainStore.state.channel.name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
    
    guard let link = URL(string: url) else { return }
    link.open()
  }
}
