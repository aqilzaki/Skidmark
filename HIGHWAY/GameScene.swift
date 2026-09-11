//
//  HouseType.swift
//  aqil.game
//
//  Created by muhammad aqil zaki on 02/09/26.
//

import SpriteKit
import UIKit

// MARK: - Node Mobil Player dengan Bumper Duri & Shield Visual
class PlayerCar: SKSpriteNode {
    var baseNormalSpeed: CGFloat = 260.0
    var nitroSpeed: CGFloat = 440.0
    var turnRate: CGFloat = 4.2
    
    // Status Upgrade
    var level: Int = 1
    var hasShield: Bool = false {
        didSet { shieldAuraNode?.isHidden = !hasShield }
    }
    var isSuperWhipActive: Bool = false
    
    // Komponen Visual
    private var shieldAuraNode: SKShapeNode?
    var spikedBumperNode: SKShapeNode!
    
    init() {
        let size = CGSize(width: 22, height: 44)
        super.init(texture: nil, color: .systemYellow, size: size)
        self.name = "player"
        self.zPosition = 10
        
        // Kaca mobil
        let windshield = SKSpriteNode(color: .black, size: CGSize(width: 16, height: 10))
        windshield.position = CGPoint(x: 0, y: 7); windshield.zPosition = 11; addChild(windshield)
        
        // Roda
        let wheelSize = CGSize(width: 4, height: 9)
        let wFL = SKSpriteNode(color: .darkGray, size: wheelSize); wFL.position = CGPoint(x: -12, y: 13); addChild(wFL)
        let wFR = SKSpriteNode(color: .darkGray, size: wheelSize); wFR.position = CGPoint(x: 12, y: 13); addChild(wFR)
        let wBL = SKSpriteNode(color: .darkGray, size: wheelSize); wBL.position = CGPoint(x: -12, y: -13); addChild(wBL)
        let wBR = SKSpriteNode(color: .darkGray, size: wheelSize); wBR.position = CGPoint(x: 12, y: -13); addChild(wBR)
        
        setupTailWhipBumper()
        setupShieldAura()
    }
    
    // VISUAL DURI / BUMPER PANTAT MOBIL (SANGAT TERLIHAT)
    private func setupTailWhipBumper() {
        let path = CGMutablePath()
        // Busur duri di belakang roda belakang
        path.move(to: CGPoint(x: -14, y: -18))
        path.addLine(to: CGPoint(x: -18, y: -26))
        path.addLine(to: CGPoint(x: -10, y: -22))
        path.addLine(to: CGPoint(x: 0, y: -28)) // Duri tengah tajam
        path.addLine(to: CGPoint(x: 10, y: -22))
        path.addLine(to: CGPoint(x: 18, y: -26))
        path.addLine(to: CGPoint(x: 14, y: -18))
        path.closeSubpath()
        
        spikedBumperNode = SKShapeNode(path: path)
        spikedBumperNode.fillColor = .systemCyan
        spikedBumperNode.strokeColor = .white
        spikedBumperNode.lineWidth = 1.5
        spikedBumperNode.zPosition = 12
        addChild(spikedBumperNode)
    }
    
    private func setupShieldAura() {
        let aura = SKShapeNode(circleOfRadius: 28)
        aura.fillColor = SKColor.cyan.withAlphaComponent(0.25)
        aura.strokeColor = .cyan
        aura.lineWidth = 2.0
        aura.zPosition = 14
        aura.isHidden = true
        addChild(aura)
        self.shieldAuraNode = aura
        
        let pulse = SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.3),
            SKAction.scale(to: 1.0, duration: 0.3)
        ]))
        aura.run(pulse)
    }
    
    // Efek saat Drift: Bumper Duri Menyala Terang
    func setTailWhipGlow(isDrifting: Bool) {
        if isDrifting || isSuperWhipActive {
            spikedBumperNode.fillColor = isSuperWhipActive ? .systemPurple : .systemCyan
            spikedBumperNode.strokeColor = .yellow
            spikedBumperNode.setScale(isSuperWhipActive ? 1.4 : 1.15)
        } else {
            spikedBumperNode.fillColor = SKColor.darkGray
            spikedBumperNode.strokeColor = .white
            spikedBumperNode.setScale(1.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

// MARK: - Node Mobil Polisi
class PoliceCar: SKSpriteNode {
    var baseSpeed: CGFloat = 295.0
    var driveSpeed: CGFloat = 295.0
    var turnSpeed: CGFloat = 2.4
    
    init() {
        let size = CGSize(width: 24, height: 46)
        super.init(texture: nil, color: .white, size: size)
        self.name = "police"
        self.zPosition = 9
        
        let hood = SKSpriteNode(color: .black, size: CGSize(width: 24, height: 14))
        hood.position = CGPoint(x: 0, y: 13); addChild(hood)
        
        let lightBar = SKSpriteNode(color: .red, size: CGSize(width: 14, height: 6))
        lightBar.position = CGPoint(x: 0, y: -2); lightBar.zPosition = 12; addChild(lightBar)
        
        let siren = SKAction.repeatForever(SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.1),
            SKAction.colorize(with: .blue, colorBlendFactor: 1.0, duration: 0.1)
        ]))
        lightBar.run(siren)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

// MARK: - Node Item Tail-Whip Power-up (W)
class WhipPowerItem: SKSpriteNode {
    init() {
        let size = CGSize(width: 26, height: 26)
        super.init(texture: nil, color: .systemCyan, size: size)
        self.name = "whip_item"
        self.zPosition = 5
        
        let label = SKLabelNode(text: "W")
        label.fontName = "HelveticaNeue-Black"
        label.fontSize = 15
        label.fontColor = .black
        label.verticalAlignmentMode = .center
        addChild(label)
        
        let spin = SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 0.8))
        run(spin)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

// MARK: - Jerigen Bensin (G)
class FuelItem: SKSpriteNode {
    init() {
        let size = CGSize(width: 22, height: 28)
        super.init(texture: nil, color: .systemRed, size: size)
        self.name = "fuel"
        self.zPosition = 5
        
        let label = SKLabelNode(text: "G")
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 13
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        addChild(label)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

// MARK: - GameScene Utama
class GameScene: SKScene {
    
    private var isGameOver: Bool = false
    private var survivalTime: TimeInterval = 0.0
    private var totalCash: Int = 0 {
        didSet { cashLabel.text = "$\(totalCash)" }
    }
    
    private var fuelLevel: CGFloat = 1.0
    private var baseFuelBurn: CGFloat = 0.048
    
    // Inersia & Fisika
    private var playerVelocity: CGVector = .zero
    private var isSteeringLeft: Bool = false
    private var isSteeringRight: Bool = false
    private var isNitroActive: Bool = false
    private var driftHapticTimer: TimeInterval = 0
    private var superWhipDuration: TimeInterval = 0
    
    // Nodes
    private var player: PlayerCar!
    private var cameraNode: SKCameraNode!
    private var worldNode: SKNode!
    private var policeList: [PoliceCar] = []
    private var fuelItems: [FuelItem] = []
    private var whipItems: [WhipPowerItem] = []
    
    // HUD
    private let timeLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    private let cashLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    private let levelBadge = SKLabelNode(fontNamed: "HelveticaNeue-BlackCondensed")
    private let fuelBarFill = SKSpriteNode(color: .systemGreen, size: CGSize(width: 136, height: 12))
    private let gameOverLabel = SKLabelNode(fontNamed: "HelveticaNeue-BlackCondensed")
    
    // Timers
    private var lastUpdateTime: TimeInterval = 0
    private var lastPoliceSpawnTime: TimeInterval = 0
    private var lastFuelSpawnTime: TimeInterval = 0
    private var lastWhipSpawnTime: TimeInterval = 0
    
    // Haptics
    private let lightHaptic = UIImpactFeedbackGenerator(style: .light)
    private let heavyHaptic = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationHaptic = UINotificationFeedbackGenerator()
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(white: 0.14, alpha: 1.0)
        view.isMultipleTouchEnabled = true
        
        lightHaptic.prepare()
        heavyHaptic.prepare()
        notificationHaptic.prepare()
        
        setupWorld()
        setupPlayer()
        setupHUD()
        
        for _ in 0..<3 { spawnFuel(nearPlayer: true) }
        spawnWhipItem(nearPlayer: true)
    }
    
    private func setupWorld() {
        worldNode = SKNode()
        addChild(worldNode)
        
        let gridSize: CGFloat = 140.0
        for x in -15...15 {
            for y in -20...20 {
                let dot = SKShapeNode(rectOf: CGSize(width: 4, height: 20))
                dot.fillColor = SKColor(white: 0.25, alpha: 1.0)
                dot.strokeColor = .clear
                dot.position = CGPoint(x: CGFloat(x) * gridSize, y: CGFloat(y) * gridSize)
                dot.zPosition = 1
                worldNode.addChild(dot)
            }
        }
    }
    
    private func setupPlayer() {
        player = PlayerCar()
        player.position = .zero
        worldNode.addChild(player)
    }
    
    private func setupHUD() {
        cameraNode = SKCameraNode()
        addChild(cameraNode)
        self.camera = cameraNode
        
        timeLabel.text = "0.0s"
        timeLabel.fontSize = 28
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: -85, y: size.height / 2 - 65)
        timeLabel.zPosition = 100
        cameraNode.addChild(timeLabel)
        
        cashLabel.text = "$0"
        cashLabel.fontSize = 28
        cashLabel.fontColor = .systemYellow
        cashLabel.position = CGPoint(x: 85, y: size.height / 2 - 65)
        cashLabel.zPosition = 100
        cameraNode.addChild(cashLabel)
        
        // Badge Level Mobil
        levelBadge.text = "LV.1 STOCK CAR"
        levelBadge.fontSize = 12
        levelBadge.fontColor = .cyan
        levelBadge.position = CGPoint(x: 0, y: size.height / 2 - 82)
        levelBadge.zPosition = 100
        cameraNode.addChild(levelBadge)
        
        let fuelBg = SKShapeNode(rectOf: CGSize(width: 140, height: 16), cornerRadius: 4)
        fuelBg.fillColor = SKColor(white: 0.1, alpha: 0.8)
        fuelBg.strokeColor = .white
        fuelBg.position = CGPoint(x: 0, y: size.height / 2 - 105)
        fuelBg.zPosition = 100
        cameraNode.addChild(fuelBg)
        
        fuelBarFill.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        fuelBarFill.position = CGPoint(x: -68, y: size.height / 2 - 105)
        fuelBarFill.zPosition = 101
        cameraNode.addChild(fuelBarFill)
        
        gameOverLabel.text = "BUSTED!\nTAP UNTUK ULANG"
        gameOverLabel.numberOfLines = 2
        gameOverLabel.fontSize = 26
        gameOverLabel.fontColor = .systemRed
        gameOverLabel.position = .zero
        gameOverLabel.zPosition = 150
        gameOverLabel.isHidden = true
        cameraNode.addChild(gameOverLabel)
    }
    
    // MARK: - Input Multi-Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver { resetGame(); return }
        updateTouchState(event: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { updateTouchState(event: event) }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { updateTouchState(event: event) }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { updateTouchState(event: event) }
    
    private func updateTouchState(event: UIEvent?) {
        guard let allTouches = event?.allTouches, !isGameOver else {
            isSteeringLeft = false; isSteeringRight = false; isNitroActive = false
            return
        }
        
        var leftCount = 0; var rightCount = 0
        let screenWidth = view?.bounds.width ?? size.width
        
        for touch in allTouches where touch.phase == .began || touch.phase == .moved || touch.phase == .stationary {
            if touch.location(in: view).x < screenWidth / 2 { leftCount += 1 } else { rightCount += 1 }
        }
        
        if leftCount > 0 && rightCount > 0 {
            isNitroActive = true; isSteeringLeft = false; isSteeringRight = false
        } else {
            isNitroActive = false
            isSteeringLeft = (leftCount > 0)
            isSteeringRight = (rightCount > 0)
        }
    }
    
    // MARK: - Spawner Item & Polisi
    private func spawnFuel(nearPlayer: Bool = false) {
        let fuel = FuelItem()
        let r: CGFloat = nearPlayer ? .random(in: 180...350) : .random(in: 350...700)
        let a = CGFloat.random(in: 0...(2 * .pi))
        fuel.position = CGPoint(x: player.position.x + cos(a)*r, y: player.position.y + sin(a)*r)
        worldNode.addChild(fuel)
        fuelItems.append(fuel)
    }
    
    private func spawnWhipItem(nearPlayer: Bool = false) {
        guard whipItems.count < 2 else { return }
        let whip = WhipPowerItem()
        let r: CGFloat = nearPlayer ? .random(in: 200...400) : .random(in: 400...800)
        let a = CGFloat.random(in: 0...(2 * .pi))
        whip.position = CGPoint(x: player.position.x + cos(a)*r, y: player.position.y + sin(a)*r)
        worldNode.addChild(whip)
        whipItems.append(whip)
    }
    
    private func spawnPolice() {
        guard policeList.count < min(7, 2 + Int(survivalTime / 10.0)) else { return }
        let cop = PoliceCar()
        let a = CGFloat.random(in: 0...(2 * .pi))
        cop.position = CGPoint(x: player.position.x + cos(a)*580, y: player.position.y + sin(a)*580)
        cop.zRotation = a + .pi
        worldNode.addChild(cop)
        policeList.append(cop)
    }
    
    // MARK: - Progresi Upgrade Mobil Otomatis
    private func checkCarProgression() {
        // Level 2: Di detik ke-18 atau tembus $150 -> Buka ARMOR SHIELD
        if (survivalTime > 18.0 || totalCash >= 150) && player.level < 2 {
            player.level = 2
            player.hasShield = true
            levelBadge.text = "LV.2 ARMOR SHIELD AKTIF"
            levelBadge.fontColor = .systemCyan
            showFeedback(at: player.position, text: "UPGRADE: SHIELD AKTIF!", color: .cyan)
            notificationHaptic.notificationOccurred(.success)
        }
        
        // Level 3: Di detik ke-38 atau tembus $350 -> HYPER TAIL-WHIP
        if (survivalTime > 38.0 || totalCash >= 350) && player.level < 3 {
            player.level = 3
            player.isSuperWhipActive = true
            levelBadge.text = "LV.3 HYPER TAIL-WHIP"
            levelBadge.fontColor = .systemPurple
            showFeedback(at: player.position, text: "UPGRADE: HYPER TAIL-WHIP!", color: .systemPurple)
            notificationHaptic.notificationOccurred(.success)
        }
        
        // Level 4: Di detik ke-60 -> BEAST ENGINE (Bensin Awet)
        if (survivalTime > 60.0 || totalCash >= 600) && player.level < 4 {
            player.level = 4
            baseFuelBurn = 0.035 // 30% lebih hemat
            levelBadge.text = "LV.4 BEAST ENGINE (MAX)"
            levelBadge.fontColor = .systemYellow
            showFeedback(at: player.position, text: "MAX UPGRADE: BEAST ENGINE!", color: .systemYellow)
            notificationHaptic.notificationOccurred(.success)
        }
    }
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = CGFloat(min(currentTime - lastUpdateTime, 0.1))
        lastUpdateTime = currentTime
        
        survivalTime += TimeInterval(dt)
        timeLabel.text = String(format: "%.1fs", survivalTime)
        
        checkCarProgression()
        
        // Timer Super Whip Power-Up
        if superWhipDuration > 0 {
            superWhipDuration -= TimeInterval(dt)
            if superWhipDuration <= 0 && player.level < 3 {
                player.isSuperWhipActive = false
            }
        }
        
        let speedMult = 1.0 + CGFloat(survivalTime) * 0.025
        let isDrifting = (isSteeringLeft || isSteeringRight) && !isNitroActive
        
        // Perbarui Visual Nyala Bumper Belakang
        player.setTailWhipGlow(isDrifting: isDrifting)
        
        // Kemudi
        if isSteeringLeft { player.zRotation += player.turnRate * 1.35 * dt }
        else if isSteeringRight { player.zRotation -= player.turnRate * 1.35 * dt }
        
        let fX = -sin(player.zRotation)
        let fY = cos(player.zRotation)
        
        var targetSpeed = player.baseNormalSpeed * speedMult
        if isNitroActive {
            targetSpeed = player.nitroSpeed * speedMult
            spawnNitroFire()
        } else if isDrifting {
            targetSpeed *= 0.82
        }
        
        let grip: CGFloat = isNitroActive ? 12.0 : (isDrifting ? 2.6 : 9.5)
        playerVelocity.dx += (fX * targetSpeed - playerVelocity.dx) * min(grip * dt, 1.0)
        playerVelocity.dy += (fY * targetSpeed - playerVelocity.dy) * min(grip * dt, 1.0)
        
        player.position.x += playerVelocity.dx * dt
        player.position.y += playerVelocity.dy * dt
        cameraNode.position = player.position
        
        if isDrifting {
            spawnDriftTracks()
            driftHapticTimer += TimeInterval(dt)
            if driftHapticTimer > 0.08 {
                lightHaptic.impactOccurred(intensity: 0.45)
                driftHapticTimer = 0
            }
        }
        
        // Bensin
        let burnRate = isNitroActive ? (baseFuelBurn * 3.0) : baseFuelBurn
        fuelLevel -= burnRate * dt
        updateFuelGauge()
        if fuelLevel <= 0 { triggerGameOver(reason: "BENSIN HABIS!"); return }
        
        updatePolice(dt: dt, speedMult: speedMult)
        checkCollisions(isDrifting: isDrifting)
        
        // Spawner
        if currentTime - lastPoliceSpawnTime > 4.2 { spawnPolice(); lastPoliceSpawnTime = currentTime }
        if currentTime - lastFuelSpawnTime > 3.5 { if fuelItems.count < 5 { spawnFuel() }; lastFuelSpawnTime = currentTime }
        if currentTime - lastWhipSpawnTime > 12.0 { spawnWhipItem(); lastWhipSpawnTime = currentTime }
    }
    
    private func updatePolice(dt: CGFloat, speedMult: CGFloat) {
        for cop in policeList {
            cop.driveSpeed = cop.baseSpeed * (speedMult * 1.1)
            let dx = player.position.x - cop.position.x
            let dy = player.position.y - cop.position.y
            let targetAngle = atan2(dy, dx) - .pi / 2
            
            var diff = targetAngle - cop.zRotation
            while diff > .pi { diff -= 2 * .pi }
            while diff < -.pi { diff += 2 * .pi }
            cop.zRotation += diff * cop.turnSpeed * dt
            
            cop.position.x += -sin(cop.zRotation) * cop.driveSpeed * dt
            cop.position.y += cos(cop.zRotation) * cop.driveSpeed * dt
        }
    }
    
    // MARK: - Tabrakan & Logika Hantam Tail-Whip yang Jelas
    private func checkCollisions(isDrifting: Bool) {
        // 1. Ambil Bensin
        fuelItems.removeAll { fuel in
            if hypot(player.position.x - fuel.position.x, player.position.y - fuel.position.y) < 32 {
                fuelLevel = min(1.0, fuelLevel + 0.35)
                showFeedback(at: fuel.position, text: "+FUEL!", color: .systemYellow)
                fuel.removeFromParent()
                return true
            }
            return false
        }
        
        // 2. Ambil Power-Up Whip [W]
        whipItems.removeAll { item in
            if hypot(player.position.x - item.position.x, player.position.y - item.position.y) < 32 {
                player.isSuperWhipActive = true
                superWhipDuration = 10.0 // 10 Detik Super Whip
                showFeedback(at: player.position, text: "TAIL-WHIP OVERCHARGE!", color: .cyan)
                notificationHaptic.notificationOccurred(.success)
                item.removeFromParent()
                return true
            }
            return false
        }
        
        // 3. Tabrakan dengan Polisi
        let whipHitRadius: CGFloat = player.isSuperWhipActive ? 46.0 : 34.0
        
        for (index, cop) in policeList.enumerated().reversed() {
            let dist = hypot(player.position.x - cop.position.x, player.position.y - cop.position.y)
            if dist < whipHitRadius {
                
                // A. JIKA SEDANG NITRO -> TABRAK HANCUR
                if isNitroActive {
                    showExplosion(at: cop.position)
                    heavyHaptic.impactOccurred(intensity: 1.0)
                    totalCash += 60
                    showFeedback(at: cop.position, text: "NITRO SMASH! +$60", color: .systemOrange)
                    cop.removeFromParent(); policeList.remove(at: index)
                    continue
                }
                
                // B. CEK APAKAH MENGENAI BUMPER DURI BELAKANG (TAIL-WHIP)
                let forwardX = -sin(player.zRotation)
                let forwardY = cos(player.zRotation)
                let toCopX = cop.position.x - player.position.x
                let toCopY = cop.position.y - player.position.y
                let dotProduct = forwardX * toCopX + forwardY * toCopY
                
                // Jika polisi berada di belakang/samping (dotProduct <= 10) saat drift / saat whip aktif
                if (isDrifting || player.isSuperWhipActive) && dotProduct <= 12.0 {
                    // TAIL WHIP HIT!
                    showExplosion(at: cop.position)
                    heavyHaptic.impactOccurred(intensity: 1.0)
                    
                    let reward = player.isSuperWhipActive ? 100 : 50
                    totalCash += reward
                    showFeedback(at: cop.position, text: "TAIL-WHIP SMASH! +$\(reward)", color: .systemGreen)
                    
                    // Efek Kilat Layar Singkat (Visual Juice)
                    flashScreen()
                    
                    cop.removeFromParent(); policeList.remove(at: index)
                } else {
                    // TABRAKAN MONCONG DEPAN
                    if player.hasShield {
                        // SHIELD MENYELAMATKAN 1 KALI!
                        player.hasShield = false
                        heavyHaptic.impactOccurred(intensity: 1.0)
                        showExplosion(at: player.position)
                        showFeedback(at: player.position, text: "SHIELD HANCUR!", color: .systemRed)
                        
                        // Pantulkan polisi agar menjauh
                        cop.position.x -= forwardX * 60
                        cop.position.y -= forwardY * 60
                    } else {
                        triggerGameOver(reason: "TABRAKAN MONCONG DEPAN!")
                        return
                    }
                }
            }
        }
        
        // Polisi Saling Tabrak
        if policeList.count > 1 {
            for i in 0..<policeList.count {
                for j in (i + 1)..<policeList.count {
                    let c1 = policeList[i]; let c2 = policeList[j]
                    if hypot(c1.position.x - c2.position.x, c1.position.y - c2.position.y) < 30 {
                        showExplosion(at: c1.position)
                        c1.removeFromParent(); c2.removeFromParent()
                        policeList.removeAll { $0 == c1 || $0 == c2 }
                        return
                    }
                }
            }
        }
    }
    
    // MARK: - Visual & Juice
    private func flashScreen() {
        let flash = SKShapeNode(rectOf: CGSize(width: size.width * 2, height: size.height * 2))
        flash.fillColor = .white
        flash.alpha = 0.35
        flash.zPosition = 90
        flash.position = player.position
        worldNode.addChild(flash)
        flash.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.removeFromParent()]))
    }
    
    private func spawnNitroFire() {
        let fire = SKShapeNode(circleOfRadius: .random(in: 3...6))
        fire.fillColor = .orange
        fire.strokeColor = .yellow
        fire.position = CGPoint(
            x: player.position.x + sin(player.zRotation) * 20,
            y: player.position.y - cos(player.zRotation) * 20
        )
        fire.zPosition = 4
        worldNode.addChild(fire)
        fire.run(SKAction.sequence([SKAction.scale(to: 0.1, duration: 0.2), SKAction.removeFromParent()]))
    }
    
    private func spawnDriftTracks() {
        let a = player.zRotation
        let cosA = cos(a); let sinA = sin(a)
        let offsets = [CGPoint(x: -11*cosA + 14*sinA, y: -11*sinA - 14*cosA),
                       CGPoint(x: 11*cosA + 14*sinA, y: 11*sinA - 14*cosA)]
        for o in offsets {
            let mark = SKShapeNode(circleOfRadius: 2.2)
            mark.fillColor = SKColor(white: 0.08, alpha: 0.5)
            mark.strokeColor = .clear
            mark.position = CGPoint(x: player.position.x + o.x, y: player.position.y + o.y)
            mark.zPosition = 2
            worldNode.addChild(mark)
            mark.run(SKAction.sequence([SKAction.wait(forDuration: 1.2), SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
        }
    }
    
    private func showExplosion(at pos: CGPoint) {
        let blast = SKShapeNode(circleOfRadius: 32)
        blast.fillColor = .orange
        blast.strokeColor = .yellow
        blast.position = pos
        blast.zPosition = 25
        worldNode.addChild(blast)
        blast.run(SKAction.sequence([SKAction.scale(to: 2.0, duration: 0.2), SKAction.fadeOut(withDuration: 0.2), SKAction.removeFromParent()]))
    }
    
    private func showFeedback(at pos: CGPoint, text: String, color: SKColor) {
        let label = SKLabelNode(text: text)
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 15
        label.fontColor = color
        label.position = pos
        label.zPosition = 80
        worldNode.addChild(label)
        label.run(SKAction.sequence([SKAction.moveBy(x: 0, y: 35, duration: 0.5), SKAction.removeFromParent()]))
    }
    
    private func updateFuelGauge() {
        let safe = max(0.0, fuelLevel)
        fuelBarFill.size.width = 136.0 * safe
        fuelBarFill.color = safe < 0.25 ? .systemRed : (safe < 0.55 ? .systemOrange : .systemGreen)
    }
    
    private func triggerGameOver(reason: String) {
        isGameOver = true
        heavyHaptic.impactOccurred(intensity: 1.0)
        
        let shake = SKAction.sequence([
            SKAction.moveBy(x: -14, y: 8, duration: 0.04),
            SKAction.moveBy(x: 24, y: -16, duration: 0.04),
            SKAction.moveBy(x: -14, y: 8, duration: 0.04)
        ])
        cameraNode.run(shake)
        
        gameOverLabel.text = "\(reason)\nBERTAHAN: \(String(format: "%.1fs", survivalTime))\nUANG: $\(totalCash)\nTAP UNTUK ULANG"
        gameOverLabel.isHidden = false
    }
    
    private func resetGame() {
        isGameOver = false
        survivalTime = 0.0
        totalCash = 0
        fuelLevel = 1.0
        baseFuelBurn = 0.048
        playerVelocity = .zero
        lastUpdateTime = 0
        gameOverLabel.isHidden = true
        
        player.level = 1
        player.hasShield = false
        player.isSuperWhipActive = false
        levelBadge.text = "LV.1 STOCK CAR"
        levelBadge.fontColor = .cyan
        
        policeList.forEach { $0.removeFromParent() }; policeList.removeAll()
        fuelItems.forEach { $0.removeFromParent() }; fuelItems.removeAll()
        whipItems.forEach { $0.removeFromParent() }; whipItems.removeAll()
        
        player.position = .zero
        player.zRotation = 0
        
        for _ in 0..<3 { spawnFuel(nearPlayer: true) }
        spawnWhipItem(nearPlayer: true)
    }
}
