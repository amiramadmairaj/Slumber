//
//  utils.swift
//  SlumbeR
//
//  Created by Anu on 2/26/23.
//

import CoreML

func getSleepEff(age: Double,
                 gender: Double,
                 sleepDuration: Double,
                 remSleepPerc: Double,
                 deepSleepPerc: Double,
                 smoking: Double,
                 exerciseFreq: Double) -> Double {
    // Uses regressor to predict sleep efficiency. Generates how "well" you have slept. Core utility score function.
    
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
        
        
        
        guard let model = try? SleepE5(configuration: MLModelConfiguration()) else {
            fatalError("Unable to load model")
        }
        
        let input = SleepE5Input(Age: age,
                                Gender: gender,
                                Sleepduration: sleepDuration,
                                REMsleeppercentage: remSleepPerc,
                                Deepsleeppercentage: deepSleepPerc,
                                Smokingstatus: smoking,
                                Exercisefrequency: exerciseFreq)
        
        guard let output = try? model.prediction(input: input) else {
            fatalError("Unable to make prediction")
        }
        
        return output.Sleepefficiency
        
    }
    
}


func getREMSleepPerc(age: Double,
                     gender: Double,
                     sleepDuration: Double,
                     sleepEfficiency: Double,
                     deepSleepPerc: Double,
                     smoking: Double,
                     exerciseFreq: Double) -> Double {
    // Uses regressor to predict REM sleep percentage. Predicts how much REM sleep you need.
    
    do {
        
        guard let model = try? rem(configuration: MLModelConfiguration()) else {
            fatalError("Unable to load model")
        }
        
        let input = remInput(Age: age,
                             Gender: gender,
                             Sleepduration: sleepDuration,
                             Sleepefficiency: sleepEfficiency,
                             Deepsleeppercentage: deepSleepPerc,
                             Smokingstatus: smoking,
                             Exercisefrequency: exerciseFreq)
        
        guard let output = try? model.prediction(input: input) else {
            fatalError("Unable to make prediction")
        }
        
        return output.REMsleeppercentage
        
    }
}


func getDeepSleepPerc(age: Double,
                      gender: Double,
                      sleepDuration: Double,
                      sleepEfficiency: Double,
                      remSleepPerc: Double,
                      smoking: Double,
                      exerciseFreq: Double) -> Double {
    // Uses regressor to predict deep sleep percentage. Predicts how much deep sleep you need.
    
    do {
        
        guard let model = try? deep(configuration: MLModelConfiguration()) else {
            fatalError("Unable to load model")
        }
        
        let input = deepInput(Age: age,
                              Gender: gender,
                              Sleepduration: sleepDuration,
                              Sleepefficiency: sleepEfficiency,
                              REMsleeppercentage: remSleepPerc,
                              Smokingstatus: smoking,
                              Exercisefrequency: exerciseFreq)
        
        guard let output = try? model.prediction(input: input) else {
            fatalError("Unable to make prediction")
        }
        
        return output.Deepsleeppercentage
        
    }
}


func getAge(gender: Double,
            sleepDuration: Double,
            sleepEfficiency: Double,
            remSleepPerc: Double,
            deepSleepPerc: Double,
            smoking: Double,
            exerciseFreq: Double) -> Double {
    
    // Uses regressor to predict age. Functionality strictly for fun. Does not actually take part in producing in recommendation.
    
    do {
        
        guard let model = try? age(configuration: MLModelConfiguration()) else {
            fatalError("Unable to load model")
        }
        
        let input = ageInput(Gender: gender,
                              Sleepduration: sleepDuration,
                              Sleepefficiency: sleepEfficiency,
                              REMsleeppercentage: remSleepPerc,
                              Deepsleeppercentage: deepSleepPerc,
                              Smokingstatus: smoking,
                              Exercisefrequency: exerciseFreq)
        
        guard let output = try? model.prediction(input: input) else {
            fatalError("Unable to make prediction")
        }
        
        return output.Age
        
    }
}

    
func classifySleepEff(age: Double,
                      gender: Double,
                      sleepDuration: Double,
                      remSleepPerc: Double,
                      deepSleepPerc: Double,
                      smoking: Double,
                      exerciseFreq: Double)->Int64 {
    
    do
    {
        guard let model = try? cSleepE5(configuration: MLModelConfiguration()) else {
            fatalError("Unable to load model")
        }
        
        let input = cSleepE5Input(Age: age,
                                  Gender: gender,
                                  Sleepduration: sleepDuration,
                                  REMsleeppercentage: remSleepPerc,
                                  Deepsleeppercentage: deepSleepPerc,
                                  Smokingstatus: smoking,
                                  Exercisefrequency: exerciseFreq)
        
        guard let output = try? model.prediction(input: input) else {
            fatalError("Unable to make prediction")
        }
        return output.Sleepefficiency
    }
}


func classifySmoking(age: Double,
                     gender: Double,
                     sleepEff: Double,
                     sleepDuration: Double,
                     remSleepPerc: Double,
                     deepSleepPerc: Double,
                     exerciseFreq: Double)->Int64 {
    
    do
    {
        guard let model = try? csmoke(configuration: MLModelConfiguration()) else {
            fatalError("Unable to load model")
        }
        
        let input = csmokeInput(Age: age,
                                  Gender: gender,
                                  Sleepduration: sleepDuration,
                                 Sleepefficiency: sleepEff,
                                  REMsleeppercentage: remSleepPerc,
                                  Deepsleeppercentage: deepSleepPerc,
                                  Exercisefrequency: exerciseFreq)
        
        guard let output = try? model.prediction(input: input) else {
            fatalError("Unable to make prediction")
        }
        return output.Smokingstatus
    }
}


func classifyExerciseFreq(age: Double,
                          gender: Double,
                          sleepEff: Double,
                          sleepDuration: Double,
                          remSleepPerc: Double,
                          deepSleepPerc: Double,
                          smoking: Double)->Int64 {
    
    do
    {
        guard let model = try? cexerfreq(configuration: MLModelConfiguration()) else {
            fatalError("Unable to load model")
        }
        
        let input = cexerfreqInput(Age: age,
                                   Gender: gender,
                                   Sleepduration: sleepDuration,
                                   Sleepefficiency: sleepEff,
                                   REMsleeppercentage: remSleepPerc,
                                   Deepsleeppercentage: deepSleepPerc,
                                   Smokingstatus: smoking)
        
        guard let output = try? model.prediction(input: input) else {
            fatalError("Unable to make prediction")
        }
        return output.Exercisefrequency
    }
}




