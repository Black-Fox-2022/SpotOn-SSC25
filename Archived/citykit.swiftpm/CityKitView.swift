//
//  CityKitView.swift
//  citykit
//
//  Created by Lukas on 17.01.25.
//


import SwiftUI
import Charts

struct CityKitView: View {
    static let rows: Int = 10
    static let columns: Int = 10
    static let tileSize: CGFloat = 45

    // 2D Array: grid[row][column]
    @State private var grid: [[Tile?]] =
        Array(repeating: Array(repeating: nil, count: Self.columns), count: Self.rows)

    // Tile stacks (inventory)
    @State private var stacks: [TileType: [Tile]] = [
        .residential:          (0..<20).map { _ in Tile(type: .residential) },
        .commercial:           (0..<15).map { _ in Tile(type: .commercial) },
        .industrial:           (0..<15).map { _ in Tile(type: .industrial) },
        .streets:              (0..<30).map { _ in Tile(type: .streets) },
        .parks:                (0..<5).map  { _ in Tile(type: .parks) },
        .renewableEnergy:      (0..<5).map  { _ in Tile(type: .renewableEnergy) },
        .nonRenewableEnergy:   (0..<5).map  { _ in Tile(type: .nonRenewableEnergy) }
       // .water:                (0..<5).map  { _ in Tile(type: .water) }
      //  .landfill:             (0..<5).map  { _ in Tile(type: .landfill) }
    ]

    @State private var backgroundIDs: [[Int]] =
        (0..<Self.rows).map { _ in
            (0..<Self.columns).map { _ in Int.random(in: 1...4) }
        }

    @State private var energyProduction = 0
    @State private var energyConsumption = 0
    @State private var connectedTiles = 0
    @State private var totalTilesNeedingConnections = 0

    @State private var selectedTileType: TileType? = nil

    @State private var swiftBucks: Int = 0
    @State private var currentDay: Int = 0

    @State private var populationHistory: [(day: Int, inhabitants: Int)] = []
    @State private var energyHistory: [(day: Int, consumption: Int, production: Int)] = []
    @State private var moneyHistory: [(day: Int, swiftBucks: Int)] = []

    private let residentsPerHouse = 25
    private let residentTaxPerPerson = 1
    private let commercialTaxPerTile = 10
    private let industrialTaxPerTile = 20


    var body: some View {
        VStack {
            HStack {
                Spacer()
                HUDBar()
                Spacer()
            }
            HStack {
                VStack(alignment: .center, spacing: 20) {

                    HStack {
                        VStack(spacing: 0) {
                            ForEach(0..<Self.rows, id: \.self) { row in
                                HStack(spacing: 0) {
                                    ForEach(0..<Self.columns, id: \.self) { column in
                                        GridCellView(
                                            tile: $grid[row][column],
                                            tileSize: Self.tileSize,
                                            randomNum: backgroundIDs[row][column],
                                            onDragTile: { removedTile in
                                                stacks[removedTile.type]?.append(removedTile)
                                                recalculateResources()
                                            },
                                            onTapCell: {
                                                if let existingTile = grid[row][column] {
                                                    // Remove tile on tap
                                                    removeTile(existingTile, row: row, column: column)
                                                } else {
                                                    // Place a new tile if one is selected
                                                    placeSelectedTile(atRow: row, column: column)
                                                }
                                            },
                                            getStreetType: {
                                                determineStreetType(for: row, column: column)
                                            }
                                        )
                                        .addBorder(width: 0.5, cornerRadius: 0,
                                                   topLeading: row == 0 && column == 0 ? 10 : 0,
                                                   bottomLeading: row == CityKitView.rows - 1 && column == 0 && column == 0 ? 10 : 0,
                                                   topTrailing: row == 0 && column == CityKitView.columns - 1 ? 10 : 0,
                                                   bottomTrailing: row == CityKitView.rows - 1 && column == CityKitView.columns - 1 ? 10 : 0)
                                        .onDrop(of: [.utf8PlainText], isTargeted: nil) { providers in
                                            handleDrop(providers: providers, row: row, column: column)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.secondarySystemBackground))
                        )

                        VStack {
                            ForEach(TileType.allCases, id: \.self) { type in
                                Button {
                                    lightFeedback()
                                    if selectedTileType == type {
                                        selectedTileType = nil
                                    }else {
                                        selectedTileType = type
                                    }
                                } label: {
                                    TileViewForType(tileType: type, size: CityKitView.tileSize)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.secondarySystemBackground))
                        )
                    }

                    /*VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 16) {
                            ForEach(TileType.allCases, id: \.self) { type in
                                Button {
                                    lightFeedback()
                                    if selectedTileType == type {
                                        selectedTileType = nil
                                    }else {
                                        selectedTileType = type
                                    }
                                } label: {
                                    TileViewForType(tileType: type, size: CityKitView.tileSize)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }*/

                    Spacer()
                }
            }
        }
/*
        HStack (alignment: .top){
            ScrollView {
                VStack (alignment: .leading, spacing: 12){
                    Text("Statistics")
                        .font(.system(size: 28, weight: .semibold))

                    HStack {
                        Text("Day: \(currentDay)")
                        Button("Next Day") {
                            nextDay()
                        }
                    }

                    Chart {
                        ForEach(populationHistory, id: \.day) { dataPoint in
                            LineMark(
                                x: .value("Day", dataPoint.day),
                                y: .value("Inhabitants", dataPoint.inhabitants)
                            )
                            .foregroundStyle(.green) // or any color you prefer
                        }
                    }
                    .frame(width: 275, height: 125)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(12)

                    // 2) Energy Chart (two lines: consumption & production)
                    Chart {
                        ForEach(energyHistory, id: \.day) { dataPoint in
                            LineMark(
                                x: .value("Day", dataPoint.day),
                                y: .value("Consumption", dataPoint.consumption)
                            )
                            .foregroundStyle(.red)
                            .symbol(by: .value("Type", "Consumption"))

                            LineMark(
                                x: .value("Day", dataPoint.day),
                                y: .value("Production", dataPoint.production)
                            )
                            .foregroundStyle(.blue)
                            .symbol(by: .value("Type", "Production"))
                        }
                    }
                    .frame(width: 275, height: 125)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(12)

                    Text("Production: \(energyProduction)")
                    Text("Consumption: \(energyConsumption)")
                    Text("Connected: \(connectedTiles) / \(totalTilesNeedingConnections)")

                    Spacer()
                }
            }

            VStack(alignment: .center, spacing: 20) {
                HUDBar()
                VStack(spacing: 1) {
                    ForEach(0..<Self.rows, id: \.self) { row in
                        HStack(spacing: 1) {
                            ForEach(0..<Self.columns, id: \.self) { column in
                                GridCellView(
                                    tile: $grid[row][column],
                                    tileSize: Self.tileSize,
                                    randomNum: backgroundIDs[row][column],
                                    onDragTile: { removedTile in
                                        stacks[removedTile.type]?.append(removedTile)
                                        recalculateResources()
                                    },
                                    onTapCell: {
                                        if let existingTile = grid[row][column] {
                                            // Remove tile on tap
                                            removeTile(existingTile, row: row, column: column)
                                        } else {
                                            // Place a new tile if one is selected
                                            placeSelectedTile(atRow: row, column: column)
                                        }
                                    },
                                    getStreetType: {
                                        determineStreetType(for: row, column: column)
                                    }
                                )
                                .onDrop(of: [.utf8PlainText], isTargeted: nil) { providers in
                                    handleDrop(providers: providers, row: row, column: column)
                                }
                            }
                        }
                    }
                }
                .padding()

                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 16) {
                        ForEach(TileType.allCases, id: \.self) { type in
                            Button {
                                lightFeedback()
                                if selectedTileType == type {
                                    selectedTileType = nil
                                }else {
                                    selectedTileType = type
                                }
                            } label: {
                                TileViewForType(tileType: type, size: CityKitView.tileSize)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
            }
            ScrollView {
                VStack (alignment: .leading, spacing: 12){
                    Text("Regulations")
                        .font(.system(size: 28, weight: .semibold))

                    VStack (alignment: .leading){
                        Text("Free public transit")
                            .font(.headline)
                        Text("Allow every citizen to use public transport for free. Will decrease traffic congestion and reduce air pollution.")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 250)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(12)

                    Spacer()
                }
            }
        }
        .padding(30)
        .onAppear {
            setupInitialCity()
        }*/
    }

    private func nextDay() {
        currentDay += 1

        recalculateResources()

        var connectedResidentialTiles = 0
        var connectedCommercialTiles = 0
        var connectedIndustrialTiles = 0

        for row in 0..<Self.rows {
            for col in 0..<Self.columns {
                if let tile = grid[row][col], tile.connected {
                    switch tile.type {
                    case .residential:
                        connectedResidentialTiles += 1
                    case .commercial:
                        connectedCommercialTiles += 1
                    case .industrial:
                        connectedIndustrialTiles += 1
                    default:
                        break
                    }
                }
            }
        }

        let totalResidents = connectedResidentialTiles * residentsPerHouse
        let residentialTax = totalResidents * residentTaxPerPerson

        let commercialTax = connectedCommercialTiles * commercialTaxPerTile
        let industrialTax = connectedIndustrialTiles * industrialTaxPerTile

        let rawDailyTax = residentialTax + commercialTax + industrialTax

        let coverageRatio: Double
        if energyConsumption > 0, energyProduction < energyConsumption {
            coverageRatio = Double(energyProduction) / Double(energyConsumption)
        } else {
            coverageRatio = 1.0
        }

        populationHistory.append((day: currentDay, inhabitants: totalResidents))
        energyHistory.append((day: currentDay,
                             consumption: energyConsumption,
                             production: energyProduction))
        moneyHistory.append((day: currentDay, swiftBucks: swiftBucks))
    }

    // MARK: - Removing a Tile
    private func removeTile(_ tile: Tile, row: Int, column: Int) {
        // Clear the cell
        grid[row][column] = nil
        // Put the removed tile back into the stack
        stacks[tile.type]?.append(tile)
        recalculateResources()
    }

    // MARK: - Placing a Tile by Tapping
    private func placeSelectedTile(atRow row: Int, column: Int) {
        // 1. Must have a selected tile type
        guard let type = selectedTileType else { return }
        // 2. Must have tile(s) left in the stack
        guard let count = stacks[type]?.count, count > 0 else { return }
        // 3. If cell is empty, place from the stack
        guard grid[row][column] == nil else { return }

        // Remove one tile from the stack & put it on the board
        if let newTile = stacks[type]?.removeFirst() {
            grid[row][column] = newTile
            recalculateResources()
        }
    }

    // MARK: - Connectivity (Simplified)
    private func updateConnections() {
        for row in 0..<Self.rows {
            for column in 0..<Self.columns {
                guard let tile = grid[row][column] else { continue }

                // If tile needs street connection, check adjacency
                if tile.type.needsStreetConnection {
                    let neighbors = [
                        (row - 1, column),
                        (row + 1, column),
                        (row, column - 1),
                        (row, column + 1)
                    ]

                    var hasStreetNeighbor = false
                    for (nr, nc) in neighbors {
                        if nr >= 0, nr < Self.rows, nc >= 0, nc < Self.columns {
                            if let neighborTile = grid[nr][nc], neighborTile.type == .streets {
                                hasStreetNeighbor = true
                                break
                            }
                        }
                    }


                    tile.connected = hasStreetNeighbor
                } else {
                    // e.g. parks, water, renewable, etc.
                    tile.connected = false
                }
            }
        }
    }

    // MARK: - Resource Calculation
    private func recalculateResources() {
        // Update connections first
        updateConnections()

        var totalProduction = 0
        var totalConsumption = 0
        var connectedCount = 0
        var totalThatNeedConnection = 0

        for row in 0..<Self.rows {
            for column in 0..<Self.columns {
                if let tile = grid[row][column] {
                    if tile.type == .renewableEnergy || tile.connected {
                        totalProduction += tile.producesEnergy
                    }

                    if tile.connected {
                        totalConsumption += tile.needsEnergy
                    }

                    // Track "needs street" vs connected
                    if tile.type.needsStreetConnection {
                        totalThatNeedConnection += 1
                        if tile.connected {
                            connectedCount += 1
                        }
                    }
                }
            }
        }

        energyProduction = totalProduction
        energyConsumption = totalConsumption
        connectedTiles = connectedCount
        totalTilesNeedingConnections = totalThatNeedConnection
    }

    // MARK: - Determine Street Asset + Rotation
    private func determineStreetType(for row: Int, column: Int) -> (String, Double)? {
        guard let tile = grid[row][column], tile.type == .streets else { return nil }

        let neighbors: [(offsetName: String, dr: Int, dc: Int)] = [
            ("N", -1, 0),
            ("S",  1, 0),
            ("W",  0, -1),
            ("E",  0,  1)
        ]

        var connections: [String] = []

        for (direction, dr, dc) in neighbors {
            let nr = row + dr
            let nc = column + dc

            if nr >= 0, nr < Self.rows, nc >= 0, nc < Self.columns {
                if grid[nr][nc]?.type == .streets {
                    connections.append(direction)
                }
            }
        }

        let connectionSet = Set(connections)

        // Single direction – simple end piece
        if connectionSet == ["N"] { return ("street_straight_LR", 90) }
        if connectionSet == ["S"] { return ("street_straight_LR", 90) }
        if connectionSet == ["W"] { return ("street_straight_LR", 0) }
        if connectionSet == ["E"] { return ("street_straight_LR", 0) }

        // Straight roads
        if connectionSet == ["N", "S"] { return ("street_straight_LR", 90) }
        if connectionSet == ["W", "E"] { return ("street_straight_LR", 0) }

        // Corners
        if connectionSet == ["N", "E"] { return ("street_corner_BR", 270) }
        if connectionSet == ["N", "W"] { return ("street_corner_BR", 180) }
        if connectionSet == ["S", "E"] { return ("street_corner_BR", 0) }
        if connectionSet == ["S", "W"] { return ("street_corner_BR", 90) }

        // T-Junctions
        if connectionSet == ["W", "N", "E"] { return ("street_t-junction_LRT", 0) }
        if connectionSet == ["N", "S", "E"] { return ("street_t-junction_LRT", 90) }
        if connectionSet == ["E", "S", "W"] { return ("street_t-junction_LRT", 180) }
        if connectionSet == ["W", "S", "N"] { return ("street_t-junction_LRT", 270) }

        // Crossroad
        if connectionSet == ["N", "S", "E", "W"] {
            return ("street_x-crossing", 0)
        }

        // Fallback (isolated road)
        return ("street_straight_LR", 0)
    }

    // MARK: - Handle Drops (only for moving tiles cell-to-cell)
    private func handleDrop(providers: [NSItemProvider], row: Int, column: Int) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadObject(ofClass: NSString.self) { object, _ in
            guard let idString = object as? String, let tileID = UUID(uuidString: idString) else { return }

            DispatchQueue.main.async {
                // If there's already a tile in this cell, move it back to the stack
                if let existingTile = grid[row][column] {
                    mediumFeedback()
                    stacks[existingTile.type]?.append(existingTile)
                }

                // 1) Try to find the dragged tile in the grid
                for r in 0..<grid.count {
                    for c in 0..<grid[r].count {
                        if grid[r][c]?.id == tileID {
                            grid[row][column] = grid[r][c]
                            grid[r][c] = nil
                            recalculateResources()
                            return
                        }
                    }
                }

                // 2) If not in the grid, it might be in the stack
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

    private func setupInitialCity() {
        // 1) Clear the current grid
        for row in 0..<Self.rows {
            for col in 0..<Self.columns {
                grid[row][col] = nil
            }
        }

        // 2) Place a vertical road (column 4, rows 0..6)
        for row in 0...4 {
            grid[row][4] = Tile(type: .streets)
        }

        // 3) Place a horizontal road (row 4, columns 2..4)
        for col in 0...3 {
            grid[4][col] = Tile(type: .streets)
        }

        // 4) Place 3 houses (connected to the horizontal road)
        grid[5][1] = Tile(type: .residential)
        grid[5][2] = Tile(type: .residential)
        grid[5][3] = Tile(type: .residential)

        // 5) Place 1 commercial tile
        grid[5][4] = Tile(type: .commercial)

        // 6) Place 1 industrial tile (somewhere near the corner)
        grid[1][5] = Tile(type: .industrial)

        // 7) Place 2 renewable energy (solar) tiles
        grid[6][CityKitView.columns - 1] = Tile(type: .renewableEnergy)
        grid[7][CityKitView.columns - 1] = Tile(type: .renewableEnergy)

        // 8) Recalculate after placing tiles
        recalculateResources()

        populationHistory.append((day: currentDay, inhabitants: 0))
        energyHistory.append((day: currentDay,
                             consumption: 0,
                             production: 0))
        moneyHistory.append((day: currentDay, swiftBucks: swiftBucks))

        nextDay()
    }
}

struct GridCellView: View {
    @Binding var tile: Tile?
    let tileSize: CGFloat
    let randomNum: Int

    // Called when user drags a tile out of this cell
    let onDragTile: (Tile) -> Void

    // Called when user taps on the cell (remove tile or place new tile)
    let onTapCell: () -> Void

    // Returns (assetName, rotationAngle) for street tiles
    let getStreetType: () -> (String, Double)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Base / ground
            Image("Back_\(randomNum)")
                .resizable()
                .scaledToFit()
                .frame(width: tileSize, height: tileSize)

            if let currentTile = tile {
                // If it’s a street tile, pick the correct texture
                if currentTile.type == .streets {
                    if let (streetAsset, rotationAngle) = getStreetType() {
                        Image(streetAsset)
                            .resizable()
                            .scaledToFit()
                            .frame(width: tileSize, height: tileSize)
                            .rotationEffect(.degrees(rotationAngle))
                            .onDrag {
                                NSItemProvider(object: currentTile.id.uuidString as NSString)
                            }
                    } else {
                        // Fallback
                        Image("street_straight_LR")
                            .resizable()
                            .scaledToFit()
                            .frame(width: tileSize, height: tileSize)
                            .onDrag {
                                NSItemProvider(object: currentTile.id.uuidString as NSString)
                            }
                    }
                } else {
                    // Non-street tile
                    TileView(tile: currentTile, size: tileSize)
                        .onDrag {
                            NSItemProvider(object: currentTile.id.uuidString as NSString)
                        }
                }

            }
        }
        .onTapGesture {
            onTapCell()
        }
    }
}

struct TileView: View {
    @ObservedObject var tile: Tile
    let size: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(tile.type.color)
                .frame(width: size, height: size)

            if tile.type == .streets {
                Image("street_straight_LR")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tile.type == .residential {
                Image("Hou_\(tile.randomVariant)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tile.type == .commercial {
                Image("Com_\(tile.randomVariant)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tile.type == .industrial {
                Image("Ind_\(tile.randomVariant)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tile.type == .renewableEnergy {
                Image("Ren_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tile.type == .nonRenewableEnergy {
                Image("Con_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            }else {
                Image(systemName: tile.type.iconName)
                    .foregroundColor(.white)
                    .font(.system(size: size * 0.5))
            }

            if tile.type.needsStreetConnection && !tile.connected {
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .blendMode(.multiply)
                    .frame(width: size, height: size)

                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                    .frame(width: size, height: size)
            }
        }
    }
}

struct TileViewForType: View {
    var tileType: TileType
    let size: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(tileType.color)
                .frame(width: size, height: size)

            if tileType == .streets {
                Image("street_straight_LR")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tileType == .residential {
                Image("Hou_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tileType == .commercial {
                Image("Com_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tileType == .industrial {
                Image("Ind_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tileType == .renewableEnergy {
                Image("Ren_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if tileType == .nonRenewableEnergy {
                Image("Con_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            }else {
                Image(systemName: tileType.iconName)
                    .foregroundColor(.white)
                    .font(.system(size: size * 0.5))
                    .frame(width: size, height: size)
            }
        }
        .frame(width: size, height: size)
        .addBorder(.clear, cornerRadius: 5)
    }
}

// MARK: - Tile Model
class Tile: Identifiable, ObservableObject {
    let id = UUID()
    let type: TileType

    let randomVariant: Int

    @Published var needsEnergy: Int
    @Published var producesEnergy: Int
    @Published var connected: Bool = false

    init(type: TileType) {
        self.type = type
        self.needsEnergy = type.needsEnergy
        self.producesEnergy = type.producesEnergy

        self.randomVariant = Int.random(in: 1...4)
    }
}

enum TileType: String, CaseIterable {
    case residential
    case commercial
    case industrial
    case streets
    case parks
    case renewableEnergy
    case nonRenewableEnergy

    var iconName: String {
        switch self {
        case .residential:          return "house.fill"
        case .commercial:           return "bag.fill"
        case .industrial:           return "gearshape.fill"
        case .streets:              return "road.lanes"
        case .parks:                return "leaf.fill"
        case .renewableEnergy:      return "sun.max.fill"
        case .nonRenewableEnergy:   return "flame.fill"
        }
    }

    var color: Color {
        switch self {
        case .residential:          return .green
        case .commercial:           return .blue
        case .industrial:           return .yellow
        case .streets:              return .gray
        case .parks:                return .green
        case .renewableEnergy:      return .cyan
        case .nonRenewableEnergy:   return .black
        }
    }

    var needsEnergy: Int {
        switch self {
        case .residential:          return 5
        case .commercial:           return 8
        case .industrial:           return 15
        default:                    return 0
        }
    }

    var producesEnergy: Int {
        switch self {
        case .renewableEnergy:      return 20
        case .nonRenewableEnergy:   return 100
        default:                    return 0
        }
    }

    var needsStreetConnection: Bool {
        switch self {
        case .residential, .commercial, .industrial, .nonRenewableEnergy:
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
