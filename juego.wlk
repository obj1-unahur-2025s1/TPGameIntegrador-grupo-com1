import wollok.game.*

object juego {

    method iniciar(){
        
        game.addVisualCharacter(robotRojo)
        game.addVisualCharacter(robotAzul)

        game.addVisual(sensorR) 
        game.addVisual(sensorA)

        game.whenCollideDo(sensorR, { elemento =>
        if (!elemento.esRojo()) {
            sensorR.hayObstaculo(true)         
            //game.say(robotRojo, robotRojo.mensajeTest1())
        }
        })
        game.whenCollideDo(sensorA, { elemento =>
        if (!elemento.esAzul()) {
            sensorA.hayObstaculo(true)   
            //game.say(robotAzul, robotAzul.mensajeTest1())
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
    }
}

object robotRojo {
    var salud = 100
    var puedeGolpear = true
    var puedeAgachar = true
    var puedeBloquear = true      
    var posicionRojo = game.origin()
    var imagenActual = "RobotRojoNeutroTest1.png"
    const sensor = sensorR

    method position() = posicionRojo
    method image() = imagenActual
    method salud() = salud

    method hayAlgoALaDerecha() {    
        const proximaPosicion = posicionRojo.right(1)
        sensorR.position(proximaPosicion)
    }

    method neutro(){
        imagenActual = "RobotRojoNeutroTest1.png"
    }
    method agachar(){
        if (puedeAgachar) {
            puedeAgachar = false
            imagenActual = "RobotRojoAgacharTest1.png"
            game.schedule(500,{self.neutro()})
            game.schedule(1500, {puedeAgachar = true}) 
        }      
    }

    method golpear(){       
        if (puedeGolpear) {
            puedeGolpear = false
            imagenActual = "RobotRojoGolpearTest1.png"       
        if(sensorR.hayObstaculo()){
            robotAzul.bajarSalud()
            game.say(self, self.mensajeTest())
        }
        game.schedule(500, { self.neutro() })        // tiempo que dura el golpe
        game.schedule(1000, { puedeGolpear = true }) // cooldown de 1 segundo
    }
    }
    method bloquear(){
        if(puedeBloquear) {
            puedeBloquear = false
            imagenActual = "RobotRojoBloquearTest1.png"
            game.schedule(500,{self.neutro()})
            game.schedule(5000, {puedeBloquear = true})            
        }               
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
        salud -= 1.max(0)
    }

    method esRojo() = true
    method esAzul() = false
}

object robotAzul {
    var salud = 100
    var puedeGolpear = true
    var puedeAgachar = true
    var puedeBloquear = true     
    var posicionAzul = game.at(20,0)
    var imagenActual = "RobotAzulNeutroTest1.png"
    const sensor = sensorA

    method position() = posicionAzul
    method image() = imagenActual
    method salud() = salud

    method hayAlgoALaIzquierda() {    
        const proximaPosicion = posicionAzul.left(1)
        sensorA.position(proximaPosicion)
    }

    method neutro(){
        imagenActual = "RobotAzulNeutroTest1.png"
    }
    method agachar(){
        if (puedeAgachar) {
            puedeAgachar = false
            imagenActual = "RobotAzulAgacharTest1.png"
            game.schedule(500,{self.neutro()})
            game.schedule(1500, {puedeAgachar = true})             
        }        
    }

    method golpear(){
        if (puedeGolpear) {
        puedeGolpear = false
        imagenActual = "RobotAzulGolpearTest3.png"       
        if(sensor.hayObstaculo()){
            robotRojo.bajarSalud()
            game.say(self, self.mensajeTest())
        }
        game.schedule(500, { self.neutro() })        // tiempo que dura el golpe
        game.schedule(1000, { puedeGolpear = true }) // cooldown de 1 segundo
    }
    }
    method bloquear(){
        if(puedeBloquear) {
            puedeBloquear = false
            imagenActual = "RobotAzulBloquearTest1.png"
            game.schedule(500,{self.neutro()})
            game.schedule(5000, {puedeBloquear = true})              
        }                  
    }

    method moverDerecha() {
        posicionAzul = posicionAzul.right(1)
        self.hayAlgoALaIzquierda()
        game.schedule(300, {self.neutro()})
    }
    method moverIzquierda() {
        if(!sensor.hayObstaculo()){
            posicionAzul = posicionAzul.left(1)
            self.hayAlgoALaIzquierda()
            game.schedule(300, { self.neutro() })
        }
        sensor.hayObstaculo(false)
    }

    method mensajeTest() = "Te golpe"
    method mensajeTest1() = "Hay algo en la proxima posicion izq"

    method bajarSalud(){
        salud -= 1.max(0)
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
    } // Sin imagen, así no se muestra
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
    } // Sin imagen, así no se muestra
}



