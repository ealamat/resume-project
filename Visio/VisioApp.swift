////import SwiftUI
////import Firebase
////
////@main
////struct VisioApp: App {
////    init() {
////        FirebaseApp.configure()
////    }
////
////    var body: some Scene {
////        WindowGroup {
////            NavigationStack{
////                First_Screen()
////            }
////        }
////    }
////}
//
//import SwiftUI
//import Firebase
//
//@main
//struct YourApp: App {
//    @StateObject var currentUser = CurrentUser()
//
//    init() {
//        FirebaseApp.configure()
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            NavigationView {
//                if currentUser.id.isEmpty {
//                    // Show login view when user is logged out
//                    First_Screen()
//                        .environmentObject(currentUser)
//                } else {
//                    // Show first screen when user is logged in
//                    //LoggedinView()
//                        //.environmentObject(currentUser)
//                }
//            }
//        }
//    }
//}
//
