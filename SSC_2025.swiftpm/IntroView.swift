//
//  DottedGermanyArrayView.swift
//  ssc2025
//
//  Created by Lukas on 29.01.25.
//


import SwiftUI

struct IntroView: View {

    @Binding var currentMode: Mode

    let germanyMatrix: [[Int]] = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 1
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0], // 5
        [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0], // 10
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0], // 15
        [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
        [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
        [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
        [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0], // 20
        [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0], // 25
        [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0], // 30
        [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 35
    ]

    let dotSize: CGFloat = 9
    let spacing: CGFloat = 6

    @State private var activePoint: (row: Int, col: Int)? = nil
    @State private var fadingPoint: (row: Int, col: Int)? = nil

    @State private var showHint = true
    @State private var zoomedIn = false

    @State var flashingTimer: Timer?

    @State private var currentIndex = 0
    private let intoTextViews: [AnyView] = [
        AnyView(IntroText1()),
        AnyView(IntroText2()),
        AnyView(IntroText3())
    ]


    var body: some View {
        VStack {
            Spacer()
            HStack (spacing: 40){
                ZStack {
                    ForEach(0..<intoTextViews.count, id: \.self) { index in
                        if index == currentIndex {
                            intoTextViews[index]
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .bottom)
                                            .combined(with: .opacity),
                                        removal: .move(edge: .top)
                                            .combined(with: .opacity)
                                    )
                                )
                        }
                    }
                }

                gridView
                    .scaleEffect(zoomedIn ? 25.0 : 1.0)
                    .opacity(zoomedIn ? 0.0 : 1.0)
                    .offset(x: zoomedIn ? -1330 : 0, y: zoomedIn ? -5210 : 0)
                    .animation(.easeInOut(duration: 1.0), value: zoomedIn)
            }
            Spacer()
            if currentIndex == 0 {
                Text("Tap anywhere to continue")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 25)
                    .opacity(showHint ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.1), value: showHint)
            }
        }
        .onAppear {
            startFlashingMode()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("Tap")
            showHint = false
            withAnimation(.easeInOut(duration: 1)) {
                currentIndex = (currentIndex + 1)// % intoTextViews.count
            }
            if currentIndex >= 3 {
                stopFlashingMode()
                startLevelMode()
            }
        }
    }

    private var gridView: some View {
        VStack(spacing: spacing) {
            ForEach(0..<germanyMatrix.count, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<germanyMatrix[row].count, id: \.self) { col in
                        if germanyMatrix[row][col] == 1 {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(
                                        (activePoint?.row == row && activePoint?.col == col) ? Color.red :
                                            (fadingPoint?.row == row && fadingPoint?.col == col) ? Color.red.opacity(0.6) :
                                            Color.primary.opacity(0.5)
                                    )
                                    .frame(width: dotSize, height: dotSize)
                                    .animation(.spring(duration: 0.7), value: activePoint != nil)
                                    .animation(.easeOut(duration: 0.5), value: fadingPoint == nil)

                                if activePoint?.row == row && activePoint?.col == col {
                                    EmergencyRipple(dotSize: dotSize)
                                }
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.clear)
                                .frame(width: dotSize, height: dotSize)
                        }
                    }
                }
            }
        }
        .padding()
    }

    func startLevelMode() {
        fadingPoint = nil
        activePoint = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            activePoint = (row: 31, col: 18)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                zoomedIn = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.spring) {
                        currentMode = .level1
                    }
                }
            }
        }
    }

    func startFlashingMode() {
        runDot()
        flashingTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 6...8), repeats: true) { _ in
            DispatchQueue.main.async {
                if !zoomedIn {
                    runDot()
                }
            }
        }
    }

    func stopFlashingMode() {
        flashingTimer?.invalidate()
        flashingTimer = nil
    }

    func runDot() {
        print("start New Flash")
        DispatchQueue.main.async {
            var possiblePoints: [(Int, Int)] = []
            for row in 0..<germanyMatrix.count {
                for col in 0..<germanyMatrix[row].count {
                    if germanyMatrix[row][col] == 1 {
                        possiblePoints.append((row, col))
                    }
                }
            }

            if let newPoint = possiblePoints.randomElement() {
                activePoint = newPoint
                print("new Point")

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    print("switching to Fading Point")
                    fadingPoint = newPoint
                    activePoint = nil

                    let fadeDuration = Double.random(in: 15.0...20.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration) {
                        print("done")
                        fadingPoint = nil
                    }
                }
            }
        }
    }
}

struct EmergencyRipple: View {
    let dotSize: CGFloat
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(Color.red.opacity(0.6), lineWidth: 2)
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(animate ? 5.0 : 1.0)
                    .opacity(animate ? 0.0 : 1.0)
                    .animation(Animation.easeOut(duration: 1.5).delay(Double(i) * 0.3), value: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct IntroText1: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Every 7 seconds")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 35, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(.red))
                Text("a fire brigade in Germany")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 35, weight: .medium, design: .monospaced))
                Text("answers an emergency call.")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 35, weight: .medium, design: .monospaced))
                Text("(On average, that’s over 12,000 calls every day.)")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            }
            Spacer()
        }
        .frame(width: 575)
        .frame(maxHeight: .infinity, alignment: .center)
        .padding()
    }
}

struct IntroText2: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("More than 1 million")
                    .font(.system(size: 35, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(.red))
                Text("volunteer firefighters")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 35, weight: .medium, design: .monospaced))
                Text("serve day and night.")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 35, weight: .medium, design: .monospaced))
            }
            Spacer()
        }
        .frame(width: 575)
        .frame(maxHeight: .infinity, alignment: .center)
        .padding()
    }
}

struct IntroText3: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Explore their daily challenges")
                .foregroundStyle(Color(.red))
                .font(.system(size: 35, weight: .bold, design: .monospaced))
            Text("and learn how they respond")
                .font(.system(size: 35, weight: .medium, design: .monospaced))
            Text("to emergencies.")
                .font(.system(size: 35, weight: .medium, design: .monospaced))
        }
        .frame(width: 575)
        .frame(maxHeight: .infinity, alignment: .center)
        .padding()
    }
}

struct DottedGermanyArrayView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(currentMode: .constant(.intro))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
