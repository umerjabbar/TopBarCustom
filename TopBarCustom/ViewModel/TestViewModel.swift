//
//  TestViewModel.swift
//  TopBarMenuDemo


import Foundation

enum DemoTestViewModel {
    case red
    case green
    case colorForBlue
    case orange
    case lightGray
}

extension DemoTestViewModel {
    var title: String {
        return String(describing: self)
    }
}

