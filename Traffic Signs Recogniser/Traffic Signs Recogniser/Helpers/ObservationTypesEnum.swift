//
//  ObservationTypesEnum.swift
//  Traffic Signs Recogniser
//
//  Created by vladikkk on 28/01/2021.
//

import UIKit

enum ObservationTypeEnum: String {
    case SpeedLimit = "SpeedLimit"
    case Crosswalk = "crosswalk"
    case EndOfMainRoad = "end of main road"
    case GiveWay = "give way"
    case MainRoad = "main road"
    case NoOvertaking = "no overtaking"
    case Radar = "radar"
    case Stop = "stop"
    case Other = "other"
    
    init(fromRawValue value: String) {
        if value.contains("km/h") {
            self = ObservationTypeEnum.SpeedLimit
        } else {
            self = ObservationTypeEnum(rawValue: value) ?? .Other
        }
    }
    
    func getColor() -> CGColor {
        switch self {
        case .SpeedLimit, .GiveWay, .NoOvertaking, .Stop:
            return CGColor(srgbRed: 255/255, green: 0, blue: 0, alpha: 1)        // Red
        case .MainRoad:
            return CGColor(srgbRed: 0, green: 255/255, blue: 0, alpha: 1)      // Green
        case .Crosswalk:
            return CGColor(srgbRed: 0, green: 0, blue: 255/255, alpha: 1)      // Blue
        case .EndOfMainRoad:
            return CGColor(srgbRed: 102/255, green: 0, blue: 204/255, alpha: 1)    // Purple
        case .Radar:
            return CGColor(srgbRed: 255/255, green: 0, blue: 255/255, alpha: 1)    // Magenta
        case .Other:
            return CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)      // Black
        }
    }
}
