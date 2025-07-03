import robots.*
import juego.*
import wollok.game.*

object sobrecalentamiento {
    const imagen = "Sobrecalentamiento.png"
    const posicion = game.center() 
    var activo = false

    method position() = posicion 
    method image() = imagen 

    method activar(unRobot) {
        if (!activo) {
            activo = true
            game.addVisual(self)
            self.cicloDeQuemadura(unRobot)
            game.schedule(15000, { self.desactivar() })
        }
    }

    method cicloDeQuemadura(unRobot) {
    if (activo) {
        unRobot.seQuema()
        game.schedule(2000, { self.cicloDeQuemadura(unRobot) }) // se llama a sí mismo cada 2 seg
    }
}

    method reducirSalud(unRobot) {
        if (activo) {
            if (unRobot.esRojo()) {
                robotAzul.seQuema()
            } else {
                robotRojo.seQuema()
            }
        }    
    }

    method desactivar() {
        if (activo) {
            activo = false
            game.removeVisual(self)
        }
    }
}

object oxidacion {
    const imagen = "Oxidacion.png"
    const posicion = game.center() // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method imagen() = imagen 

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(imagen)
        }
    }

    method desactivar() {
        if (activo) {
            activo = false
            game.removeVisual(imagen)
        }
    }
}

object cortoCircuito {
    const imagen = "CortoCircuito.png"
    const posicion = game.at(16, 13) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method imagen() = imagen 

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(imagen)
        }
    }

    method desactivar() {
        if (activo) {
            activo = false
            game.removeVisual(imagen)
        }
    }
}
