//
//  PlayerMoveComponent.swift
//  Ski
//
//  Created by Ralf Tappmeyer on 5/7/16.
//  Copyright © 2016 Ralf Tappmeyer. All rights reserved.
//

import SpriteKit
import GameplayKit

class MoveComponent: GKComponent {
    // MARK: Properties
    
    var movement = CGPoint.zero
    var pushButton = false
    var downhillMovementSpeed = (playerSettings.downhillSpeedMin / 100)
    var lastYposition: CGFloat = 0
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self) else {
            fatalError("A MoveComponent's entity must have a RenderComponent")
        }
        return renderComponent
    }
    
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else {
            fatalError("A MovementComponent's entity must have an AnimationComponent")
        }
        return animationComponent
    }


    // MARK: GKComponent Life Cycle

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let playerEntity = (entity as! PlayerEntity)

        // Don't update if player is crashed
        if playerEntity.isCrashed { return }
        
        // Adjust downhill speed based on Push Button state
        if pushButton {
            if downhillMovementSpeed < (playerSettings.downhillSpeedMax / 100) {
                downhillMovementSpeed += 0.01
            }
        } else {
            if downhillMovementSpeed > (playerSettings.downhillSpeedMin / 100) {
                downhillMovementSpeed -= 0.1
            }
        }
        
        // Update player position
        let xMovement = ((movement.x * CGFloat(seconds)) * playerSettings.movementSpeed)
        let yMovement = (((downhillMovementSpeed * -1) * CGFloat(seconds)) * playerSettings.movementSpeed)
        
        renderComponent.node.position = CGPoint(x: renderComponent.node.position.x + xMovement, y: renderComponent.node.position.y + yMovement)
        
        // Update player animation
        if movement.x < -0.1 {
            animationComponent.requestedAnimationState = .left
        } else if movement.x > 0.1 {
            animationComponent.requestedAnimationState = .right
        } else {
            animationComponent.requestedAnimationState = .idle
        }
        
        movement = CGPoint.zero
        
    }
    
}
