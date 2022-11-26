//
//  SplashUIView.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 23.11.2022.
//

import SwiftUI

struct SplashUIView: View {
    
    private enum Constants {
        static let timeDelay = 2.5
        static let imageWidth = 204.0
        static let imageHeight = 55.0
        static let textHeight = 16.0
        static let textMaxHeight = 40.0
    }
    
    let timer = Timer.publish(every: Constants.timeDelay, on: .main, in: .common).autoconnect()
    
    @State private var willMoveToNextScreen = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center) {
                Spacer()
                HStack() {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .aspectRatio(CGSizeMake(Constants.imageWidth, Constants.imageHeight), contentMode: .fill)
                        .padding(3)
                        .frame(maxWidth: Constants.imageWidth, maxHeight: Constants.imageHeight, alignment: .center)
                        .foregroundColor(Color.clear)
                    Spacer()
                }
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack() {
                    ActivityIndicator(isAnimating: true) {
                        $0.hidesWhenStopped = true
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: Constants.textMaxHeight, alignment: .center)
                .background(Color.clear)
                HStack(alignment: .bottom) {
                    Text(textLoading)
                        .font(textFont)
                        .padding(.bottom, Constants.textHeight)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: Constants.textHeight, alignment: .center)
                .background(Color.clear)
                .padding(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .background(Color.clear)
        .edgesIgnoringSafeArea(.all)
        .navigate(to: MainUIView(), when: $willMoveToNextScreen)
        .navigationBarHidden(true)
        .onReceive(timer) { time in
            timer.upstream.connect().cancel()
            willMoveToNextScreen = true
        }
        .onAppear {
            DataManager.shared.fetchData()
        }
    }
}

class ChildHostingController: UIHostingController<SplashUIView> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: SplashUIView());
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

#if DEBUG
struct SplashUIView_Previews: PreviewProvider {
    static var previews: some View {
        SplashUIView()
    }
}
#endif
