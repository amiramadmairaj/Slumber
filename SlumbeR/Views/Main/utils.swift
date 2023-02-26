//
//  utils.swift
//  SlumbeR
//
//  Created by slmrc on 2/26/23.
//

// This file is completely broken, still working on it



//import CreateML
//import Foundation
//
//let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/slmrc/Downloads/Sleep_Emod.csv")).dropMissing()
//let (trainingData, testingData) = data.randomSplit(by: 0.8)
//
//let regressor = try MLRegressor(trainingData: trainingData, targetColumn: "Sleepefficiency")
//
//let evaluationMetrics = regressor.evaluation(on: testingData)
//print(evaluationMetrics.rootMeanSquaredError)
//print(evaluationMetrics.maximumError)
//
//let metadata = MLModelMetadata(author: "Anu", shortDescription: "A model trained to predict optimum sleep times", version: "1.0")
//
//try regressor.write(to: URL(fileURLWithPath: "/Users/slmrc/Desktop/SleepE.mlmodel"), metadata: metadata)
//
//
//
//
//let model = MLRegressor(contentsOf: URL(fileURLWithPath: "/Users/slmrc/Desktop/SleepE.mlmodel"))
//
//
//
//
//do {
//    let age = "65"
//    let gender = "Female"
//    let sleep_dur = "6"
//    let rem_per = "18"
//    let deep_per = "70"
//    let smoke = "Yes"
//    let ex_freq = "3"
//
//    let inputCSV = """
//Age,Gender,Sleepduration,REMsleeppercentage,Deepsleeppercentage,Smokingstatus,Exercisefrequency
//65,Female,6,18,70,Yes,3
//"""
//
//    let input_data = MLDataTable(contentsOf: inputCSV.data(using: .utf8)!, options: .delimiter(","))
//
//    let prediction = try model.predictions(Age: age,
//                                          Gender: gender,
//                                          Sleepduration: sleep_dur,
//                                          REMsleeppercentage: rem_per,
//                                          Deepsleeppercentage: deep_per,
//                                          Smokingstatus: smoke,
//                                          Exercisefrequency: ex_freq)
//    print(prediction)
//} catch {
//    print("prediction error")
//}
//

