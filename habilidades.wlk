import robots.*
import juego.*
import wollok.game.*

object sobrecalentamientoRojo {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    
    var activo = false

    method position() = posicion 
    method image() = if(robotRojo.puedeUsarHabilidad()) "descarga.png" else "rojoculdown3cuarto.png"

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
        game.removeVisual(self)
    }
}

object sobrecalentamientoAzul {
    var property  posicion = game.at(13, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = if(robotAzul.puedeUsarHabilidad()) "habilidadisp.png" else "azulculdown.png"

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
        game.removeVisual(self)
    }
}

object efectoQuemaduraR {
    var property posicion = game.at(22, 0)
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
    var property posicion = game.at(1, 0)
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

/*
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

*/

object oxidacionR {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    var activo = false
    var imagenActual = "descarga.png"

    method position() = posicion 
    method image() {
        if(robotRojo.puedeUsarHabilidad()){
            imagenActual = "descarga.png"
        } else{
            imagenActual = "rojoculdown3cuarto.png"
        }
        return imagenActual 
    } 

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
    method image() = if(!robotAzul.puedeUsarHabilidad()) "azulculdown.png" else "habilidadisp.png"

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
    var property  imagen = if(robotRojo.puedeUsarHabilidad()) "descarga.png" else "rojoculdown3cuarto.png"

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
    method image() = if(robotAzul.puedeUsarHabilidad()) "habilidadisp.png" else "azulculdown.png"
    method activar() {
        if (!activo) {
        activo = true
        robotRojo.seParalizo()
        game.schedule(60000, {activo = false})
    }
    }

}



/*
object sobrecalentamientoRojo {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = if(robotRojo.puedeUsarHabilidad()) "descarga.png" else "rojoculdown3cuarto.png"

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
            game.say(robotAzul, "¡Quemado!")
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
    var property  posicion = game.at(13, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = if(robotAzul.puedeUsarHabilidad()) "habilidadisp.png" else "azulculdown.png"

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
            game.say(robotAzul, "¡Quemado!")
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
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    var activo = false
    var imagenActual = "descarga.png"

    method position() = posicion 
    method image() {
        if(robotRojo.puedeUsarHabilidad()){
            imagenActual = "descarga.png"
        } else{
            imagenActual = "rojoculdown3cuarto.png"
        }
        return imagenActual 
    } 

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
    method image() = if(!robotAzul.puedeUsarHabilidad()) "azulculdown.png" else "habilidadisp.png"

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
    var property  imagen = if(robotRojo.puedeUsarHabilidad()) "descarga.png" else "rojoculdown3cuarto.png"

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
    method image() = if(robotAzul.puedeUsarHabilidad()) "habilidadisp.png" else "azulculdown.png"
    method activar() {
        if (!activo) {
        activo = true
        robotRojo.seParalizo()
        game.schedule(60000, {activo = false})
    }
    }

}
*/

