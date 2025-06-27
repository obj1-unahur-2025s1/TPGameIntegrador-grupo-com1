import wollok.game.*

object juego {

    method iniciar(){
        
        game.addVisualCharacter(robotRojo)
        game.addVisualCharacter(robotAzul)

        keyboard.q().onPressDo{robotRojo.bloquear()}
        keyboard.s().onPressDo{robotRojo.agachar()}
        keyboard.e().onPressDo{robotRojo.golpear()}

        keyboard.a().onPressDo{robotRojo.moverIzquierda()}
        keyboard.d().onPressDo{robotRojo.moverDerecha()}

        keyboard.k().onPressDo{robotAzul.bloquear()}
        keyboard.down().onPressDo{robotAzul.agachar()}
        keyboard.l().onPressDo{robotAzul.golpear()}

        keyboard.left().onPressDo{robotAzul.moverIzquierda()}
        keyboard.right().onPressDo{robotAzul.moverDerecha()}
        
    }

}

object robotRojo {
    var posicionInterna = game.origin()
    var imagenActual = "RobotRojoNeutroTest1.png"

    method position() = posicionInterna

    method image() = imagenActual

    method neutro(){
        imagenActual = "RobotRojoNeutroTest1.png"
    }

    method agachar(){
        imagenActual = "RobotRojoAgachar.png"
        game.schedule(1500,{self.neutro()})
    }

    method golpear(){
        imagenActual = "RobotRojoGolpearTest1.png"
        game.schedule(500,{self.neutro()})
    }

    method bloquear(){
        imagenActual = "RobotRojoBloquea.png"
        game.schedule(1500,{self.neutro()})
    }

    method moverDerecha() {
        posicionInterna = posicionInterna.right(1)
        game.schedule(300, { self.neutro() })
    }

    method moverIzquierda() {
        posicionInterna = posicionInterna.left(1)
        game.schedule(300, { self.neutro() })
    }
}

object robotAzul {
    var posicionInterna = game.at(20,0)
    var imagenActual = "RobotAzulNeutroTest1.png"

    method position() = posicionInterna

    method image() = imagenActual

    method neutro(){
        imagenActual = "RobotAzulNeutroTest1.png"
    }

    method agachar(){
        imagenActual = "RobotAzulAgachar.png"
        game.schedule(1500,{self.neutro()})
    }

    method golpear(){
        imagenActual = "RobotAzulGolpearTest3.png"
        game.schedule(500,{self.neutro()})
    }

    method bloquear(){
        imagenActual = "RobotAzulBloquear.png"
        game.schedule(1500,{self.neutro()})
    }

    method moverDerecha() {
        posicionInterna = posicionInterna.right(1)
        game.schedule(300, { self.neutro() })
    }

    method moverIzquierda() {
        posicionInterna = posicionInterna.left(1)
        game.schedule(300, { self.neutro() })
    }
}


