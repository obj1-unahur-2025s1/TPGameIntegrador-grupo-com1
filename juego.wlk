import wollok.game.*

object juego {

    method iniciar(){
        
        game.addVisualCharacter(robotRojo)
        game.addVisualCharacter(robotAzul)

        game.addVisual(sensorR) 
        game.addVisual(sensorA)


        game.addVisual(vidaRojo) 
        game.addVisual(vidaAzul)

        game.whenCollideDo(sensorR, { elemento =>
        if (!elemento.esRojo()) {
            sensorR.hayObstaculo(true)         
            //game.say(robotRojo, robotRojo.mensajeTest1())
            game.schedule(100, { sensorR.hayObstaculo(false) })
        }
        })
        game.whenCollideDo(sensorA, { elemento =>
        if (!elemento.esAzul()) {
            sensorA.hayObstaculo(true)   
            //game.say(robotAzul, robotAzul.mensajeTest1())
            game.schedule(100, { sensorA.hayObstaculo(false) })
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
    var posicionRojo = game.at(1,1)
    var imagenActual = "RobotRojoNeutroTest1.png"
    const sensor = sensorR

    method position() = posicionRojo
    method image() = imagenActual
    method salud() = salud

    method hayAlgoALaDerecha() {    
        const proximaPosicion = posicionRojo.right(1)
        sensor.position(proximaPosicion)
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
        if(sensor.hayObstaculo()){
            robotAzul.bajarSalud()
            //game.say(self, self.mensajeTest())
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
    if (!sensor.hayObstaculo()) {
        posicionRojo = posicionRojo.right(1)
    }
    self.hayAlgoALaDerecha()  // SIEMPRE actualizar el sensor
    game.schedule(300, { self.neutro() })
}

    method moverIzquierda() {
    posicionRojo = posicionRojo.left(1)
    self.hayAlgoALaDerecha()  // Actualizá también al moverte hacia la izquierda
    game.schedule(300, { self.neutro() })
}

    method mensajeTest() = "Te golpe"
    method mensajeTest1() = "Hay algo en la proxima posicion der"
    

    method bajarSalud(){
        salud -= 1.max(0)
        vidaRojo.salud(salud) // Actualiza la salud en el objeto de vida
    }

    method esRojo() = true
    method esAzul() = false
}

object robotAzul {
    var salud = 100
    var puedeGolpear = true
    var puedeAgachar = true
    var puedeBloquear = true     
    var posicionAzul = game.at(22,1)
    var imagenActual = "RobotAzulNeutroTest1.png"
    const sensor = sensorA

    method position() = posicionAzul
    method image() = imagenActual
    method salud() = salud

    method hayAlgoALaIzquierda() {    
        const proximaPosicion = posicionAzul.left(1)
        sensor.position(proximaPosicion)
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
            //game.say(self, self.mensajeTest())
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
    self.hayAlgoALaIzquierda()  // SIEMPRE actualizar el sensor
    game.schedule(300, { self.neutro() })
}

    method moverIzquierda() {
        if (!sensor.hayObstaculo()){
            posicionAzul = posicionAzul.left(1)
            self.hayAlgoALaIzquierda()  // Actualizá también al moverte hacia la izquierda
            game.schedule(300, { self.neutro() })
        }
}

    method mensajeTest() = "Te golpe"
    method mensajeTest1() = "Hay algo en la proxima posicion izq"

    method bajarSalud(){
        salud -= 1.max(0)
        vidaAzul.salud(salud) // Actualiza la salud en el objeto de vida
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
}

object vidaRojo {
    const posicion = game.at(1, 11)
    var salud = robotRojo.salud()

    method position() = posicion
    method salud(suSalud) {
        salud = suSalud
    }
    method image() {
        var imagenActual = "Rojo100V2.png"
        if (salud <= 90) {
            imagenActual = "Rojo90V2.png"
        }
        if (salud <= 80) {
            imagenActual = "Rojo80V2.png"
        }
        if (salud <= 70) {
            imagenActual = "Rojo70V2.png"
        }
        if (salud <= 60) {
            imagenActual = "Rojo60V2.png"
        }
        if (salud <= 50) {
            imagenActual = "Rojo50V2.png"
        }
        if (salud <= 40) {
            imagenActual = "Rojo40V2.png"
        }
        if (salud <= 30) {
            imagenActual = "Rojo30V2.png"
        }
        if (salud <= 20) {
            imagenActual = "Rojo20V2.png"
        }
        if (salud <= 10) {
            imagenActual = "Rojo10V2.png"
        }
        if (salud <= 0) {
            imagenActual = "Rojo0V2.png"
        }
        return imagenActual
    }


    /*
    method text() = "Salud: " + salud.toString()
    method textColor() = paleta.blanco()
    */
    
}

object vidaAzul {
    const posicion = game.at(17, 11)
    var salud = robotRojo.salud()

    method position() = posicion
    method salud(suSalud) {
        salud = suSalud
    }

    method image() {
        var imagenActual = "Azul100V2.png"
        if (salud <= 90) {
            imagenActual = "Azul90V2.png"
        }
        if (salud <= 80) {
            imagenActual = "Azul80V2.png"
        }
        if (salud <= 70) {
            imagenActual = "Azul70V2.png"
        }
        if (salud <= 60) {
            imagenActual = "Azul60V2.png"
        }
        if (salud <= 50) {
            imagenActual = "Azul50V2.png"
        }
        if (salud <= 40) {
            imagenActual = "Azul40V2.png"
        }
        if (salud <= 30) {
            imagenActual = "Azul30V2.png"
        }
        if (salud <= 20) {
            imagenActual = "Azul20V2.png"
        }
        if (salud <= 10) {
            imagenActual = "Azul10V2.png"
        }
        if (salud <= 0) {
            imagenActual = "Azul0V2.png"
        }
        return imagenActual
    }
    /*
    method text() = "Salud: " + salud.toString()
    method textColor() = paleta.blanco()
    */
}

object paleta {
    const property verde = "00FF00FF"
    const property rojo = "FF0000FF"
    const property azul = "0000FFFF"
    const property amarillo = "FFFF00FF"
    const property naranja = "FFA500FF"
    const property violeta = "800080FF"
    const property blanco = "FFFFFFFF"
}


