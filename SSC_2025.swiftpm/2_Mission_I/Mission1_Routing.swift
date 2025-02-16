//
//  CellType.swift
//  SSC_2025
//
//  Created by Lukas on 05.02.25.
//

import SwiftUI

// MARK: - Data Model

enum CellType {
    case start, goal, road, area
}

struct Position: Hashable {
    let row: Int
    let col: Int
}

enum PuzzleState {
    case playing, completed, timedOut
}

// MARK: - Main Puzzle View

struct Mission_Routing: View {
    // Grid dimensions for a 15×12 field.
    let rows = 15
    let columns = 12

    // Fixed start and goal positions.
    let startPos = Position(row: 0, col: 0)
    let goalPos = Position(row: 14, col: 11)

    /// A hard-coded grid layout simulating a village/city.
    @State var grid: [[CellType]] = [
        // Row 0
        [.start, .road,  .area,  .road,  .area,  .area,  .road,  .area,  .road,  .area,  .road,  .area],
        // Row 1
        [.road,  .road,  .road,  .road,  .road,  .area,  .road,  .road,  .road,  .area,  .road,  .area],
        // Row 2
        [.area,  .area,  .road,  .area,  .road,  .road,  .road,  .area,  .road,  .road,  .road,  .area],
        // Row 3
        [.road,  .road,  .road,  .area,  .area,  .area,  .road,  .area,  .road,  .area,  .road,  .area],
        // Row 4
        [.area,  .road,  .area,  .road,  .road,  .road,  .road,  .road,  .road,  .area,  .road,  .area],
        // Row 5
        [.area,  .road,  .area,  .area,  .area,  .area,  .area,  .area,  .road,  .road,  .road,  .area],
        // Row 6
        [.area,  .road,  .road,  .road,  .road,  .road,  .area,  .area,  .road,  .area,  .road,  .area],
        // Row 7
        [.road,  .road,  .road,  .road,  .area,  .area,  .area,  .road,  .road,  .area,  .road,  .area],
        // Row 8
        [.area,  .area,  .area,  .road,  .road,  .road,  .road,  .road,  .area,  .area,  .road,  .area],
        // Row 9
        [.area,  .road,  .road,  .area,  .area,  .area,  .area,  .road,  .road,  .road,  .road,  .area],
        // Row 10
        [.road,  .road,  .area,  .area,  .road,  .road,  .area,  .area,  .road,  .area,  .area,  .area],
        // Row 11
        [.area,  .road,  .area,  .road,  .road,  .area,  .road,  .road,  .road,  .area,  .road,  .area],
        // Row 12
        [.area,  .road,  .road,  .road,  .area,  .road,  .area,  .area,  .road,  .road,  .road,  .area],
        // Row 13
        [.road,  .area,  .area,  .road,  .road,  .road,  .road,  .area,  .area,  .area,  .road,  .area],
        // Row 14
        [.area,  .area,  .area,  .area,  .area,  .road,  .road,  .road,  .road,  .road,  .road,  .goal]
    ]

    @State var selectedPath: [Position] = []
    @State var fireEnginePosition: Position? = nil

    @State var timeRemaining: Int = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var puzzleState: PuzzleState = .playing
    @State var animatingFireEngine: Bool = false

    // Fixed cell size and spacing.
    let cellSize: CGFloat = 25
    let spacing: CGFloat = 2

    // Calculate total grid size.
    var gridWidth: CGFloat {
        return CGFloat(columns) * cellSize + CGFloat(columns - 1) * spacing
    }
    var gridHeight: CGFloat {
        return CGFloat(rows) * cellSize + CGFloat(rows - 1) * spacing
    }

    var body: some View {
        ZStack {
            // Center the grid (with fixed size) on the screen.
            VStack {
                Spacer()
                ZStack {
                    // Build grid using VStack/HStack with fixed cell sizes.
                    VStack(spacing: spacing) {
                        ForEach(0..<rows, id: \.self) { row in
                            HStack(spacing: spacing) {
                                ForEach(0..<columns, id: \.self) { col in
                                    let pos = Position(row: row, col: col)
                                    let cellType = grid[row][col]
                                    let isSelected = selectedPath.contains(pos)
                                    let hasFireEngine = (fireEnginePosition == pos)

                                    GridCellView(cellType: cellType,
                                                 isSelected: isSelected,
                                                 hasFireEngine: hasFireEngine)
                                        .frame(width: cellSize, height: cellSize)
                                }
                            }
                        }
                    }
                    .frame(width: gridWidth, height: gridHeight)
                    .background(Color.clear)
                    .coordinateSpace(name: "grid")
                    // Attach a high priority drag gesture to the fixed-size grid.
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged { value in
                                guard puzzleState == .playing, !animatingFireEngine else { return }

                                // Use the grid view's coordinate space.
                                let location = value.location
                                let effectiveWidth = cellSize + spacing
                                let effectiveHeight = cellSize + spacing

                                // Determine which cell is being touched.
                                let col = min(max(Int(location.x / effectiveWidth), 0), columns - 1)
                                let row = min(max(Int(location.y / effectiveHeight), 0), rows - 1)
                                let pos = Position(row: row, col: col)

                                if selectedPath.isEmpty {
                                    if pos == startPos {
                                        selectedPath.append(pos)
                                    }
                                    return
                                }

                                if let last = selectedPath.last, last == pos { return }

                                if let last = selectedPath.last,
                                   abs(pos.row - last.row) + abs(pos.col - last.col) == 1 {
                                    let cellType = grid[row][col]
                                    if cellType == .road || cellType == .goal || cellType == .start {
                                        if let existingIndex = selectedPath.firstIndex(of: pos) {
                                            selectedPath = Array(selectedPath.prefix(upTo: existingIndex + 1))
                                        } else {
                                            selectedPath.append(pos)
                                        }
                                    }
                                }
                            }
                            .onEnded { _ in
                                if let last = selectedPath.last, last == goalPos {
                                    animateFireEngine()
                                } else {
                                    selectedPath = []
                                }
                            }
                    )
                }
                Spacer()
            }

            // Timer overlay in the top right.
            VStack {
                HStack {
                    Spacer()
                    Text("Time: \(timeRemaining)")
                        .font(.headline)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding([.top, .trailing], 16)
                }
                Spacer()
            }

            // Message overlays.
            if puzzleState == .timedOut {
                MessageOverlayView(message: "Time’s up! The fire truck had to leave without you.")
            } else if puzzleState == .completed && !animatingFireEngine {
                let pathLength = selectedPath.count
                MessageOverlayView(message:
                    "You used \(pathLength) cells (meters).\nIn reality, it can take 4–6 minutes to reach a fire scene.\nThat’s why volunteer firefighters are so critical.")
            }

            // Restart button when game is over.
            if puzzleState != .playing {
                VStack {
                    Spacer()
                    Button(action: restartPuzzle) {
                        Text("Restart Puzzle")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .onReceive(timer) { _ in
            guard puzzleState == .playing else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                puzzleState = .timedOut
            }
        }
    }

    // MARK: - Fire Engine Animation

    func animateFireEngine() {
        animatingFireEngine = true
        for (index, pos) in selectedPath.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                withAnimation(.linear(duration: 0.25)) {
                    fireEnginePosition = pos
                }
                if index == selectedPath.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animatingFireEngine = false
                        puzzleState = .completed
                    }
                }
            }
        }
    }

    // MARK: - Restart

    func restartPuzzle() {
        selectedPath = []
        fireEnginePosition = nil
        timeRemaining = 30
        puzzleState = .playing
    }
}

// MARK: - Grid Cell View

struct GridCellView: View {
    let cellType: CellType
    let isSelected: Bool
    let hasFireEngine: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(baseColor)
                //.overlay(Circle().stroke(Color.black, lineWidth: 1))
            if isSelected && (cellType == .road) {
                Circle()
                    .fill(Color.orange.opacity(0.6))
            }
            if hasFireEngine {
                Circle()
                    .fill(Color.blue)
                    //.frame(width: 12, height: 12)
            }
        }
    }

    var baseColor: Color {
        switch cellType {
        case .start: return Color.blue
        case .goal: return Color.red
        case .road: return Color(.darkGray)
        case .area: return Color(.lightGray)
        }
    }
}

// MARK: - Message Overlay View

struct MessageOverlayView: View {
    let message: String
    var body: some View {
        VStack {
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 10)
                .padding()
            Spacer()
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Mission_Routing()
    }
}



