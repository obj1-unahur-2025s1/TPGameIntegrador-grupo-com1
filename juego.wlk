import wollok.game.*
import robots.*

object juego {
    const publicoSonido = game.sound("publico.mp3")

    method finDelJuego(){
        game.clear()
        if (robotRojo.estaDerrotado()) {
            pantallaFinal.mostrarFondoAzul()
            game.addVisual(pantallaFinal)
        } else if (robotAzul.estaDerrotado()) {
            pantallaFinal.mostrarFondoRojo()
            game.addVisual(pantallaFinal)
        } else {
            pantallaFinal.mostrarEmpate()
            game.addVisual(pantallaFinal)
        }
        keyboard.y().onPressDo{self.reiniciar()}  // Reinicia el juego al presionar 'y'
        keyboard.n().onPressDo{game.stop()}  // Detiene el juego al pres
    }

    method reiniciar() {
    game.clear()
    publicoSonido.stop()                           // Limpia visuales y eventos previos
    robotRojo.reiniciar()                  // Restablece estado del robot rojo
    robotAzul.reiniciar()                  // Restablece estado del robot azul
    sensorR.hayObstaculo(false)
    sensorA.hayObstaculo(false)
    cronometro.reiniciar()                 // Reinicia el cronómetro

    vidaRojo.salud(100)
    vidaAzul.salud(100)
    vidaRojo.imagenActual("Rojo100V2.png")
    vidaAzul.imagenActual("Azul100V2.png")

    pantallaFinal.mostrarImagen(false)    // Oculta pantalla final
    menu.activo(true)
    game.schedule(500, { menu.iniciar() })
}


    method iniciar(){
        game.clear()

        game.sound("campanaInicial.mp3").play()
        
        
        publicoSonido.shouldLoop(true)
        publicoSonido.play()
        
        game.addVisualCharacter(robotAzul)     
        game.addVisualCharacter(robotRojo)
        

        game.addVisual(sensorR) 
        game.addVisual(sensorA)


        game.addVisual(vidaRojo) 
        game.addVisual(vidaAzul)
        game.addVisual(cronometro)
        game.onTick(1000,"tiempo",{ cronometro.disminuir() })  // cada 1000 ms = 1 segundo

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

object menu {
  var property activo = true
  

  method iniciar(){
    const musica = game.sound("rocky.mp3")
    game.addVisual(pantallaInicio)
    musica.shouldLoop(true)
    game.schedule(1000, {musica.play()}) // Reproduce la música de fondo al iniciar el juego

    keyboard.any().onPressDo({
        if (activo){
            game.schedule(500, {musica.stop()}) // Detiene la música de fondo al iniciar el juego
            game.removeVisual(pantallaInicio)
            game.addVisual(pantallaControles)
            activo = false
            game.schedule(5000, {juego.iniciar()})
        }
    })
  }
}

object pantallaFinal {
    var property mostrarImagen = false
    var imagenActual = "ganadorAzul.jpg"
    const posicionFinal = game.at(0, 0) // esquina superior izquierda

    method position() = posicionFinal

    method image() {
        if (mostrarImagen) return imagenActual
        return null
    }

    method mostrarFondoAzul() {
        game.sound("campanaFinal.mp3").play()
        imagenActual = "ganadorAzul.jpg"
        mostrarImagen = true
    }

    method mostrarFondoRojo() {
        game.sound("campanaFinal.mp3").play()
        imagenActual = "ganadorRojo.jpg"
        mostrarImagen = true
    }

    method mostrarEmpate() {
        game.sound("campanaFinal.mp3").play()
        imagenActual = "fondoEmpate.png"
        mostrarImagen = true
    }
}

object pantallaInicio {
  var property image = "pantallaInicial.png"
  method position() = game.at(0, 0)

}

object pantallaControles {
  var property image = "controles.png"
  method position() = game.at(0, 0)

} 

object cronometro {
    var tiempoRestante = 240  // 4 minutos en segundos
    const posicion = game.at(16, 13)  // Ajustá según tu pantalla

    method position() = posicion

    method text() {
        const minutos = (tiempoRestante / 60).truncate(0)
        const segundos = (tiempoRestante % 60).truncate(0)
        const conCero = if (segundos < 10) "0" + segundos.toString() else segundos.toString()
        return minutos.toString() + ":" + conCero
    }

    method textColor() = paleta.rojo()
    

    method disminuir() {
        if (tiempoRestante > 0) {
            tiempoRestante -= 1
        }
        if (tiempoRestante == 0) {
            game.sound("campanaFinal.mp3").play()
            //juego.finDelJuego()  // cuando se acaba el tiempo, termina la pelea
            juego.finDelJuego()
        }
    }

    method reiniciar() {
        tiempoRestante = 240
    }
}