import robots.*
import juego.*
import wollok.game.*

object sobrecalentamientoRojo {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    
    var activo = false

    method position() = posicion 
    method image() = if(robotRojo.puedeUsarHabilidad()) "habilidadDisR.png" else "rojoculdown3cuarto.png"

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
    method image() = if(robotAzul.puedeUsarHabilidad()) "habilidadDisA.png" else "azulculdown.png"

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
    method image() = if(robotAzul.puedeUsarHabilidad()) "habilidadDisA.png" else "azulculdown.png"

    method activar() {
    if (!activo) {
        activo = true
        game.addVisual(self)
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
    method image() = if(robotAzul.puedeUsarHabilidad()) "habilidadDisA.png" else "azulculdown.png"

    method activar() {
    if (!activo) {
        activo = true
        game.addVisual(self)
        robotRojo.seOxido()
        game.schedule(15000, {
            robotRojo.seLubrico()
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
    var property imagen = if(robotRojo.puedeUsarHabilidad()) "habilidadDisR.png" else "rojoculdown3cuarto.png"

    method activar() {
        if (!activo) {
        activo = true
        robotAzul.seParalizo()
        game.schedule(60000, { activo = false})
    }
    }
}

object cortoCircuitoA {
    var property  posicion = game.at(13, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = if(robotAzul.puedeUsarHabilidad()) "habilidadDisA.png" else "azulculdown.png"
    method activar() {
        if (!activo) {
        activo = true
        robotRojo.seParalizo()
        game.schedule(60000, {activo = false})
    }
    }

}
