//
//  ContentView.swift
//  Visio
//
//  Created by Elias Alamat on 12/7/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
          First_Screen()
      }
    }
  }
}
struct First_Screen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false // Controls navigation to the next screen
    @State private var showRegistration: Bool = false // controls navigation to the register screen

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.2, green: 0.2, blue: 0.2)
                    .ignoresSafeArea()
                VStack{
                    HStack{
                        Spacer()
                        VStack{
                            HStack{
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            }
                            HStack{
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            }
                            
                            
                        }
                        
                        Rectangle()
                            .frame(width: 4, height: 75)
                            .padding(.leading, 20)
                            .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        
                        VStack{
                            Text("V I S I O")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            Text("Pure Potential")
                                .font(.subheadline)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.top, -350)// end of H-stack
                }
                    
                
                
                
                VStack {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .padding()
                    }

                    Button("Login") {
                        loginUser()
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: 120)
                    .padding()
                    .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .navigationDestination(isPresented: $isLoggedIn){
                        LoggedInView()
                    }
                    Text("Or, if you don't have an account: ")
                        .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        .padding(.top, 30)
                        .font(.footnote)
                        .fontWeight(.light)
                    
                    Button("Create Account") {
                        showRegistration = true
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: 120)
                    .padding()
                    .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .navigationDestination(isPresented: $showRegistration){
                        CreateAccountView()
                    }
                    
                    
                    // Navigation triggered by `isLoggedIn`
//                    NavigationLink(
//                        destination: LoggedInView(),
//                        isActive: $isLoggedIn
//                    ) {
//                        EmptyView() // Invisible NavigationLink
//                    }
                }
            }
        }
    }

    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = ""
                isLoggedIn = true // Trigger navigation
                print("User Logged in: \(result?.user.email ?? "Unknown")")
            }
        }
    }
}

struct LoggedInView: View {
    let user = Auth.auth().currentUser

    var body: some View {
        VStack {
            Text("You are logged in, welcome!")
                .font(.largeTitle)
                .padding()
            if let email = user?.email {
                Text("Email: \(email)")
                    .font(.title2)
                    .padding()
            } else {
                Text("No email found.")
                    .font(.title2)
                    .padding()
            }
        }
    }
}


struct CreateAccountView: View{
        @State private var email: String = ""
        @State private var password: String = ""
        @State private var errorMessage: String = ""
        @State private var isAccountCreated: Bool = false
    
    var body: some View{
        ZStack {
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .ignoresSafeArea()
            
            VStack {
                HStack{
                    Spacer()
                    VStack{
                        HStack{
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        }
                        HStack{
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        }
                        
                        
                    }
                    
                    Rectangle()
                        .frame(width: 4, height: 75)
                        .padding(.leading, 20)
                        .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                    
                    VStack{
                        Text("V I S I O")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        Text("Pure Potential")
                            .font(.subheadline)
                            .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, -300)

                
                Text("To Sign up, enter a valid email adress, as well as your desired passowrd for your account with visio. Please note that your password will be encrypted and stored securely.")
                    .fontWeight(.ultraLight)
                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .font(.custom("SFProText-Light", size: 10))
                    .padding(.bottom, 20)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .padding()
                }
                
                Button("Sign Up!") {
                    registerUser()
                }
                .frame(maxWidth: 120)
                .foregroundStyle(.black)
                .padding()
                .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                .cornerRadius(8)
                .padding(.horizontal)
                
                if isAccountCreated {
                    Text("Account successfully created! Please login.")
                        .foregroundStyle(.green)
                        .padding()
                }
            }// end of vstack
        } // end of ztack
    }
    
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = ""
                isAccountCreated = true
                print("Account created for user: \(result?.user.email ?? "Unknown")")
            }
        }
    }
}



#Preview {
    CreateAccountView()
}
