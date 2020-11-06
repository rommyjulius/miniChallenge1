

import Foundation

var date = Date()
let globalCalendar = Calendar.current


let day = globalCalendar.component(.day, from: date)
var weekday = globalCalendar.component(.weekday, from: date) - 0
var month = globalCalendar.component(.month, from: date) - 1
var year = globalCalendar.component(.year, from: date)
