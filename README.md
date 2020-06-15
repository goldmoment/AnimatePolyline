# AnimatePolyline

[![CI Status](https://img.shields.io/travis/viensaigon/AnimatePolyline.svg?style=flat)](https://travis-ci.org/viensaigon/AnimatePolyline)
[![Version](https://img.shields.io/cocoapods/v/AnimatePolyline.svg?style=flat)](https://cocoapods.org/pods/AnimatePolyline)
[![License](https://img.shields.io/cocoapods/l/AnimatePolyline.svg?style=flat)](https://cocoapods.org/pods/AnimatePolyline)
[![Platform](https://img.shields.io/cocoapods/p/AnimatePolyline.svg?style=flat)](https://cocoapods.org/pods/AnimatePolyline)

## Example

![alt tag](https://media0.giphy.com/media/SYRSNlu5xe2m94QEMW/giphy.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AnimatePolyline is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AnimatePolyline'
```

## Usage

```swift
  self.animatePolyline = AnimatePolyline(mapView: self.mapView)
  self.animatePolyline?.strokeColor = .black
  self.animatePolyline?.route = route
  self.animatePolyline?.startAnimation()
```

## Author

goldmoment, nguyenvanvienqn@gmail.com

## License

AnimatePolyline is available under the MIT license. See the LICENSE file for more info.
