//
//  MotionViewModel.swift
//  QR-Map
//
//  Created by soliduSystem on 29/03/23.
//

import Foundation
import CoreMotion

class MotionViewModel {
    // MARK: - Override Func
    
    init() {
        //        Accelerometer & Gyroscope
        if self.managerMotion.isGyroAvailable {
            self.managerMotion.startGyroUpdates()

            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
                if let dataGyro = self.managerMotion.gyroData {
                    
                    self.delegate?.didUpdateGyro(
                        x: dataGyro.rotationRate.x,
                        y: dataGyro.rotationRate.y,
                        z: dataGyro.rotationRate.z)

                }
            }
        }

        if self.managerMotion.isAccelerometerAvailable {
            self.managerMotion.startAccelerometerUpdates()

            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
                if let dataAcce = self.managerMotion.accelerometerData {
                    
                    self.delegate?.didUpdateAcceleromer(
                        x: dataAcce.acceleration.x,
                        y: dataAcce.acceleration.y,
                        z: dataAcce.acceleration.z)

                }
            }
        }
    }
    
    // MARK: - IBOutlet
    
    
    // MARK: - Public let / var
    public let managerMotion = CMMotionManager()
    var delegate : MotionDelegate?

    
    // MARK: - Private let / var
    
    
    // MARK: - IBAction
    
}


