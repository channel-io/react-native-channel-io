//
//  CountryCodePickerView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 07/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import RxSwift
import SnapKit

final class CountryCodePickerView : BaseView {

  var countries: [CHCountry] = []
  let disposeBeg = DisposeBag()
  var bottomContraint: Constraint?
  var pickedCode = "" {
    didSet {
      let index = self.countries.index { (country) -> Bool in
        return country.code == self.pickedCode
      }
      if let index = index {
        self.pickerView.selectRow(index, inComponent: 0, animated: false)
        self.selectedIndex = index
      }
    }
  }
  
  var selectedIndex = 0
  
  var submitSubject = PublishSubject<(String, String)>()
  var cancelSubject = PublishSubject<Any?>()
  
  let actionView = UIView()
  let closeButton = UIButton().then {
    $0.setTitleColor(CHColors.dark, for: UIControlState.normal)
    $0.setTitle(CHAssets.localized("ch.mobile_verification.cancel"), for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 17.f)
    
  }
  let submitButton = UIButton().then {
    $0.setTitleColor(CHColors.dark, for: UIControlState.normal)
    $0.setTitle(CHAssets.localized("ch.mobile_verification.confirm"), for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 17.f)
  }
  let pickerView = UIPickerView()
  let pickerContainerView = UIView().then {
    $0.backgroundColor = CHColors.white
  }
  
  let backgroundView = UIView().then {
    $0.backgroundColor = CHColors.gray.withAlphaComponent(0.5)
  }
  
  static func presentCodePicker(with code: String) -> Observable<(String?, String?)> {
    return Observable.create({ (subscriber) in
      var controller = CHUtils.getTopController()
      if let navigation = controller?.navigationController {
        controller = navigation
      }
      
      let pickerView = CountryCodePickerView(frame: (controller?.view.frame)!)

      pickerView.pickedCode = code
      pickerView.showPicker(onView: (controller?.view)!,animated: true)
      let submitSignal = pickerView.signalForSubmit().subscribe(onNext: { (code, dial) in
        subscriber.onNext((code, dial))
        subscriber.onCompleted()
      })
      
      let cancelSignal = pickerView.signalForCancel().subscribe(onNext: { (_) in
        subscriber.onNext((nil, nil))
        subscriber.onCompleted()
      })
      
      return Disposables.create {
        submitSignal.dispose()
        cancelSignal.dispose()
      }
    })
  }
  
  override func initialize() {
    super.initialize()
    self.countries = mainStore.state.countryCodeState.codes
    
    self.actionView.addSubview(self.closeButton)
    self.actionView.addSubview(self.submitButton)
    self.pickerContainerView.addSubview(self.actionView)
    self.pickerContainerView.addSubview(self.pickerView)
    
    self.addSubview(self.backgroundView)
    self.addSubview(self.pickerContainerView)

    self.pickerView.delegate = self
    
    self.closeButton.signalForClick().subscribe(onNext: { [weak self] (event) in
      self?.cancelSubject.onNext(nil)
      self?.cancelSubject.onCompleted()
        
      self?.removePicker(animated: true)
    }).disposed(by: self.disposeBeg)
    
    self.submitButton.signalForClick().subscribe(onNext: { [weak self] (event) in
      guard let index = self?.selectedIndex else { return }
      guard let country = self?.countries[index] else { return }
      
      self?.submitSubject.onNext((country.code, country.dial))
      self?.submitSubject.onCompleted()
        
      self?.removePicker(animated: true)
    }).disposed(by: self.disposeBeg)
  }
  
  override func setLayouts() {
    self.backgroundView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    self.closeButton.snp.remakeConstraints { (make) in
      make.leading.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }
    
    self.submitButton.snp.remakeConstraints { (make) in
      make.trailing.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }
    
    self.actionView.snp.remakeConstraints { (make) in
      make.height.equalTo(50)
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
    self.pickerView.snp.remakeConstraints { [weak self] (make) in
      make.top.equalTo((self?.actionView.snp.bottom)!)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    self.pickerContainerView.snp.remakeConstraints { [weak self] (make) in
      make.height.equalTo(260)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      
      self?.bottomContraint = make.bottom.equalToSuperview().inset(-260).constraint
    }
  }
  
  func signalForSubmit() -> Observable<(String, String)> {
    return self.submitSubject.asObservable()
  }
  
  func signalForCancel() -> Observable<Any?> {
    return self.cancelSubject.asObservable()
  }
}


// MARK: Transition

extension CountryCodePickerView {
  func showPicker(onView: UIView, animated: Bool) {
    onView.addSubview(self)
    onView.layoutIfNeeded()
    
    if !animated {
      return
    }
    
    UIView.animate(withDuration: 0.3) {
      self.pickerContainerView.snp.updateConstraints { (make) in
        make.bottom.equalToSuperview().inset(0)
      }
      onView.layoutIfNeeded()
    }
  }
  
  func removePicker(animated: Bool) {
    if !animated {
      self.removeFromSuperview()
      return
    }
    
    UIView.animate(withDuration: 0.3, animations: {
      self.pickerContainerView.snp.updateConstraints { (make) in
        make.bottom.equalToSuperview().inset(-260)
      }
      self.layoutIfNeeded()
    }) { (completed) in
      self.removeFromSuperview()
    }
  }
}

//MARK: UIPickerViewDelegate

extension CountryCodePickerView : UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String? {
    return "\(self.countries[row].name)  +\(self.countries[row].dial)"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.selectedIndex = row
  }
}

//MARK: UIPickerViewDataSource

extension CountryCodePickerView : UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    return self.countries.count
  }
  
}
