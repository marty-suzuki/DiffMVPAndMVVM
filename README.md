# DiffMVPAndMVVM

Tally Counter sample.

![](./Images/tally_counter.gif)

Presentation Link  
https://speakerdeck.com/martysuzuki/jin-geng-wen-kenaimvptomvvmfalsewei-i

## MVP

### View
- [MVPViewController](./DiffMVPAndMVVM/MVP/MVPViewController.swift)
- [MVPViewControllerTestCase](./DiffMVPAndMVVMTests/MVP/MVPViewControllerTestCase.swift)

### Presenter
- [CounterPresenter](./DiffMVPAndMVVM/MVP/CounterPresenter.swift)
- [CounterPresenterTestCase](./DiffMVPAndMVVMTests/MVP/CounterPresenterTestCase.swift)

## MVVM

### View
- [MVVMViewController](./DiffMVPAndMVVM/MVVM/MVVMViewController.swift)
- [MVVMViewControllerTestCase](./DiffMVPAndMVVMTests/MVVM/MVVMViewControllerTestCase.swift)

### ViewModel
- [CounterViewModel](./DiffMVPAndMVVM/MVVM/CounterViewModel.swift)
- [CounterViewModelTestCase](./DiffMVPAndMVVMTests/MVVM/CounterViewModelTestCase.swift)

## Common

### Model

- [CounterModel](./DiffMVPAndMVVM/Common/CounterModel.swift)
- [CounterModelTestCase](./DiffMVPAndMVVMTests/CounterModelTestCase.swift)

## Requirements

- Xcode 9.3
- Swift 4.1
- iOS 11
- RxSwift 4.1
- carthage 0.27.0

## Demo

```
carthage update --platform ios --no-use-binaries
```

## Author
Taiki Suzuki, s1180183@gmail.com

## License
DiffMVPAndMVVM is available under the MIT license. See the LICENSE file for more info.
