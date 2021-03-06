//
//  MockCalendarEntity.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/05.
//

import Foundation

class DummyCalendarEntity {
    let ExpectedInitCalendarDummyData: [CalendarEntity] = [
        CalendarEntity(
            days: ["27", "28", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
            week: ["일", "월", "화", "수", "목", "금", "토"],
            yearMonth: "2022년 3월",
            isHiddenArray: [true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true],
            dangArray: [15.0, 8.0, 20.0, 15.0, 5.0, 1.0, 17.0, 5.0, 14.0, 8.0, 10.0, 1.0, 13.0, 8.0, 20.0, 6.0, 8.0, 15.0, 15.0, 2.0, 10.0, 8.0, 10.0, 8.0, 2.0, 12.0, 15.0, 1.0, 5.0, 6.0, 8.0, 15.0, 8.0, 2.0, 19.0, 1.0, 12.0, 8.0, 14.0, 1.0, 18.0, 19.0],
            maxDangArray: [20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0],
            isCurrentDayArray: [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        ),
        CalendarEntity(
            days: ["27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7"],
            week: ["일", "월", "화", "수", "목", "금", "토"],
            yearMonth: "2022년 4월",
            isHiddenArray: [true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true],
            dangArray: [15.0, 8.0, 20.0, 15.0, 5.0, 1.0, 17.0, 5.0, 14.0, 8.0, 10.0, 1.0, 13.0, 8.0, 20.0, 6.0, 8.0, 15.0, 15.0, 2.0, 10.0, 8.0, 10.0, 8.0, 2.0, 12.0, 15.0, 1.0, 5.0, 6.0, 8.0, 15.0, 8.0, 2.0, 19.0, 1.0, 12.0, 8.0, 14.0, 1.0, 18.0, 19.0],
            maxDangArray: [20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0],
            isCurrentDayArray: [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]),
        CalendarEntity(
            days: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
            week: ["일", "월", "화", "수", "목", "금", "토"],
            yearMonth: "2022년 5월",
            isHiddenArray: [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true],
            dangArray: [15.0, 8.0, 20.0, 15.0, 5.0, 1.0, 17.0, 5.0, 14.0, 8.0, 10.0, 1.0, 13.0, 8.0, 20.0, 6.0, 8.0, 15.0, 15.0, 2.0, 10.0, 8.0, 10.0, 8.0, 2.0, 12.0, 15.0, 1.0, 5.0, 6.0, 8.0, 15.0, 8.0, 2.0, 19.0, 1.0, 12.0, 8.0, 14.0, 1.0, 18.0, 19.0],
            maxDangArray: [20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0],
            isCurrentDayArray: [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        )
    ]
    
    let ExpectedPreviousCalendarDummyData: CalendarEntity = CalendarEntity(
        days: ["30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
               "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
               "21", "22", "23", "24", "25", "26", "27", "28", "1", "2", "3",
               "4", "5", "6", "7", "8", "9", "10", "11", "12"],
        week: ["일", "월", "화", "수", "목", "금", "토"],
        yearMonth: "2022년 2월",
        isHiddenArray: [true, true, false, false, false, false, false, false, false, false,
                        false, false, false, false, false, false, false, false, false, false,
                        false, false, false, false, false, false, false, false, false, false,
                        true, true, true, true, true, true, true, true, true, true, true, true],
        dangArray: [15.0, 8.0, 20.0, 15.0, 5.0, 1.0, 17.0, 5.0, 14.0, 8.0, 10.0, 1.0,
                    13.0, 8.0, 20.0, 6.0, 8.0, 15.0, 15.0, 2.0, 10.0, 8.0, 10.0, 8.0,
                    2.0, 12.0, 15.0, 1.0, 5.0, 6.0, 8.0, 15.0, 8.0, 2.0, 19.0, 1.0,
                    12.0, 8.0, 14.0, 1.0, 18.0, 19.0],
        maxDangArray: [20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                       20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                       20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                       20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0],
        isCurrentDayArray: [false, false, false, false, false, false, false, false, false, false,
                            false, false, false, false, false, false, false, false, false, false,
                            false, false, false, false, false, false, false, false, false, false,
                            false, false, false, false, false, false, false, false, false, false,
                            false, false]
    )
    
    let ExpectedNextCalendarDummyData: CalendarEntity = CalendarEntity(
        days: ["29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
               "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21",
               "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3",
               "4", "5", "6", "7", "8", "9"],
        week: ["일", "월", "화", "수", "목", "금", "토"],
        yearMonth: "2022년 6월",
        isHiddenArray: [true, true, true, false, false, false, false, false, false, false, false,
                        false, false, false, false, false, false, false, false, false, false,
                        false, false, false, false, false, false, false, false, false, false,
                        false, false, true, true, true, true, true, true, true, true, true],
        dangArray: [15.0, 8.0, 20.0, 15.0, 5.0, 1.0, 17.0, 5.0, 14.0, 8.0, 10.0, 1.0, 13.0, 8.0,
                    20.0, 6.0, 8.0, 15.0, 15.0, 2.0, 10.0, 8.0, 10.0, 8.0, 2.0, 12.0, 15.0, 1.0,
                    5.0, 6.0, 8.0, 15.0, 8.0, 2.0, 19.0, 1.0, 12.0, 8.0, 14.0, 1.0, 18.0, 19.0],
        maxDangArray: [20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                       20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                       20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                       20.0, 20.0, 20.0, 20.0, 20.0, 20.0],
        isCurrentDayArray: [false, false, false, false, false, false, false, false, false, false,
                            false, false, false, false, false, false, false, false, false, false,
                            false, false, false, false, false, false, false, false, false, false,
                            false, false, false, false, false, false, false, false, false, false,
                            false, false]
    )
}
