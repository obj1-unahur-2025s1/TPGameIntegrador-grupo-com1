import wollok.game.*
import robots.*

object juego {
    const publicoSonido = game.sound("publico.mp3")
    var rondasJugadas = 0
    var rondasGanadasRojo = 0
    var rondasGanadasAzul = 0
    var ganadorFinal = null

    method finDeRonda(ganador) {
        marcadorRondas.aumentarRonda()
        rondasJugadas += 1
        if (ganador == "rojo") {
            rondasGanadasRojo += 1
            marcadorRondas.aumentarRondaGanadaRojo()
            /*
            vidaRojo.salud(100)
            vidaRojo.imagenActual("Rojo100V2.png")
            vidaAzul.salud(0)
            vidaAzul.imagenActual("Azul0V2.png")
            */
        } else if (ganador == "azul") {
            rondasGanadasAzul += 1
            marcadorRondas.aumentarRondaGanadaAzul()
            /*
            vidaAzul.salud(100)
            vidaAzul.imagenActual("Azul100V2.png")
            vidaRojo.salud(0)
            vidaRojo.imagenActual("Rojo0V2.png")
            */
        } else if (ganador == "empate") {
            pantallaFinal.mostrarEmpate()
            game.addVisual(pantallaFinal)
            game.schedule(4000, { self.reiniciarRonda() })
        }

        // Chequeo si hay un ganador final
        if (rondasJugadas == 2 && rondasGanadasRojo == 2){
            ganadorFinal = "rojo"
            self.finDelJuego()
        } else if (rondasJugadas == 2 && rondasGanadasAzul == 2) {
            ganadorFinal = "azul"
            self.finDelJuego()
        } else if (rondasGanadasAzul == 3) {
            ganadorFinal = "azul"
            self.finDelJuego() 
        } else if (rondasGanadasRojo == 3) {
            ganadorFinal = "rojo"
            self.finDelJuego()

            // en Caso de Empate (ningún jugador ganó 3 rondas)
        } else if (ganador != "empate"){
            game.schedule(2000, { self.reiniciarRonda() })
        }

/*
        if (rondasJugadas >= maxRondas) {
            ganadorFinal = ganador   // <--- Esto ya está bien
            self.finDelJuego()
        } else {
            game.schedule(2000, { self.reiniciarRonda() })
        }
    }

        if (rondasJugadas >= maxRondas) {
            if (rondasGanadasRojo > rondasGanadasAzul) {
                ganadorFinal = "rojo"
            } else if (rondasGanadasAzul > rondasGanadasRojo) {
                ganadorFinal = "azul"
            } else {
                ganadorFinal = "empate"
            }
            self.finDelJuego()
        } else {
            game.schedule(2000, { self.reiniciarRonda() })
        }
*/
    }
    method finDelJuego(){
        marcadorRondas.reiniciar()
        game.clear()
        if (ganadorFinal == "rojo") {
            pantallaFinal.mostrarFondoRojo()
            game.addVisual(pantallaFinal)
        } else if (ganadorFinal == "azul") {
            pantallaFinal.mostrarFondoAzul()
            game.addVisual(pantallaFinal)
        }
        keyboard.y().onPressDo{self.reiniciar()}
    }

    method reiniciarRonda() {
        game.clear()
        publicoSonido.stop()
        robotRojo.reiniciar()
        robotAzul.reiniciar()
        sensorR.hayObstaculo(false)
        sensorA.hayObstaculo(false)
        cronometro.reiniciar()
        vidaRojo.salud(100)
        vidaAzul.salud(100)
        vidaRojo.imagenActual("Rojo100V2.png")
        vidaAzul.imagenActual("Azul100V2.png")
        pantallaFinal.mostrarImagen(false)
        // NO reiniciar el marcador de rondas ni el contador de rondasJugadas

        // Volver a agregar los visuales y eventos
        self.iniciar()
    }

    method reiniciar() {
        marcadorRondas.reiniciar()
        game.clear()
        publicoSonido.stop()
        robotRojo.reiniciar()
        robotAzul.reiniciar()
        sensorR.hayObstaculo(false)
        sensorA.hayObstaculo(false)
        cronometro.reiniciar()
        vidaRojo.salud(100)
        vidaAzul.salud(100)
        vidaRojo.imagenActual("Rojo100V2.png")
        vidaAzul.imagenActual("Azul100V2.png")
        pantallaFinal.mostrarImagen(false)
        menu.activo(true)
        rondasJugadas = 0
        ganadorFinal = null
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
        game.addVisual(marcadorRondas)
        game.onTick(1000,"tiempo",{cronometro.disminuir()})

        game.whenCollideDo(sensorR, { elemento =>
            if (!elemento.esRojo()) {
                sensorR.hayObstaculo(true)
                game.schedule(100, { sensorR.hayObstaculo(false) })
            }
        })
        game.whenCollideDo(sensorA, { elemento =>
            if (!elemento.esAzul()) {
                sensorA.hayObstaculo(true)
                game.schedule(100, { sensorA.hayObstaculo(false) })
            }
        })

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
    var tiempoRestante = 30  // 4 minutos en segundos
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
        if(!robotAzul.estaDerrotado() && !robotRojo.estaDerrotado()) {
            if (tiempoRestante > 0) {
            tiempoRestante -= 1
        }
        if (tiempoRestante == 0) {
            game.sound("campanaFinal.mp3").play()
            //juego.finDelJuego()  // cuando se acaba el tiempo, termina la pelea
            juego.finDeRonda("empate")
        }
        }       
    }

    method reiniciar() {
        tiempoRestante = 30
    }
}
object marcadorRondas {
    var rondas = 0
    var rondasGanadasRojo = 0
    var rondasGanadasAzul = 0

    const posicion = game.at(15, 0)  // Ajustá según tu pantalla

    method position() = posicion

    method text() {
        return "Rondas Rojo: " + rondasGanadasRojo.toString() + " Rondas Azul: " + rondasGanadasAzul.toString()
    }

    method textColor() = paleta.rojo()

    method aumentarRonda() {
        rondas += 1
    }
    method aumentarRondaGanadaRojo() {
        rondasGanadasRojo += 1
    }
    method aumentarRondaGanadaAzul() {
        rondasGanadasAzul += 1
    }

    method reiniciar() {
        rondasGanadasRojo = 0
        rondasGanadasAzul = 0
        rondas = 0
    }
}