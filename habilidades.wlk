import robots.*
import juego.*
import wollok.game.*

object sobrecalentamientoRojo {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = if(!activo) "descarga.png" else "rojoculdown3cuarto.png"
    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            self.cicloDeQuemadura()
            game.schedule(45000, { self.desactivar() })
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
 
    }
}

object sobrecalentamientoAzul {
    var property  posicion = game.at(13, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = if(!activo) "habilidadisp.png" else "azulculdown.png"

    method activar() {
        if (!activo) {
            activo = true
            game.addVisual(self)
            self.cicloDeQuemadura()
            game.schedule(15000, { self.desactivar() })
        }
        game.schedule(45000, {activo = false})
    }

    method cicloDeQuemadura() {
        if (activo) {
            robotRojo.seQuema()
            game.schedule(2000, { self.cicloDeQuemadura() })
        }
    }

    method desactivar() {
        activo = false
      
    }
}


//----------------------------------------------------------------------------------------------------

object oxidacionR {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = if(!activo) "descarga.png" else "rojoculdown3cuarto.png"

    method activar() {
    if (!activo) {
        activo = true
        robotAzul.seOxido()
        game.schedule(15000, {
            robotAzul.seLubrico()
      
            
        })
        game.schedule(60000, {activo = false})
    }
    }
}

object oxidacionA {
    var property posicion = game.at(13, 0)
    var activo = false
    var enCooldown = false

    method position() = posicion
    method image() = if(enCooldown) "azulculdown.png" else "habilidadisp.png"

    method activar() {
        if (!activo) {
            activo = true
            enCooldown = true
            game.addVisual(self)
            robotRojo.seOxido()
            game.schedule(15000, {
                robotRojo.seLubrico()
              
            })
        
        game.schedule(60000, {activo = false})
                
            }
        }
    }


//-------------------------------------------------------------------------------------------

object cortoCircuitoR {
    var property  posicion = game.at(3, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = imagen
    var property  imagen = if(!activo) "descarga.png" else "rojoculdown3cuarto.png"

    method activar() {
        if (!activo) {
        activo = true
        robotAzul.seParalizo()
        game.schedule(60000, {
            activo = false

        })
    }
    }
}

object cortoCircuitoA {
    var property  posicion = game.at(13, 0) // Ajustá según tu pantalla
    var activo = false

    method position() = posicion 
    method image() = if(!activo) "habilidadisp.png" else "azulculdown.png"
    method activar() {
        if (!activo) {
        activo = true
        robotRojo.seParalizo()
        game.schedule(60000, {
            activo = false
        })
    }
    }

}


