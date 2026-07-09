//
//  play.swift
//  Marketplace
//
//  Created by Muneer Abass on 09/07/26.
//

import Playgrounds

func removeDuplicates(_ arr: inout [Int], size: Int) -> [Int]{
    var tempArr: [Int] = []

    for i in 0..<size {

        
        if tempArr.contains(arr[i]){
            continue
        }
        else{
            tempArr.append(arr[i])
        }

    }
    
    return tempArr
    
}


#Playground {
    
    
    var arr: [Int] = [1, 2, 2, 4, 5, 6, 7,7 ]
    
    var arrc: [Character] = ["a", "b", "c" ]

    var size = arr.count

    
    arr = removeDuplicates(&arr, size: size)
    
    print(arr, "New Array")
    
    var a: Int = 5
    var b: Int = 10
    
    swap(&a, &b)
    
    print(a, b)
}
