//
//  GameScene.swift
//  SnakeChaseBlock
//
//  Created by Reem Naqvi on 3/12/19.
//  Copyright © 2019 DePaul University. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //1
    var gameLabel: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    
    var currentScore: SKLabelNode!
    var playerPositions: [(Int, Int)] = []
    var gameBG: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    
    var scorePos: CGPoint?
    var scorePos1: CGPoint?
    
    var game: GameManage!
    
    override func didMove(to view: SKView){
        //2
        initializeMenu()
        game = GameManage(scene: self)
        initializeGameView()
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    //2
    @objc func swipeR() {
        game.swipe(ID: 3)
    }
    @objc func swipeL() {
        game.swipe(ID: 1)
    }
    @objc func swipeU() {
        game.swipe(ID: 2)
    }
    @objc func swipeD() {
        game.swipe(ID: 4)
    }
    
    override func update(_ currentTime: TimeInterval){
        //Called before each fram is rendered
        game.update(time: currentTime)
        
    }
    
    //3
    private func initializeGameView() {
        //4
        currentScore = SKLabelNode(fontNamed: "AmericanTypewriter")
        currentScore.zPosition = 1
        currentScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        currentScore.fontSize = 40
        currentScore.isHidden = true
        currentScore.text = "Score: 0"
        currentScore.fontColor = SKColor.brown
        self.addChild(currentScore)
        //5
        let width = frame.size.width - 200
        let height = frame.size.height - 200
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBG = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBG.fillColor = SKColor.gray
        gameBG.zPosition = 2
        gameBG.isHidden = true
        self.addChild(gameBG)
        //6
        createGameBoard(width: Int(width), height: Int(height))
    }
    
    //create a game board, initialize array of cells
    private func createGameBoard(width: Int, height: Int) {
        let cellWidth: CGFloat = 27.5
        let numRows = 40
        let numCols = 20
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        //loop through rows and columns, create cells
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = SKColor.white
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
                //add to array of cells -- then add to game board
                gameArray.append((node: cellNode, x: i, y: j))
                gameBG.addChild(cellNode)
                //iterate x
                x += cellWidth
            }
            //reset x, iterate y
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "Play_Button"{
                    startGame()
                }
            }
        }
    }
    
    //Start the Game:
    private func startGame(){
        print("start game")
        //1
        gameLabel.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.gameLabel.isHidden = true
        }
        //2
        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }
        //3
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        bestScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBG.setScale(0)
            
            self.currentScore.setScale(0)
            
            self.gameBG.isHidden = false
            
            self.currentScore.isHidden = false
            
            self.gameBG.run(SKAction.scale(to: 1, duration: 0.4))
            
            self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
            self.game.initGame()
        }
    }
    
    
    //3
    private func initializeMenu(){
        //Game Title: //4
        gameLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        gameLabel.zPosition = 1
        gameLabel.position = CGPoint(x: 0, y: (frame.size.height / 2) - 300)
        gameLabel.fontSize = 70
        gameLabel.text = "BLOCK CHASE"
        gameLabel.fontColor = SKColor.magenta
        self.addChild(gameLabel)
        //Best Score label: //5
        bestScore = SKLabelNode(fontNamed: "AmericanTypewriter")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: gameLabel.position.y - 60)
        bestScore.fontSize = 50
        bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
        bestScore.fontColor = SKColor.brown
        self.addChild(bestScore)
        //Game Play Button: //6
        playButton = SKShapeNode()
        playButton.name = "Play_Button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y:(frame.size.height / -2) + 400)
        playButton.fillColor = SKColor.purple
        //7
        let topCorner = CGPoint(x: -70, y: 70)
        let bottomCorner = CGPoint(x: -70, y: -70)
        let middle = CGPoint(x: 70, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        //8
        playButton.path = path
        self.addChild(playButton)
    }
    
    
    
    
   
}
