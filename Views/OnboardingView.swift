//
//  ContentView.swift
//  Views
//
//  Created by Linah on 30/05/1448 AH.
//





import SwiftUI

struct OnboardingView: View {

    //هنا عشان اربطهم ببعض ويصير يدري عن كل شي والتواصل مع باقي التغيرات واللوجك

    // Connect the View to its ViewModel
    @StateObject private var viewModel = OnboardingViewModel()

    // Controls navigation to the Activity Page
    @State private var showActivityPage = false

    var body: some View {

        NavigationStack {

            GeometryReader { geometry in

                ZStack {

                    // Background
                    Color("MainBG")
                        .ignoresSafeArea()

                    ScrollView {

                        VStack(spacing: 0) {

                            // MARK: - Flame Symbol

                            Image(systemName: "flame.fill")
                                .font(.system(size: 55))
                                .foregroundStyle(Color("AccentOrange"))
                                .padding(.top, 70)

                            Spacer(minLength: 45)

                            // MARK: - Welcome Section

                            VStack(alignment: .leading, spacing: 10) {

                                HStack(spacing: 0) {
                                    Text("Hello ")
                                        .fontWeight(.regular)

                                    Text("Learner")
                                        .fontWeight(.bold)
                                }
                                .font(.system(size: 42))
                                .foregroundStyle(Color("PrimaryText"))

                                Text("This app will help you learn everyday!")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color("SecondaryText"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer()
                                .frame(height: 55)

                            // MARK: - Learning Goal

                            VStack(alignment: .leading, spacing: 12) {

                                Text("I want to learn")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color("PrimaryText"))

                                TextField("Swift", text: $viewModel.learningGoal)
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color("PrimaryText"))
                                    .tint(Color("AccentOrange"))

                                Rectangle()
                                    .fill(Color("Divider"))
                                    .frame(height: 1)
                            }

                            Spacer()
                                .frame(height: 45)

                            // MARK: - Duration Selection

                            // بعدها اسم الشي الي ابيها من صفحة الفيو viewModel. هنا استدعاء من فيو مودل نحط

                            VStack(alignment: .leading, spacing: 18) {

                                Text("I want to learn it in a")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color("PrimaryText"))

                                HStack(spacing: 12) {

                                    ForEach(LearningDuration.allCases) { duration in

                                        Button {
                                            viewModel.selectedDuration = duration
                                        } label: {

                                            Text(duration.rawValue)
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundStyle(
                                                    viewModel.selectedDuration == duration
                                                    ? Color("PrimaryText")
                                                    : Color("SecondaryText")
                                                )
                                                .frame(width: 105, height: 58)
                                                .background(
                                                    viewModel.selectedDuration == duration
                                                    ? Color("AccentOrange")
                                                    : Color("InactiveButton")
                                                )
                                                .clipShape(Capsule())
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }

                            // Flexible space: up to 229 points
                            Spacer(minLength: 20)
                                .frame(maxHeight: 229)

                            // MARK: - Start Learning Button

                            VStack(spacing: 8) {

                                Button {

                                    viewModel.startLearning()
                                    showActivityPage = true

                                } label: {

                                    Text("Start Learning")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(Color("PrimaryText"))
                                        .frame(width: 250, height: 65)
                                        .background(Color("AccentOrange"))
                                        .clipShape(Capsule())
                                }
                                .disabled(!viewModel.canStartLearning)
                                .opacity(viewModel.canStartLearning ? 1 : 0.5)

                                Text("You can edit your desire later")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color("SecondaryText"))
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 25)
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }
            .navigationDestination(isPresented: $showActivityPage) {

                ActivityView(
                    learningGoal: viewModel.learningGoal,
                    selectedDuration: viewModel.selectedDuration ?? .week
                )
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    OnboardingView()
}
