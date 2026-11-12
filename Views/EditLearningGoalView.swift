//
//  EditLearningGoalView.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//

import SwiftUI

struct EditLearningGoalView: View {

    @ObservedObject var viewModel: ActivityViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var learningGoal = ""
    @State private var selectedDuration: LearningDuration = .week
    @State private var showUpdateAlert = false

    var body: some View {

        ZStack {

            Color("MainBG")
                .ignoresSafeArea()

            VStack(spacing: 30) {

                // MARK: - Navigation Header

                HStack {

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color("PrimaryText"))
                            .frame(width: 38, height: 38)
                            .background(Color("InactiveButton"))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("Learning Goal")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color("PrimaryText"))

                    Spacer()

                    Button {
                        showUpdateAlert = true
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color("PrimaryText"))
                            .frame(width: 38, height: 38)
                            .background(Color("AccentOrange"))
                            .clipShape(Circle())
                    }
                    .disabled(learningGoal.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                // MARK: - Learning Goal

                VStack(alignment: .leading, spacing: 15) {

                    Text("I want to learn")
                        .font(.system(size: 15))
                        .foregroundStyle(Color("PrimaryText"))

                    TextField("Swift", text: $learningGoal)
                        .font(.system(size: 17))
                        .foregroundStyle(Color("PrimaryText"))
                        .tint(Color("AccentOrange"))

                    Rectangle()
                        .fill(Color("Divider"))
                        .frame(height: 1)
                }

                // MARK: - Duration Selection

                VStack(alignment: .leading, spacing: 15) {

                    Text("I want to learn it in a")
                        .font(.system(size: 15))
                        .foregroundStyle(Color("PrimaryText"))

                    HStack(spacing: 10) {

                        ForEach(LearningDuration.allCases) { duration in

                            Button {
                                selectedDuration = duration
                            } label: {

                                Text(duration.rawValue)
                                    .font(.system(size: 14))
                                    .foregroundStyle(
                                        selectedDuration == duration
                                        ? Color("PrimaryText")
                                        : Color("SecondaryText")
                                    )
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(
                                        selectedDuration == duration
                                        ? Color("AccentOrange")
                                        : Color("InactiveButton")
                                    )
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.top, 15)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {

            learningGoal = viewModel.progress.learningGoal
            selectedDuration = viewModel.progress.selectedDuration
        }
        .alert("Update goal", isPresented: $showUpdateAlert) {

            Button("Dismiss", role: .cancel) { }

            Button("Update") {

                viewModel.updateGoal(
                    goal: learningGoal,
                    duration: selectedDuration
                )

                dismiss()
            }

        } message: {
            Text("If you update now, your streak will start over.")
        }
    }
}

#Preview {
    NavigationStack {
        EditLearningGoalView(
            viewModel: ActivityViewModel(
                learningGoal: "Swift",
                duration: .week
            )
        )
    }
}

