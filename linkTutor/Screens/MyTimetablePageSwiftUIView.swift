import SwiftUI

struct TimetableClass: Identifiable, Hashable {
    let id: UUID
    var className: String
    var tutorName: String
    var classStartTime: Date
    var classEndTime: Date
}

struct MyTimetablePageSwiftUIView: View {
    var allClasses: [TimetableClass]
    @State private var selectedDate: Date = Date()
    @State private var isShowingFilterViewPopup = false
    
    var body: some View {
        ZStack {
            Color(.background)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("My Timetable")
                            .font(AppFont.largeBold)

                        Spacer()

                        Button(action: {
                            isShowingFilterViewPopup.toggle()
                        }) {
                            Image(systemName: "calendar")
                                .foregroundColor(.accent)
                                .font(.system(size: 30))
                                .clipped()
                        }
                    }
                    .padding(.bottom, 15)
                    .sheet(isPresented: $isShowingFilterViewPopup, content: {
                        VStack {
                            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()

                            HStack {
                                Button("Clear") {
                                    selectedDate = Date()
                                    isShowingFilterViewPopup.toggle()
                                }
                                .foregroundColor(.accent)

                                Spacer()

                                Button("Apply") {
                                    isShowingFilterViewPopup.toggle()
                                }
                                .foregroundColor(.accent)
                            }
                        }
                        .padding()
                    })
                    
                    // Filtered classes section
                    if formattedDate(date: selectedDate) != formattedDate(date: Date()) &&
                        formattedDate(date: selectedDate) != formattedDate(date: Date().addingTimeInterval(24 * 60 * 60)) {
                        HStack {
                            Text("\(formattedDate(date: selectedDate))")
                                .font(AppFont.mediumSemiBold)
                                .padding()
                            Spacer()
                            Button("Clear") {
                                selectedDate = Date()
                                isShowingFilterViewPopup = false
                            }
                        }
                        
                        if filteredClasses.isEmpty {
                            HStack{
                                Spacer()
                                Text("No classes")
                                    .font(AppFont.smallReg)
                                    .foregroundStyle(Color.gray)
                                Spacer()
                            }
                        } else {
                            ForEach(filteredClasses, id: \.self) { timetableClass in
                                TimeTableCardSwiftUIView(
                                    className: timetableClass.className,
                                    tutorName: timetableClass.tutorName,
                                    startTime: timetableClass.classStartTime,
                                    classEndTime: timetableClass.classEndTime
                                )
                            }
                        }
                    }


                    // Today's classes section
                    HStack{
                        Text("Today")
                            .font(AppFont.mediumSemiBold)
                            .padding()
                        Spacer()
                    }

                    VStack(spacing: 10){
                        // Run the loop 30 times
                        ForEach(0..<30, id: \.self) { _ in
                            VStack {
                                // Your existing ForEach loop for displaying timetable classes
                                ForEach(todayClasses, id: \.self) { timetableClass in
                                    TimeTableCardSwiftUIView(
                                        className: timetableClass.className,
                                        tutorName: timetableClass.tutorName,
                                        startTime: timetableClass.classStartTime,
                                        classEndTime: timetableClass.classEndTime
                                    )
                                }
                            }
                        }

                    }

                    // Tomorrow's classes section
                    HStack{
                        Text("Tomorrow")
                            .font(AppFont.mediumSemiBold)
                            .padding()
                        Spacer()
                    }

                    
                }
                .padding()
            }
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 12)
            .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
            .navigationBarTitle("Timetable", displayMode: .inline)
        }
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    // Filter classes for today
    private var todayClasses: [TimetableClass] {
        return filterClasses(for: Date())
    }

    // Filter classes for tomorrow
    private var tomorrowClasses: [TimetableClass] {
        return filterClasses(for: Date().addingTimeInterval(24 * 60 * 60)) // Adding one day (24 hours)
    }
    
    private var filteredClasses: [TimetableClass] {
        filterClasses(for: selectedDate)
    }
    
    // Helper function to filter classes based on a given date
    private func filterClasses(for date: Date) -> [TimetableClass] {
        return allClasses.filter { timetableClass in
            let calendar = Calendar.current
            return calendar.isDate(timetableClass.classStartTime, inSameDayAs: date)
        }
    }
}

struct MyTimetablePageSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MyTimetablePageSwiftUIView(allClasses: [
            TimetableClass(
                id: UUID(),
                className: "Math",
                tutorName: "John Doe",
                classStartTime: Date(),
                classEndTime: Date().addingTimeInterval(3600)
            ),
            TimetableClass(
                id: UUID(),
                className: "History",
                tutorName: "Jane Smith",
                classStartTime: Date().addingTimeInterval(86400),
                classEndTime: Date().addingTimeInterval(90000)
            ),
            TimetableClass(
                id: UUID(),
                className: "English",
                tutorName: "Carol",
                classStartTime: Date().addingTimeInterval(2 * 24 * 60 * 60),
                classEndTime: Date().addingTimeInterval(2 * 24 * 60 * 60 + 3600)
            ),
        ])
    }
}
