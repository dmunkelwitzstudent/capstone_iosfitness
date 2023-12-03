//
//  ActiveView.swift
//  bytFyt_capstone
//
//  Created by Daniel Munkelwitz on 11/16/23.
//

import SwiftUI
import SwiftData


struct ActiveView: View {
    @Environment(\.modelContext) private var modelContext;
    @Query private var users: [User];
    
    @Query private var workouts: [Workout];
    

    struct AppColorScheme {
        static let backgroundColor = Color.red
        static let accentColor = Color.white
        static let textColor = Color.white
    }
    
    
    
    @State var workoutName: String = "";
    @State var workoutCalories: String = "";
    @State var muscleGroup: String = "";
    @State var desc: String = "";
    
    
    
    var body: some View {
        
        
        
        ZStack {
            AppColorScheme.backgroundColor
                .ignoresSafeArea(edges: .all)
            
            
            VStack {
                // Sleep Tracker Header
                Text("Activity")
                    .font(.largeTitle)
                    .foregroundColor(AppColorScheme.textColor)
                    .padding()
                    .background(AppColorScheme.backgroundColor)
                ProgressView(value: Double(Double(users[0].currentActiveCalories) / Double(users[0].ActivityGoal))) {
                    
                }
                .accentColor(Color.white)
                Text("\(users[0].currentActiveCalories) Calories out of \(users[0].ActivityGoal) Goal")
                    .foregroundStyle(AppColorScheme.textColor)
                
                
                Spacer()
                
                // Sleep Metrics
                VStack(alignment: .center, spacing: 200) {
                    

                
                    
                    
                    NavigationSplitView {
                        
                        List {
                            
                            ForEach (workouts) { workout in
                                
                                
                                
                                NavigationLink {
                                    

                                    Button("Completed Workout") {
                                        users[0].currentActiveCalories += workout.TotalCalories;
                                    }
                                    
                                    Text("Workout: \(workout.Name)")
                                        .font(.title)
                                    Text("Total Calories: \(workout.TotalCalories)")
                                        .font(.title2)
                                    
                                    //Text("Workout Description: \(workout.Desc)")
                                    Text("Workout MuscleGroup: \(workout.MuscleGroup)")
                                        .font(.title3)
                                    
                                    Text("\(workout.Desc)")
                                    
                                    
                                    Button("Update Workout") {
                                        
                                        
                                        
                                        if (workoutName != "") {
                                            workout.Name = workoutName;
                                        }
                                        
                                        if (muscleGroup != "") {
                                            workout.MuscleGroup = muscleGroup;
                                        }
                                        if (desc != "") {
                                            workout.Desc = desc;
                                        }

                                        
                                        if let newCalories = Double(workoutCalories) {
                                            workout.TotalCalories = newCalories
                                            
                                        }
                                        
                                        workoutName = "";
                                        workoutCalories = "";
                                        muscleGroup = "";
                                        desc = "";
                                        
                                    }

                                    
                                    TextField("Workout: Name", text: $workoutName)
                                    TextField("Workout: Total Calories", text: $workoutCalories)
                                    TextField("Workout: Muscle Group", text: $muscleGroup)
                                    TextField("Workout: Description", text: $desc)
                                        

                                                     
                                        
                                     } label: {
                                    Text("\(workout.Name)");

                                }
                            }
                            .onDelete(perform: deleteWorkout)
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                            ToolbarItem {
                                Button(action: addWorkout) {
                                    Label("Add Item", systemImage: "plus")
                                }
                            }
                        }
                        
                    } detail: {
                        Text("Select an item")
                    }
                    
                    
                    
                    
                }
            }
        }
    }
    private func addWorkout() {
        var newWorkout = Workout.init(name: "Default #\(workouts.count + 1)");
        modelContext.insert(newWorkout)
    }
    
    private func deleteWorkout(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(workouts[index])
        }
    }
}




#Preview {
    ActiveView()
        .modelContainer(for: [User.self, Workout.self], inMemory: true)
}
