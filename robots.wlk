import wollok.game.*
import juego.*


object robotRojo {
    var property salud = 100
    var puedeGolpear = true
    var puedeAgachar = true
    var puedeBloquear = true      
    var posicionRojo = game.at(1,1)
    var imagenActual = "RobotRojoNeutroTest1.png"
    var property posicion = "neutro"
    var property estaDerrotado = false
    const sensor = sensorR

    method position() = posicionRojo
    method image() = imagenActual
    method salud() = salud

    method reiniciar() {
        salud = 100
        puedeGolpear = true
        puedeAgachar = true
        puedeBloquear = true
        posicionRojo = game.at(1,1)
        imagenActual = "RobotRojoNeutroTest1.png"
        posicion = "neutro"
        estaDerrotado = false
        sensor.position(posicionRojo)
    }

    method hayAlgoALaDerecha() {    
        const proximaPosicion = posicionRojo.right(1)
        sensor.position(proximaPosicion)
    }

    method neutro(){
        posicion = "neutro"
        imagenActual = "RobotRojoNeutroTest1.png"      
    }

    method derrotado() {
    if (!estaDerrotado) {
        estaDerrotado = true
        posicion = "derrotado"
        imagenActual = "RobotRojoDerrotado.png"
        game.sound("resorte.mp3").play()
        game.schedule(5000, { juego.finDelJuego() })  
    }
    }

    method agachar(){
        if (puedeAgachar) {
            puedeAgachar = false
            posicion = "agachado"
            imagenActual = "RobotRojoAgacharTest1.png"
            game.schedule(1000,{self.neutro()})
            game.schedule(1500, {puedeAgachar = true}) 
        }      
    }

    method golpear(){       
        if (puedeGolpear) {
            puedeGolpear = false
            posicion = "golpeando"               
        if(sensor.hayObstaculo()) {
            robotAzul.bajarSalud()
            if (robotAzul.posicion() == "neutro" || robotAzul.posicion() == "bloqueando"){
                imagenActual = "RobotRojoGolpearConEfecto.png" 
            }else {
                imagenActual = "RobotRojoGolpearTest1.png"
            }
            //game.say(self, self.mensajeTest())
        } else {
            imagenActual = "RobotRojoGolpearTest1.png" // Si no hay obstáculo, vuelve a la imagen normal
        }
        game.schedule(500, { self.neutro() })        // tiempo que dura el golpe
        game.schedule(1000, { puedeGolpear = true }) // cooldown de 1 segundo
    }
    }
    method bloquear(){
        if(puedeBloquear) {
            puedeBloquear = false
            posicion = "bloqueando"
            imagenActual = "RobotRojoBloquearTest1.png"
            game.schedule(1000,{self.neutro()})
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
        if (posicion == "neutro" || posicion == "golpeando") {
            salud -= 10.max(0)
            game.sound("golpe.wav").play()
        } else if (posicion == "agachado") {
            salud -= 0 // Si está agachado, no recibe daño
        } else if (posicion == "bloqueando") {
            robotAzul.bajarSalud()  // Si está bloqueando, no recibe daño pero el otro robot sí
            game.sound("golpe.wav").play()
        }
        vidaRojo.salud(salud) // Actualiza la salud en el objeto de vida
    }

    method esRojo() = true
    method esAzul() = false
}

object robotAzul {
    var property salud = 100
    var puedeGolpear = true
    var puedeAgachar = true
    var puedeBloquear = true     
    var posicionAzul = game.at(22,1)
    var imagenActual = "RobotAzulNeutroTest1.png"
    var property posicion = "neutro"
    var property estaDerrotado = false
    const sensor = sensorA

    method position() = posicionAzul
    method image() = imagenActual
    method salud() = salud

    method reiniciar() {
        salud = 100
        puedeGolpear = true
        puedeAgachar = true
        puedeBloquear = true
        posicionAzul = game.at(22,1)
        imagenActual = "RobotAzulNeutroTest1.png"
        posicion = "neutro"
        estaDerrotado = false
        sensor.position(posicionAzul)
    }

    method hayAlgoALaIzquierda() {    
        const proximaPosicion = posicionAzul.left(1)
        sensor.position(proximaPosicion)
    }

    method neutro(){
        posicion = "neutro"
        imagenActual = "RobotAzulNeutroTest1.png"
    }

    method derrotado() {
    if (!estaDerrotado) {
        estaDerrotado = true
        posicion = "derrotado"
        imagenActual = "RobotAzulDerrotado.png"
        game.sound("resorte.mp3").play()
        game.schedule(5000, { juego.finDelJuego() })  
    }
    }

    method agachar(){
        if (puedeAgachar) {
            puedeAgachar = false
            posicion = "agachado"
            imagenActual = "RobotAzulAgacharTest1.png"
            game.schedule(1000,{self.neutro()})
            game.schedule(1500, {puedeAgachar = true})             
        }        
    }

    method golpear(){       
        if (puedeGolpear) {
            puedeGolpear = false
            posicion = "golpeando"               
        if(sensor.hayObstaculo()) {
            robotRojo.bajarSalud()
            if (robotRojo.posicion() == "neutro" || robotRojo.posicion() == "bloqueando"){
                imagenActual = "RobotAzulGolpearConEfecto.png" 
            }else {
                imagenActual = "RobotAzulGolpearTest3.png"
            }
            //game.say(self, self.mensajeTest())
        } else {
            imagenActual = "RobotAzulGolpearTest3.png" // Si no hay obstáculo, vuelve a la imagen normal
        }
        game.schedule(500, { self.neutro() })        // tiempo que dura el golpe
        game.schedule(1000, { puedeGolpear = true }) // cooldown de 1 segundo
    }
    }
    method bloquear(){
        if(puedeBloquear) {
            puedeBloquear = false
            posicion = "bloqueando"
            imagenActual = "RobotAzulBloquearTest1.png"
            game.schedule(1000,{self.neutro()})
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
        if (posicion == "neutro" || posicion == "golpeando") {
            salud -= 10.max(0)
            game.sound("golpe.wav").play()
        } else if (posicion == "agachado") {
            salud -= 0 // Si está agachado, no recibe daño
        } else if (posicion == "bloqueando") {
            robotRojo.bajarSalud() // Si está bloqueando, no recibe daño pero el otro robot sí
            game.sound("golpe.wav").play()
        }
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
    var property imagenActual = "Rojo100V2.png"

    method position() = posicion
    method salud(suSalud) {
        salud = suSalud
    }
    method image() {
        imagenActual = "Rojo100V2.png"
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
            robotRojo.derrotado() // Si la salud llega a 0, el robot rojo es derrotado
        }
        return imagenActual
    }


    
    method text() = "Salud: " + salud.toString()
    method textColor() = paleta.blanco()
    
    
}

object vidaAzul {
    const posicion = game.at(18, 11)
    var salud = robotRojo.salud()
    var property imagenActual = "Azul100V2.png"

    method position() = posicion
    method salud(suSalud) {
        salud = suSalud
    }

    method image() {
        imagenActual = "Azul100V2.png"
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
            robotAzul.derrotado() // Si la salud llega a 0, el robot azul es derrotado
        }
        return imagenActual
    }
    
    method text() = "Salud: " + salud.toString()
    method textColor() = paleta.blanco()
    
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


