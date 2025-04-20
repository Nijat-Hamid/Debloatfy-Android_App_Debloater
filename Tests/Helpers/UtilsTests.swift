//
//  UtilsTests.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/20/25.
//

import Testing
@testable import Debloatfy
import Foundation

@Suite("Utils Tests")
struct UtilsTests {
    
    @Suite("formatSize function")
    struct FormatSizeTests{
        
        @Test
        func regularSize() async throws {
            #expect(Utils.formatSize("14") == "14 MB")
            #expect(Utils.formatSize("2304") == "2.30 GB")
            #expect(Utils.formatSize("5034") == "5.03 GB")
            #expect(Utils.formatSize("0.1") == "1 MB")
        }
        
        @Test
        func differentTypes() async throws {
            #expect(Utils.formatSize("shdh") == "N/A")
            #expect(Utils.formatSize("") == "N/A")
        }
        
    }
    
    @Suite("dateFormatter function")
    struct DateFormatterTests{
        
        @Test
        func regularDate() async throws {
            let calendar = Calendar(identifier: .gregorian)
            var dateComponents = DateComponents()
            dateComponents.year = 2023
            dateComponents.month = 5
            dateComponents.day = 15
            dateComponents.hour = 14
            dateComponents.minute = 30
            dateComponents.second = 45
            dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
            
            let testTimeZone = TimeZone(identifier: "en_US_POSIX") ?? TimeZone.current
            dateComponents.timeZone = testTimeZone
            let testDate = calendar.date(from: dateComponents)!
            
            let formattedDate = Utils.dateFormatter(testDate)
            
            let expectedResult = "May 15, 2023 | 14:30:45"
            
            #expect(formattedDate == expectedResult)
        }
        
    }
}
