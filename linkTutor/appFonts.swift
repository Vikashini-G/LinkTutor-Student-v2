import SwiftUI

enum AppFont {
    static let largeBold: Font = .system(size: 34, weight: .semibold)
    static let mediumReg: Font = .system(size: 20, weight: .regular)
    static let mediumSemiBold: Font = .system(size: 20, weight: .semibold) //titles eg: courses enrolled
    static let smallReg: Font = .system(size: 17, weight: .regular) //normal paragraph type text eg: name of teacher
    static let smallSemiBold: Font = .system(size: 17, weight: .semibold)
    static let actionButton: Font = Font.system(size: 15, weight: .regular) //action items
}

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Text("Title")
//                .font(AppFont.title)
//            Text("Subtitle")
//                .font(AppFont.subtitle)
//            // Use AppFont for other text views as needed
//        }
//        .padding()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
