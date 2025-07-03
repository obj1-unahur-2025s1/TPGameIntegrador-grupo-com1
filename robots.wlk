import wollok.game.*
import juego.*
import habilidades.*


object robotRojo {
    var property salud = 100
    var puedeGolpear = true
    var puedeAgachar = true
    var puedeBloquear = true      
    var posicionRojo = game.at(1,1)
    var property imagenActual = "RobotRojoNeutroTest1.png"
    var property posicion = "neutro"
    var property estaDerrotado = false
    const sensor = sensorR
    var pasosPared = 0
    var property habilidad = null
    var puedeUsarHabilidad = true 
    var cooldownAgachado = 1500
    var cooldownGolpe = 1000
    var cooldownBloqueo = 5000  
    var estaParalizado = false 

    method position() = posicionRojo
    method image() = imagenActual
    //method salud() = salud

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
        puedeUsarHabilidad = true
        cooldownAgachado = 1500
        cooldownGolpe = 1000
        cooldownBloqueo = 5000
        estaParalizado = false
    }

    method hayAlgoALaDerecha() {    
        const proximaPosicion = posicionRojo.right(1)
        sensor.position(proximaPosicion)
    }

    method usarHabilidad() {
    if (habilidad != null && puedeUsarHabilidad) {
        game.say(self, "Usando habilidad")
        habilidad.activar()
        puedeUsarHabilidad = false
        game.schedule(60000, { puedeUsarHabilidad = true })  // 60 segundos = 1 minuto
    } else if (!puedeUsarHabilidad) {
        game.say(self, "Habilidad en enfriamiento... esperá un toque")
    } else {
        game.say(self, "No tengo habilidad")
    }
}  

    method neutro(){
        posicion = "neutro"
        imagenActual = "RobotRojoNeutroTest1.png"      
    }

    method derrotado() {
        const resorteSonido = game.sound("resorte2.mp3")
    if (!estaDerrotado) {
        estaDerrotado = true
        posicion = "derrotado"
        imagenActual = "RobotRojoDerrotado.png"
        resorteSonido.play()
        game.schedule(2000, { juego.finDeRonda("azul") })  
    }
    }

    method agachar(){
        if (puedeAgachar && !estaDerrotado && !estaParalizado) {
            puedeAgachar = false
            posicion = "agachado"
            imagenActual = "RobotRojoAgacharTest1.png"
            game.schedule(1000,{self.neutro()})
            game.schedule(cooldownAgachado, {puedeAgachar = true}) 
        }      
    }

    method golpear(){       
        if (puedeGolpear && !estaDerrotado && !estaParalizado) {
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
        game.schedule(cooldownGolpe, { puedeGolpear = true }) // cooldown de 1 segundo
    }
    }
    method bloquear(){
        if(puedeBloquear && !estaDerrotado && !estaParalizado) {
            puedeBloquear = false
            posicion = "bloqueando"
            imagenActual = "RobotRojoBloquearTest1.png"
            game.schedule(1000,{self.neutro()})
            game.schedule(cooldownBloqueo, {puedeBloquear = true})            
        }               
    }

    method moverDerecha() {
    if (!sensor.hayObstaculo() && !estaDerrotado && !estaParalizado) {
        posicionRojo = posicionRojo.right(1)
        pasosPared = pasosPared + 1
    }
    self.hayAlgoALaDerecha()  // SIEMPRE actualizar el sensor
    game.schedule(300, { self.neutro() })
}

    method moverIzquierda() {
        if (!estaDerrotado && pasosPared !== 0 && !estaParalizado)  {
            posicionRojo = posicionRojo.left(1)
            self.hayAlgoALaDerecha()  // Actualizá también al moverte hacia la izquierda
            game.schedule(300, { self.neutro() })
            pasosPared = pasosPared - 1
        }
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

    method seQuema() {
        salud -= 1.max(0)
        vidaRojo.salud(salud) // Actualiza la salud en el objeto de
    }

    method seOxido(){
        game.say(self, "¡Me oxidé!")
        cooldownAgachado = 5000
        cooldownGolpe = 3000
        cooldownBloqueo = 8000
    }
    method seLubrico() {
        cooldownAgachado = 1500
        cooldownGolpe = 1000
        cooldownBloqueo = 5000
    }
    method seParalizo() {
        game.say(self, "¡Me paralicé!")
        estaParalizado = true
        game.schedule(15000, { estaParalizado = false })
    }

    method esRojo() = true
    method esAzul() = false
       method habilitarGolpe() {
        puedeGolpear = true
    }
}

object robotAzul {
    var property salud = 100
    var puedeGolpear = true
    var puedeAgachar = true
    var puedeBloquear = true 
    var posicionAzul = game.at(22,1)
    var property imagenActual = "RobotAzulNeutroTest1.png"
    var property posicion = "neutro"
    var property estaDerrotado = false
    const sensor = sensorA
    var pasosPared = 0 // Variable para contar los pasos hacia la pared
    var property habilidad = null
    var puedeUsarHabilidad = true 
    var cooldownAgachado = 1500
    var cooldownGolpe = 1000
    var cooldownBloqueo = 5000
    var estaParalizado = false  

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
        puedeUsarHabilidad = true
        cooldownAgachado = 1500
        cooldownGolpe = 1000
        cooldownBloqueo = 5000
        estaParalizado = false
    }

    method hayAlgoALaIzquierda() {    
        const proximaPosicion = posicionAzul.left(1)
        sensor.position(proximaPosicion)
    }

    method usarHabilidad() {
    if (habilidad != null && puedeUsarHabilidad) {
        game.say(self, "Usando habilidad")
        habilidad.activar()
        puedeUsarHabilidad = false
        game.schedule(60000, { puedeUsarHabilidad = true })  // 60 segundos = 1 minuto
    } else if (!puedeUsarHabilidad) {
        game.say(self, "Habilidad en enfriamiento... esperá un toque")
    } else {
        game.say(self, "No tengo habilidad")
    }
}

    method neutro(){
        posicion = "neutro"
        imagenActual = "RobotAzulNeutroTest1.png"
    }

    method derrotado() {
        const resorteSonido = game.sound("resorte2.mp3")
        if (!estaDerrotado) {
            estaDerrotado = true
            posicion = "derrotado"
            imagenActual = "RobotAzulDerrotado.png"
            resorteSonido.play()
            game.schedule(2000, { juego.finDeRonda("rojo") }) // Rojo gana la ronda
    }
    }

    method agachar(){
        if (puedeAgachar && !estaDerrotado && !estaParalizado) {
            puedeAgachar = false
            posicion = "agachado"
            imagenActual = "RobotAzulAgacharTest1.png"
            game.schedule(1000,{self.neutro()})
            game.schedule(cooldownAgachado, {puedeAgachar = true})             
        }        
    }

    method golpear(){       
        if (puedeGolpear && !estaDerrotado && !estaParalizado) {
            puedeGolpear = false
            posicion = "golpeando"               
        if(sensor.hayObstaculo() && !estaDerrotado) {
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
        game.schedule(cooldownGolpe, { puedeGolpear = true }) // cooldown de 1 segundo
    }
    }
    method bloquear(){
        if(puedeBloquear && !estaDerrotado && !estaParalizado) {
            puedeBloquear = false
            posicion = "bloqueando"
            imagenActual = "RobotAzulBloquearTest1.png"
            game.schedule(1000,{self.neutro()})
            game.schedule(cooldownBloqueo, {puedeBloquear = true})              
        }                  
    }

    method moverDerecha() {  
        if (!estaDerrotado && pasosPared !== 0 && !estaParalizado)  { 
            posicionAzul = posicionAzul.right(1)  
            self.hayAlgoALaIzquierda()  // SIEMPRE actualizar el sensor
            game.schedule(300, { self.neutro() })
            pasosPared = pasosPared - 1
        }
    }
    
    method moverIzquierda() {
        if (!sensor.hayObstaculo() && !estaDerrotado && !estaParalizado) {
        posicionAzul = posicionAzul.left(1)
        pasosPared = pasosPared + 1
        self.hayAlgoALaIzquierda()  // SIEMPRE actualizar el sensor
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

    method seQuema() {
        salud -= 1.max(0)
        vidaAzul.salud(salud) // Actualiza la salud en el objeto de
    }

    method seOxido(){
        game.say(self, "¡Me oxidé!")
        cooldownAgachado = 5000
        cooldownGolpe = 3000
        cooldownBloqueo = 8000
    }
    method seLubrico() {
        cooldownAgachado = 1500
        cooldownGolpe = 1000
        cooldownBloqueo = 5000
    }
    method seParalizo() {
        game.say(self, "¡Me paralicé!")
        estaParalizado = true
        game.schedule(15000, { estaParalizado = false })
    }

    method esRojo() = false
    method esAzul() = true
    method habilitarGolpe() {
        puedeGolpear = true
    }
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
            robotRojo.derrotado()
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
            robotAzul.derrotado()
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

