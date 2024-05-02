//
//  CreateNewCourseViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 19/04/24.
//

import Foundation


class CreateNewCourseViewModel: ObservableObject {
    @Published var textCourseName: String = String()
    @Published var textInstitution: String = String()
    @Published var textTopic: String = String()
    @Published var textDescription: String = String()
    @Published var textObjetive: String = String()
    @Published var showAcademicLevelOptions: Bool = false
    @Published var showGradeoptions: Bool = false
    @Published var showDayOfWeekOptions: Bool = false
    @Published var academicLevelSelected: String = "Nivel académico"
    @Published var gradeSelected: String = "Grado"
    @Published var showDayOfWeekSelected: String = "Días de la semana"
    @Published var startDateText: String = "Fecha inicio"
    @Published var startDateSelected: Date = Date()
    @Published var endDateText: String = "Fecha termino"
    @Published var endDateSelected: Date = Date()
}
