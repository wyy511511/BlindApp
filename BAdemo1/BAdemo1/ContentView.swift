//
//  ContentView.swift
//  BAdemo1
//
//  Created by 511 on 10/20/22.
//

import SwiftUI
import AVFoundation


//预先创建一个播放器
var soundPlayer: AVAudioPlayer?

func playAudio(forResource: String, ofType: String) {
    
    //定义路径
    let path = Bundle.main.path(forResource: forResource, ofType: ofType)!
    //定义url
    let url = URL(fileURLWithPath: path)
    
    do {
        //尝试使用预设的声音播放器获取目标文件
        soundPlayer = try AVAudioPlayer(contentsOf: url)
        //播放声音————停止的话使用stop()方法
        soundPlayer?.play()
    } catch {
        //加载文件失败，这里用于防止应用程序崩溃
        print("音频文件出现问题")
    }
}

struct ContentView: View {
    var body: some View {

        VStack{
            Button(action: {
                playAudio(forResource: "start", ofType: "wav")
            }
//                   , label: {
//                Text("start")
//            }
            ){
                Image(systemName: "play.circle.fill").resizable()
                    .foregroundColor(Color.green)
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
            }
            
            HStack{
                
                Button(action: {
                    playAudio(forResource: "left", ofType: "wav")
                })
                {
                    Image(systemName: "arrow.left.circle.fill").resizable()
                        .foregroundColor(Color.yellow)
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                }
                
                Text("   ").padding(50)

                
//                Spacer()
                
                Button(action: {
                    playAudio(forResource: "right", ofType: "wav")
                })
                {
                    Image(systemName: "arrow.right.circle.fill").resizable()
                        .foregroundColor(Color.blue)
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                }
                
                
                

                
            }
            
            Button(action: {
                playAudio(forResource: "end", ofType: "wav")
            })
            {
                Image(systemName: "stop.circle.fill").resizable()
                    .foregroundColor(Color.red)
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
            }
            

            
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
}

