import robots.*
import juego.*
import wollok.game.*

object sobrecalentamientoRojo {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    
    var activo = false

    method position() = posicion 
    method image() = "rojoculdown3cuarto.png"

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            efectoQuemaduraR.activar()
            self.cicloDeQuemadura()
            game.schedule(15000, { self.desactivar() })
        }
    }

    method cicloDeQuemadura() {
        if (activo) { 
            //game.say(robotAzul, "¡Quemado!")
            robotAzul.seQuema()
            game.schedule(2000, { 
            self.cicloDeQuemadura()
            })
    }
}

    method desactivar() {
        activo = false
    }
}

object sobrecalentamientoAzul {
    var property  posicion = game.at(13, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = "azulculdown.png"

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            efectoQuemaduraA.activar()
            self.cicloDeQuemadura()
            game.schedule(15000, { self.desactivar() })
        }
    }

    method cicloDeQuemadura() {
        if (activo) {
            const sonidoQuemadura = game.sound("sobrecalientamiento.mp3")
            sonidoQuemadura.play()
           // game.say(robotAzul, "¡Quemado!")
            robotRojo.seQuema()
            game.schedule(2000, { 
            self.cicloDeQuemadura() 
            sonidoQuemadura.stop()})
    }
}

    method desactivar() {
        activo = false
    }
}

object efectoQuemaduraR {
    var property posicion = game.at(28, 12)
    var activo = false

    method position() = posicion
    method posicion(unaPosicion) {
        posicion = unaPosicion
    }
    method image() = 'efectoQuemadoR.png'

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            game.schedule(15000, {
                game.removeVisual(self)
                activo = false
            })
        }
    }
}

object efectoQuemaduraA {
    var property posicion = game.at(1, 12)
    var activo = false

    method position() = posicion
    method posicion(unaPosicion) {
        posicion = unaPosicion
    }
    method image() = 'efectoQuemadoA.png'

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            game.schedule(15000, {
                game.removeVisual(self)
                activo = false
            })
        }
    }
}



//----------------------------------------------------------------------------------------------------



object oxidacionR {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = "rojoculdown3cuarto.png"

    method activar() {
    if (!activo) {
        activo = true
        game.addVisual(self)
        efectoOxidacionR.activar()
        robotAzul.seOxido()
        game.schedule(15000, {
            robotAzul.seLubrico()
            game.removeVisual(self)
            activo = false
        })
    }
    }
}


object oxidacionA {
    var property posicion = game.at(13, 0)
    var activo = false
    

    method position() = posicion
    method image() = "azulculdown.png"

    method activar() {
    if (!activo) {
        activo = true
        game.addVisual(self)
        efectoOxidacionA.activar()
        robotRojo.seOxido()
        game.schedule(15000, {
            robotRojo.seLubrico()
            game.removeVisual(self)
            activo = false
        })
    }
    }
}

object efectoOxidacionR {
    var property posicion = game.at(28, 12)
    var activo = false

    method position() = posicion
    method posicion(unaPosicion) {
        posicion = unaPosicion
    }
    method image() = 'efectoOxidoR.png'

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            game.schedule(15000, {
                game.removeVisual(self)
                activo = false
            })
        }
    }
}

object efectoOxidacionA {
    var property posicion = game.at(1, 12)
    var activo = false

    method position() = posicion
    method posicion(unaPosicion) {
        posicion = unaPosicion
    }
    method image() = 'efectoOxidoA.png'

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            game.schedule(15000, {
                game.removeVisual(self)
                activo = false
            })
        }
    }
}



//-------------------------------------------------------------------------------------------

object cortoCircuitoR {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = imagen
    var property imagen = "rojoculdown3cuarto.png"

    method activar() {
        if (!activo) {
        activo = true
        game.addVisual(self)
        efectoCortoR.activar()
        robotAzul.seParalizo()
        game.schedule(45000, { activo = false})
    }
    }

    method desactivar() {
        activo = false
    }
}

object cortoCircuitoA {
    var property  posicion = game.at(13, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = "azulculdown.png"
    method activar() {
        if (!activo) {
        activo = true
        game.addVisual(self)
        efectoCortoA.activar()
        robotRojo.seParalizo()
        game.schedule(60000, {activo = false})
    }
    }
}

object efectoCortoR {
    var property posicion = game.at(28, 12)
    var activo = false

    method position() = posicion
    method posicion(unaPosicion) {
        posicion = unaPosicion
    }
    method image() = 'efectoCortoR.png'

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            game.schedule(15000, {
                game.removeVisual(self)
                activo = false
            })
        }
    }

    method desactivar() {
        activo = false
    }
}

object efectoCortoA {
    var property posicion = game.at(1, 12)
    var activo = false

    method position() = posicion
    method posicion(unaPosicion) {
        posicion = unaPosicion
    }
    method image() = 'efectoCortoA.png'

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            game.schedule(15000, {
                game.removeVisual(self)
                activo = false
            })
        }
    }
}