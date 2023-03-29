//
//  MotionDelegate.swift
//  QR-Map
//
//  Created by soliduSystem on 29/03/23.
//

import Foundation

protocol MotionDelegate {
    func didUpdateAcceleromer(x : Double, y : Double, z : Double)
    func didUpdateGyro(x : Double, y : Double, z : Double)
}
