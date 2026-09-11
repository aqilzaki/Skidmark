//
//  SpriteHelper.swift
//  aqil.game
//
//  Created by muhammad aqil zaki on 02/09/26.
//

import SwiftUI
import SpriteKit

class SpriteHelper{

    static func addNode(name:String,width:Double,height:Double,x:CGFloat,y:CGFloat,scene:SKScene?,zPosition:Int = 0, onComplete:@escaping (SKSpriteNode)->Void){
        let node = SKSpriteNode(imageNamed: name)
        node.size = CGSize(width: width, height: height)
        node.position = CGPoint(x: x, y: y)
        node.name = name
        scene?.addChild(node)
        onComplete(node)
    }

    static func addPhysics(node: SKSpriteNode,effectedByGravity:Bool = true,dynamic:Bool = true){
        let n = node
        n.physicsBody = SKPhysicsBody(rectangleOf: n.size)
        n.physicsBody?.affectedByGravity = effectedByGravity
        n.physicsBody?.isDynamic = dynamic
        n.physicsBody?.contactTestBitMask = n.physicsBody?.collisionBitMask ?? 0
    }

    static func makeTextureAnimation(name:String, range: ClosedRange<Int>,node: SKSpriteNode,duration:TimeInterval){
        let n = node
        let textures = (1...3).map {
            SKTexture(imageNamed: "\(name)\($0)")
        }
        let animation = SKAction.animate(with: textures, timePerFrame: duration)
        let animationRepeat = SKAction.repeatForever(animation)
        n.run(animationRepeat)
    }

    static func removeAction(node: SKSpriteNode,onSuccess: @escaping ()->Void){
        let remove = SKAction.removeFromParent()
        node.run(remove){
            onSuccess()
        }
    }

    static func spawnedRepeatedly(scene:SKScene?,run:@escaping ()->Void,duration:TimeInterval){
        let spawnAction = SKAction.run {
            run()
        }
        let waitAction = SKAction.wait(forDuration: duration)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        scene?.run(SKAction.repeatForever(spawnAndWaitAction))
    }

    static func handleContact(contact: SKPhysicsContact,item1:SKSpriteNode,item2:SKSpriteNode, onContact:@escaping (SKNode,SKNode)->Void){
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == item1.name && nodeB.name == item2.name {
            onContact(nodeA,nodeB)
        }
    }

    static func moveVertical(node: SKSpriteNode,moveTo:CGFloat,duration:TimeInterval,onSuccess: @escaping () -> Void? = doNothing){
        let moveDown = SKAction.moveTo(y: moveTo, duration: duration)
        node.run(moveDown) {
            onSuccess()
        }
    }

    static func moveVerticalAndRemove(node: SKSpriteNode,moveTo:CGFloat,duration:TimeInterval,onSuccess: @escaping () -> Void){
        let moveDown = SKAction.moveTo(y: moveTo, duration: duration)
        let removeAction = SKAction.removeFromParent()
        let moveDownAndRemoveConeSequence = SKAction.sequence([moveDown, removeAction])
        node.run(moveDownAndRemoveConeSequence) {
            onSuccess()
        }
    }

    static func moveHorizontal(node: SKSpriteNode,moveTo:CGFloat,duration:TimeInterval,onSuccess: @escaping () -> Void? = doNothing){
        let moveDown = SKAction.moveTo(x: moveTo, duration: duration)
        node.run(moveDown) {
            onSuccess()
        }
    }

    static func moveHorizontalAndRemove(node: SKSpriteNode,moveTo:CGFloat,duration:TimeInterval,onSuccess: @escaping ()->Void){
        let moveDown = SKAction.moveTo(x: moveTo, duration: duration)
        let removeAction = SKAction.removeFromParent()
        let moveDownAndRemoveConeSequence = SKAction.sequence([moveDown, removeAction])
        node.run(moveDownAndRemoveConeSequence) {
            onSuccess()
        }
    }

    static func handleTap(touches: Set<UITouch>, with event: UIEvent?,scene:SKScene?,node:SKSpriteNode,onTap:@escaping ()->Void){
        for t in touches {
            let location = t.location(in: scene!)
            let touchedNodes = scene?.nodes(at: location) // Array of all nodes at the point

            for n in touchedNodes! { // Iterate through all nodes in the touchedNode array
                if n == node {
                    onTap()
                }
            }
        }
    }

    static func getTouchLocation(touches: Set<UITouch>,scene:SKScene?,onAction:@escaping (CGPoint)->Void){
        for t in touches {
            let location = t.location(in: scene!)
            onAction(location)
        }
    }

    nonisolated static func doNothing() -> Void { }

}
