import robots.*
import juego.*
import wollok.game.*

object sobrecalentamientoRojo {
    const imagen = "SobrecalientamientoR.png"
    const posicion = game.center()
    var activo = false

    method position() = posicion
    method image() = imagen

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            self.cicloDeQuemadura()
            game.schedule(15000, { self.desactivar() })
        }
    }

    method cicloDeQuemadura() {
        if (activo) {
            robotAzul.seQuema()
            game.schedule(2000, { self.cicloDeQuemadura() })
        }
    }

    method desactivar() {
        activo = false
        game.removeVisual(self)
    }
}

object sobrecalentamientoAzul {
    const imagen = "SobrecalientamientoA.png"
    const posicion = game.center()
    var activo = false

    method position() = posicion
    method image() = imagen

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            self.cicloDeQuemadura()
            game.schedule(15000, { self.desactivar() })
        }
    }

    method cicloDeQuemadura() {
        if (activo) {
            robotRojo.seQuema()
            game.schedule(2000, { self.cicloDeQuemadura() })
        }
    }

    method desactivar() {
        activo = false
        game.removeVisual(self)
    }
}


//----------------------------------------------------------------------------------------------------

object oxidacionR {
    const imagen = "OxidacionR.png"
    const posicion = game.center() // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method imagen() = imagen 

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
    const imagen = "OxidacionA.png"
    const posicion = game.center() // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method imagen() = imagen 

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
    const imagen = "CortoCircuito.png"
    const posicion = game.at(16, 13) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method imagen() = imagen 

    method activar() {
        if (!activo) {
        activo = true
        game.addVisual(self)
        robotAzul.seParalizo()
        game.schedule(15000, {
            game.removeVisual(self)
            activo = false
        })
    }
    }
}

object cortoCircuitoA {
    const imagen = "CortoCircuito.png"
    const posicion = game.at(16, 13) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method imagen() = imagen 

    method activar() {
        if (!activo) {
        activo = true
        game.addVisual(self)
        robotRojo.seParalizo()
        game.schedule(15000, {
            game.removeVisual(self)
            activo = false
        })
    }
    }
}


