import wollok.game.*
import robots.*

object juego {


    method finDelJuego(){
        game.removeVisual(robotAzul)
        game.removeVisual(robotRojo)
        game.removeVisual(vidaRojo) 
        game.removeVisual(vidaAzul)
        if (robotRojo.estaDerrotado()) {
            pantallaFinal.mostrarFondoAzul()
            game.addVisual(pantallaFinal)
        } else if (robotAzul.estaDerrotado()) {
            pantallaFinal.mostrarFondoRojo()
            game.addVisual(pantallaFinal)
        }
        game.schedule(5000, { game.stop() })  
    }

    method iniciar(){
        

        game.addVisualCharacter(robotAzul)     
        game.addVisualCharacter(robotRojo)
        

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

object pantallaFinal {
    var mostrarImagen = false
    var imagenActual = "fondoOKAzul.jpg"
    const posicionFinal = game.at(0, 0) // esquina superior izquierda

    method position() = posicionFinal

    method image() {
        if (mostrarImagen) return imagenActual
        return null
    }

    method mostrarFondoAzul() {
        imagenActual = "fondoOKAzul.jpg"
        mostrarImagen = true
    }

    method mostrarFondoRojo() {
        imagenActual = "fondoOKRojo3.jpg"
        mostrarImagen = true
    }
}