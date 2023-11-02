//
//  ContentView.swift
//  CarMirror
//
//  Created by 董森 on 2023/11/1.
//

import SwiftUI
import Foundation


// 示例用法
let commandPath = "/Users/dongsen/Documents/Code/iOS/CarMirror/CarMirror/libs/scrcpy/bin/scrcpy"
let commandArguments = [""]


struct ContentView: View {
    var body: some View {
        VStack {
            Button("scrcpy") {
                          // 在这里添加按钮点击时要执行的操作
                          print("Button clicked!")

                            if let result = run_shell(launchPath: commandPath, arguments: commandArguments) {
                                print("命令执行结果: \(result)")
                            } else {
                                print("命令执行失败")
                            }
                      }
                      .padding()
                      .background(Color.blue)
                      .foregroundColor(.white)
                      .cornerRadius(10)
            
            Button("adb devices") {
                          // 在这里添加按钮点击时要执行的操作
                          print("Button clicked!")
                if let result = run_shell(launchPath: "/Users/dongsen/Documents/Code/iOS/CarMirror/CarMirror/libs/android-platform-tools/platform-tools/adb", arguments: ["devices"]) {
                            print("命令执行结果: \(result)")
                        } else {
                            print("命令执行失败")
                        }
                      }
                      .padding()
                      .background(Color.blue)
                      .foregroundColor(.white)
                      .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

func run_shell(launchPath: String, arguments: [String]? = nil) -> String? {
    let task = Process()
    task.launchPath = launchPath

    if let args = arguments {
        task.arguments = args
    }

    let pipe = Pipe()
    task.standardOutput = pipe

    let errorPipe = Pipe()
    task.standardError = errorPipe
    
    task.launch()
    task.waitUntilExit()
//    pipe.fileHandleForReading.closeFile()        // 关闭pipe防止内存泄露
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

    if let output = String(data: data, encoding: .utf8) {
        return output
    } else {
        print("Failed to convert data to string for output")
    }

    if let errorOutput = String(data: errorData, encoding: .utf8) {
        print("Error output: \(errorOutput)")
    } else {
        print("Failed to convert data to string for error output")
    }

    return nil
}
