//
//  utils.swift
//  SlumbeR
//
//  Created by Anu on 2/26/23.
//

import CoreML

func get_efficiency(age: Int,
                    gender: String,
                    sleepduration: Double,
                    remsleeppercentage: Double,
                    deepsleeppercentage: Double,
                    smokingstatus: String,
                    exercisefrequency: Double) -> Double {
    
    
    do {
        
        // hard coded values
        // still need to get real values tranlated to correct types
        //let age = Double("65")
        //let gender = "Female"
        //let sleep_dur = Double("6")
        //let rem_per = Double("18")
        //let deep_per = Double("70")
        //let smoke = "Yes"
        //let ex_freq = Double("3")
        
        
        
        guard let model = try? SleepE(configuration: MLModelConfiguration()) else {
            fatalError("Unable to load model")
        }
        
        let input = SleepEInput(Age: Double(age),
                                Gender: gender,
                                Sleepduration: sleepduration,
                                REMsleeppercentage: remsleeppercentage,
                                Deepsleeppercentage: deepsleeppercentage,
                                Smokingstatus: smokingstatus,
                                Exercisefrequency: exercisefrequency)

        guard let output = try? model.prediction(input: input) else {
            fatalError("Unable to make prediction")
        }
        
        return output.Sleepefficiency

    } catch {
        return -1
    }
}


