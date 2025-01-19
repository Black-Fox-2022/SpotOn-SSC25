//
//  CityKitView.swift
//  citykit
//
//  Created by Lukas on 17.01.25.
//


import SwiftUI

struct CityKitView: View {
    @State private var grid: [[Tile?]] = Array(repeating: Array(repeating: nil, count: rows), count: columns) // 10x8 grid

    @State private var stacks: [TileType: [Tile]] = [
        .residential: (0..<20).map { _ in Tile(type: .residential) },
        .commercial: (0..<15).map { _ in Tile(type: .commercial) },
        .industrial: (0..<15).map { _ in Tile(type: .industrial) },
        .streets: (0..<30).map { _ in Tile(type: .streets) },
        .parks: (0..<5).map { _ in Tile(type: .parks) },
        .renewableEnergy: (0..<5).map { _ in Tile(type: .renewableEnergy) },
        .nonRenewableEnergy: (0..<5).map { _ in Tile(type: .nonRenewableEnergy) },
        .water: (0..<5).map { _ in Tile(type: .water) },
        .landfill: (0..<5).map { _ in Tile(type: .landfill) },
    ]

    @State private var showIcons: Bool = true
    @State private var energyProduction = 0
    @State private var energyConsumption = 0
    @State private var connectedTiles = 0
    @State private var totalTilesNeedingConnections = 0

    static let tileSize: CGFloat = 55 // Make dynamic later!
    static let rows: Int = 11
    static let columns: Int = 8

    var body: some View {
        VStack {
            HStack {
                Text("CityKit - Time to build something new")
                    .font(.system(size: 30, weight: .semibold))
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)

            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 14) {
                    // City Grid
                    VStack(spacing: 1) {
                        ForEach(0..<CityKitView.columns, id: \.self) { row in
                            HStack(spacing: 1) {
                                ForEach(0..<CityKitView.rows, id: \.self) { column in
                                    GridCellView(
                                        tile: $grid[row][column],
                                        tileSize: CityKitView.tileSize,
                                        onDragTile: { removedTile in
                                            stacks[removedTile.type]?.append(removedTile)
                                            recalculateResources()
                                        },
                                        getStreetType: {
                                            determineStreetType(for: row, column: column)
                                        },showIcons: showIcons
                                    )
                                    .onDrop(of: [.utf8PlainText], isTargeted: nil) { providers in
                                        handleDrop(providers: providers, row: row, column: column)
                                    }
                                }
                            }
                        }
                    }
                    .padding()

                    // Tile Selector
                    HStack(alignment: .center, spacing: 10) {
                        ForEach(TileType.allCases, id: \.self) { type in
                            VStack {
                                ZStack(alignment: .topLeading) {
                                    ForEach(Array((stacks[type] ?? []).enumerated()), id: \.1.id) { index, tile in
                                        TileView(tile: tile, size: CityKitView.tileSize)
                                            .customizeOnDrag(minimumPressDuration: 0.1)
                                            .onDrag {
                                                NSItemProvider(object: tile.id.uuidString as NSString)
                                            }
                                    }
                                }
                                .frame(height: CGFloat(CityKitView.tileSize))
                                Text("\(stacks[type]?.count ?? 0)")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: CityKitView.tileSize)
                        }
                    }
                    .padding(.horizontal)

                    Toggle("Show Icons on Tiles", isOn: $showIcons)
                        .padding()
                        .font(.headline)
                }

                // Charts/Regulations Placeholder
                VStack {
                    Text("City Metrics")
                        .font(.title)
                        .padding()

                    Text("Energy Production: \(energyProduction)")
                        .font(.headline)
                    Text("Energy Consumption: \(energyConsumption)")
                        .font(.headline)
                    Text("Connected Tiles: \(connectedTiles) / \(totalTilesNeedingConnections)")
                        .font(.headline)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
        }
        .padding(30)
        .background(Color.gray.opacity(0.2))
    }

    private func updateConnections() {
        var visited = Set<[Int]>()
        for row in grid.indices {
            for column in grid[row].indices {
                if let tile = grid[row][column] {
                    if tile.type == .streets {
                        // Streets are always considered connected
                        grid[row][column]?.connected = true
                    } else if tile.type.needsStreetConnection {
                        // Check connectivity for tiles requiring street connections
                        let _ = floodFill(row: row, column: column, visited: &visited)
                    }
                }
            }
        }
    }

    private func recalculateResources() {
        var totalProduction = 0
        var totalConsumption = 0
        var connected = 0
        var totalWithNeeds = 0

        // Update connections before calculating resources
        updateConnections()

        for row in grid.indices {
            for column in grid[row].indices {
                if let tile = grid[row][column] {
                    // Count energy production only for connected tiles or renewable energy
                    if tile.connected || tile.type == .renewableEnergy {
                        totalProduction += tile.producesEnergy
                    }

                    // Count energy consumption only for connected tiles
                    if tile.connected {
                        totalConsumption += tile.needsEnergy
                    }

                    // Count total tiles needing connections and those connected
                    if tile.type.needsStreetConnection {
                        totalWithNeeds += 1
                        if tile.connected {
                            connected += 1
                        }
                    }
                }
            }
        }

        energyProduction = totalProduction
        energyConsumption = totalConsumption
        connectedTiles = connected
        totalTilesNeedingConnections = totalWithNeeds
    }

    private func floodFill(row: Int, column: Int, visited: inout Set<[Int]>) -> Bool {
        guard row >= 0, row < grid.count, column >= 0, column < grid[0].count else { return false }
        guard let tile = grid[row][column], !visited.contains([row, column]) else { return false }

        // Mark this tile as visited
        visited.insert([row, column])

        // If it's a street, it propagates connection
        if tile.type == .streets {
            grid[row][column]?.connected = true
            return true
        }

        // If it's a tile needing connection, check neighbors recursively
        let neighbors = [
            (row - 1, column), // North
            (row + 1, column), // South
            (row, column - 1), // West
            (row, column + 1)  // East
        ]

        var isConnected = false
        for (neighborRow, neighborCol) in neighbors {
            if floodFill(row: neighborRow, column: neighborCol, visited: &visited) {
                isConnected = true
            }
        }

        // Mark this tile as connected if any neighbor is connected
        if isConnected {
            grid[row][column]?.connected = true
        }
        print("Tile at (\(row), \(column)) connected: \(grid[row][column]?.connected ?? false)")

        return isConnected
    }

    private func determineStreetType(for row: Int, column: Int) -> (String, Double)? {
        guard let tile = grid[row][column], tile.type == .streets else { return nil }

        let neighbors = [
            (-1, 0), // North
            (1, 0),  // South
            (0, -1), // West
            (0, 1)   // East
        ]

        var connections: [String] = []

        for (index, (dr, dc)) in neighbors.enumerated() {
            let newRow = row + dr
            let newCol = column + dc

            if newRow >= 0, newRow < grid.count,
               newCol >= 0, newCol < grid[0].count,
               grid[newRow][newCol]?.type == .streets {
                switch index {
                case 0: connections.append("N") // North
                case 1: connections.append("S") // South
                case 2: connections.append("W") // West
                case 3: connections.append("E") // East
                default: break
                }
            }
        }

        let connectionSet = Set(connections)

        if connectionSet == ["N"] { return ("street_straight_LR", 90) } // Vertical, connected North
        if connectionSet == ["S"] { return ("street_straight_LR", 90) } // Vertical, connected South
        if connectionSet == ["W"] { return ("street_straight_LR", 0) }  // Horizontal, connected West
        if connectionSet == ["E"] { return ("street_straight_LR", 0) }  // Horizontal, connected East

        // Handle straight roads
        if connectionSet == ["N", "S"] { return ("street_straight_LR", 90) } // Vertical
        if connectionSet == ["W", "E"] { return ("street_straight_LR", 0) } // Horizontal

        // Handle corners
        if connectionSet == ["N", "E"] { return ("street_corner_BR", 270) }
        if connectionSet == ["N", "W"] { return ("street_corner_BR", 180) }
        if connectionSet == ["S", "E"] { return ("street_corner_BR", 0) }
        if connectionSet == ["S", "W"] { return ("street_corner_BR", 90) }

        // Handle T-junctions
        if connectionSet == ["W", "N", "E"] { return ("street_t-junction_LRT", 0) }   // Default: West, North, East
        if connectionSet == ["N", "S", "E"] { return ("street_t-junction_LRT", 90) }  // North, South, East
        if connectionSet == ["E", "S", "W"] { return ("street_t-junction_LRT", 180) } // East, South, West
        if connectionSet == ["W", "S", "N"] { return ("street_t-junction_LRT", 270) } // West, South, North

        // Handle crossroad
        if connectionSet == ["N", "S", "E", "W"] { return ("street_x-crossing", 0) } // Crossroads

        // Fallback for isolated streets
        return ("street_straight_LR", 0) // Default to horizontal straight road
    }


    private func handleDrop(providers: [NSItemProvider], row: Int, column: Int) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadObject(ofClass: NSString.self) { object, _ in
            guard let idString = object as? String, let tileID = UUID(uuidString: idString) else { return }

            DispatchQueue.main.async {
                // Check if a tile already exists at the target location
                if let existingTile = grid[row][column] {
                    // Return the existing tile to its stack
                    mediumFeedback()
                    stacks[existingTile.type]?.append(existingTile)
                }

                // Check if the tile is being moved from another grid cell
                for r in 0..<grid.count {
                    for c in 0..<grid[r].count {
                        if grid[r][c]?.id == tileID {
                            // Move the tile to the new location
                            grid[row][column] = grid[r][c]
                            grid[r][c] = nil // Clear the original cell
                            recalculateResources()
                            return
                        }
                    }
                }

                // Handle the tile coming from a stack
                for (type, tiles) in stacks {
                    if let index = tiles.firstIndex(where: { $0.id == tileID }) {
                        grid[row][column] = stacks[type]?.remove(at: index)
                        recalculateResources()
                        return
                    }
                }
            }
        }
        recalculateResources()
        return true
    }
}

struct GridCellView: View {
    @Binding var tile: Tile?
    let tileSize: CGFloat
    let onDragTile: (Tile) -> Void
    let getStreetType: () -> (String, Double)? // Returns the asset name and rotation angle
    let showIcons: Bool

    var body: some View {
        ZStack (alignment: .topTrailing){

            // Base cell
            Image("forest_1")
                .resizable()
                .scaledToFit()
                .frame(width: tileSize, height: tileSize)

            // If the tile is a street
            if let currentTile = tile, currentTile.type == .streets {
                if let (streetAsset, rotationAngle) = getStreetType() {
                    // Display street asset with dynamic rotation
                    Image(streetAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: tileSize, height: tileSize)
                        .rotationEffect(.degrees(rotationAngle))
                        .onDrag {
                            NSItemProvider(object: currentTile.id.uuidString as NSString)
                        }
                } else {
                    // Fallback for streets with no neighbors
                    Image("street_straight_LR")
                        .resizable()
                        .scaledToFit()
                        .frame(width: tileSize, height: tileSize)
                        .onDrag {
                            NSItemProvider(object: currentTile.id.uuidString as NSString)
                        }
                }
            } else if let currentTile = tile {
                // Non-street tiles

                if currentTile.type == .renewableEnergy {
                    Image("energy_solar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: tileSize, height: tileSize)
                        .onDrag {
                            NSItemProvider(object: currentTile.id.uuidString as NSString)
                        }

                }else if currentTile.type == .commercial {
                    Image("commercial_1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: tileSize, height: tileSize)
                        .onDrag {
                            NSItemProvider(object: currentTile.id.uuidString as NSString)
                        }
                }else {
                    TileView(tile: currentTile, size: tileSize)
                        .onDrag {
                            NSItemProvider(object: currentTile.id.uuidString as NSString)
                        }
                }
            }

            if let currentTile = tile, currentTile.type != .streets {
                Rectangle()
                    .stroke(currentTile.type.color, lineWidth: 2) // Border in tile's color
                    .frame(width: tileSize, height: tileSize)

                if showIcons {
                    Image(systemName: currentTile.type.iconName)
                        .foregroundColor(.white)
                        .font(.system(size: tileSize * 0.2))
                }
            }
        }
        .onTapGesture {
            // Handle tap to remove the tile
            if let removedTile = tile {
                mediumFeedback()
                tile = nil
                onDragTile(removedTile) // Return the tile to its stack
            }
        }
    }
}

struct TileView: View {
    var tile: Tile
    let size: CGFloat

    var body: some View {
        ZStack {
            // Background color for the tile
            Rectangle()
                .foregroundColor(tile.type.color)
                .frame(width: size, height: size)

            // Icon for the tile
            if tile.type == .streets {
                Image("street_straight_LR")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tile.type == .renewableEnergy {
                Image("energy_solar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tile.type == .commercial {
                Image("commercial_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            }else {
                Image(systemName: tile.type.iconName)
                    .foregroundColor(.white) // Ensures high contrast and visibility
                    .font(.system(size: size * 0.5)) // Adjust icon size relative to tile size
            }

            VStack {
                Text("\(tile.connected)")
            }
            .font(.system(size: 12))
            .foregroundStyle(.red)
        }
    }
}

// Models
class Tile: Identifiable, ObservableObject {
    let id = UUID()
    let type: TileType
    @Published var needsEnergy: Int = 0
    @Published var producesEnergy: Int = 0
    @Published var connected: Bool = false // Is the tile connected to required infrastructure?
    @Published var energySupplied: Bool = false // Does the tile receive energy?

    init(type: TileType) {
        self.type = type
        self.needsEnergy = type.needsEnergy
        self.producesEnergy = type.producesEnergy
    }
}


enum TileType: String, CaseIterable {
    case residential, commercial, industrial, streets, parks, renewableEnergy, nonRenewableEnergy, water, landfill

    var iconName: String {
        switch self {
        case .residential: return "house.fill"
        case .commercial: return "bag.fill"
        case .industrial: return "gearshape.fill"
        case .streets: return "road.lanes"
        case .parks: return "leaf.fill"
        case .renewableEnergy: return "sun.max.fill"
        case .nonRenewableEnergy: return "flame.fill"
        case .water: return "drop.fill"
        case .landfill: return "trash.fill"
        }
    }

    var color: Color {
        switch self {
        case .residential: return .green
        case .commercial: return .blue
        case .industrial: return .yellow
        case .streets: return .gray
        case .parks: return .green
        case .renewableEnergy: return .cyan
        case .nonRenewableEnergy: return .black
        case .water: return .blue
        case .landfill: return .brown
        }
    }

    var needsEnergy: Int {
        switch self {
        case .residential: return 5 // Higher, as it represents multiple houses
        case .commercial: return 8
        case .industrial: return 15
        default: return 0
        }
    }

    var producesEnergy: Int {
        switch self {
        case .renewableEnergy: return 20
        case .nonRenewableEnergy: return 100
        default: return 0
        }
    }

    var needsStreetConnection: Bool {
        switch self {
        case .residential, .commercial, .industrial, .nonRenewableEnergy, .landfill:
            return true
        default:
            return false
        }
    }
}

extension View {
    public func customizeOnDrag(minimumPressDuration: TimeInterval) -> some View {
        overlay(CustomizeOnDrag(minimumPressDuration: minimumPressDuration).frame(width: 0, height: 0))
    }
}

private struct CustomizeOnDrag: UIViewControllerRepresentable {
    private let minimumPressDuration: TimeInterval

    init(minimumPressDuration: TimeInterval) {
        self.minimumPressDuration = minimumPressDuration
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            let gestureRecognizers = uiViewController.parent?.view.gestureRecognizers?.compactMap({ $0 as? UILongPressGestureRecognizer })
            let liftGesture = gestureRecognizers?.filter({ String(describing: type(of: $0)) == "_UIDragLiftGestureRecognizer" }).first
            liftGesture?.minimumPressDuration = minimumPressDuration
        }
    }
}

// Preview
struct CityKitView_Previews: PreviewProvider {
    static var previews: some View {
        CityKitView()
            .previewDevice("iPad Air (4th generation)")
    }
}
