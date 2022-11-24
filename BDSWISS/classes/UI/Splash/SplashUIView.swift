//
//  SplashUIView.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 23.11.2022.
//

import SwiftUI

struct SplashUIView: View {
    
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    @State private var willMoveToNextScreen = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center) {
                Spacer()
                HStack() {
                    Spacer()
                    Image("logo")
                                        .resizable()
                                        .aspectRatio(CGSizeMake(204, 55), contentMode: .fill)
                                        .padding(3)
                                        .frame(maxWidth: 204, maxHeight: 55, alignment: .center)
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
                .frame(maxWidth: .infinity, maxHeight: 40.0, alignment: .center)
                .background(Color.clear)
                HStack(alignment: .bottom) {
                    Text("Loading please wait...")
                        .font(.system(size: 14))
                        .padding(.bottom, 16.0)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 16.0, alignment: .center)
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
                DataManager.sharedInstance.fetchData()
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
