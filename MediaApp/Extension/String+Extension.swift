//
//  String+Extension.swift
//  MediaApp
//
//  Created by 장예지 on 6/28/24.
//

import Foundation

extension String {
    func convertStringToDate(_ dateFormatStyle: String) -> Date? {
        let dateFormat = DateFormatter()
        
        dateFormat.locale = Locale(identifier: "ko_KR")
        dateFormat.dateFormat = dateFormatStyle
        
        return dateFormat.date(from: self)
    }
}
