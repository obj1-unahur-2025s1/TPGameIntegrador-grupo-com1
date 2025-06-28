import wollok.game.*

object juego {

    method iniciar(){
        
        game.addVisualCharacter(robotRojo)
        game.addVisualCharacter(robotAzul)

        game.addVisual(sensorR)  // lo agregás una sola vez
        game.addVisual(sensorA)

        game.whenCollideDo(sensorR, { elemento =>
        if (!elemento.esRojo()) {
            sensorR.hayObstaculo(true)         
            game.say(robotRojo, robotRojo.mensajeTest1())
        }
        })
        game.whenCollideDo(sensorA, { elemento =>
        if (!elemento.esAzul()) {
            sensorA.hayObstaculo(true)   
            game.say(robotAzul, robotAzul.mensajeTest1())
        }})

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

        game.whenCollideDo(robotRojo, {elemento => elemento.bajarSalud() game.say(robotRojo,robotRojo.mensajeTest())})
        game.whenCollideDo(robotAzul, {elemento => elemento.bajarSalud() game.say(robotAzul,robotAzul.mensajeTest())})
        
    }
}

object robotRojo {
    var salud = 100
    const sensor = sensorR

    var posicionRojo = game.origin()
    var imagenActual = "RobotRojoNeutroTest1.png"


    method position() = posicionRojo

    method image() = imagenActual

    method hayAlgoALaDerecha() {    
        const proximaPosicion = posicionRojo.right(1)
        sensorR.position(proximaPosicion)
    }

    method neutro(){
        imagenActual = "RobotRojoNeutroTest1.png"
    }

    method agachar(){
        imagenActual = "RobotRojoAgacharTest1.png"
        game.schedule(1500,{self.neutro()})
    }

    method golpear(){
        imagenActual = "RobotRojoGolpearTest1.png"
        game.schedule(500,{self.neutro()})
    }

    method bloquear(){
        imagenActual = "RobotRojoBloquearTest1.png"
        game.schedule(1500,{self.neutro()})
    }

    method moverDerecha() {
        if(!sensor.hayObstaculo()){
            posicionRojo = posicionRojo.right(1)
            self.hayAlgoALaDerecha()
            game.schedule(300, { self.neutro() })
        }
        sensor.hayObstaculo(false)  
        }

    method moverIzquierda() {
        posicionRojo = posicionRojo.left(1)
        self.hayAlgoALaDerecha()  // Opcional si querés detectar hacia ese lado también
        game.schedule(300, { self.neutro() })
    }

    method mensajeTest() = "Te golpe"
    method mensajeTest1() = "Hay algo en la proxima posicion der"
    

    method bajarSalud(){
        salud -= 1
    }

    method esRojo() = true
    method esAzul() = false
}

object robotAzul {
    var salud = 100
    

    var posicionAzul = game.at(20,0)
    var imagenActual = "RobotAzulNeutroTest1.png"

    method position() = posicionAzul
    method image() = imagenActual

    method hayAlgoALaIzquierda() {    
        const proximaPosicion = posicionAzul.left(1)
        sensorA.position(proximaPosicion)
    }

    method neutro(){
        imagenActual = "RobotAzulNeutroTest1.png"
    }

    method agachar(){
        imagenActual = "RobotAzulAgacharTest1.png"
        game.schedule(1500,{self.neutro()})
    }

    method golpear(){
        imagenActual = "RobotAzulGolpearTest3.png"
        game.schedule(500,{self.neutro()})
    }

    method bloquear(){
        imagenActual = "RobotAzulBloquearTest1.png"
        game.schedule(1500,{self.neutro()})
    }

    method moverDerecha() {
        posicionAzul = posicionAzul.right(1)
        self.hayAlgoALaIzquierda()
        game.schedule(300, {self.neutro()})
    }

    method moverIzquierda() {
        if(!sensorA.hayObstaculo()){
            posicionAzul = posicionAzul.left(1)
            self.hayAlgoALaIzquierda()
            game.schedule(300, { self.neutro() })
        }
        sensorA.hayObstaculo(false)
    }

    method mensajeTest() = "Te golpe"
    method mensajeTest1() = "Hay algo en la proxima posicion izq"

    method bajarSalud(){
        salud -= 1
    }

    method esRojo() = false
    method esAzul() = true
}

object sensorR {
    var posicionInterna = game.center()
    var hayObstaculo = false

    method position() = posicionInterna
    method position(unaPosicion) {
        posicionInterna = unaPosicion
    }
    method hayObstaculo() = hayObstaculo
    method hayObstaculo(estado) {
        hayObstaculo = estado
    }

    // Sin imagen, así no se muestra
}

object sensorA {
    var posicionInterna = game.center()
    var hayObstaculo = false

    method position() = posicionInterna
    method position(unaPosicion) {
        posicionInterna = unaPosicion
    }
    method hayObstaculo() = hayObstaculo
    method hayObstaculo(estado) {
        hayObstaculo = estado
    }

    // Sin imagen, así no se muestra
}



