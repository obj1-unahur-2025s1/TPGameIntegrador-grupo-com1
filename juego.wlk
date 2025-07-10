import habilidades.*
import wollok.game.*
import robots.*

object juego {
    const publicoSonido = game.sound("publico.mp3")
    var rondasJugadas = 0
    var rondasGanadasRojo = 0
    var rondasGanadasAzul = 0
    var ganadorFinal = null
    var rondaFinalizada = false

    method verificarGanador() {
    if (robotRojo.estaDerrotado() && robotAzul.estaDerrotado()) {
        self.finDeRonda("empate")
    } else if (robotRojo.estaDerrotado()) {
        self.finDeRonda("azul")
    } else if (robotAzul.estaDerrotado()) {
        self.finDeRonda("rojo")
    }
}

    method finDeRonda(ganador) {
        if (rondaFinalizada) {
            rondaFinalizada = true
        }else {
            marcadorRondas.aumentarRonda()
            rondasJugadas += 1

            if (ganador == "rojo") {
                rondasGanadasRojo += 1
                marcadorRondas.aumentarRondaGanadaRojo()
            } else if (ganador == "azul") {
                rondasGanadasAzul += 1
                marcadorRondas.aumentarRondaGanadaAzul()
            } else if (ganador == "empate") {
                pantallaFinal.mostrarEmpate()
                game.addVisual(pantallaFinal)
                game.schedule(4000, { self.reiniciarRonda() })
            }

        // lógica de victoria...
            if (rondasGanadasAzul == 0 && rondasGanadasRojo == 2){
                ganadorFinal = "rojo"
                self.finDelJuego()
            } else if (rondasGanadasRojo == 0 && rondasGanadasAzul == 2) {
                ganadorFinal = "azul"
                self.finDelJuego()
            } else if (rondasGanadasAzul == 3) {
                ganadorFinal = "azul"
                self.finDelJuego() 
            } else if (rondasGanadasRojo == 3) {
                ganadorFinal = "rojo"
                self.finDelJuego()
            } else if (ganador != "empate") {
                game.schedule(2000, { self.reiniciarRonda() })
            }

        }

    }

    method finDelJuego(){
        const ganadorSoundo = game.sound("victoria.mp3")
        marcadorRondas.reiniciar()
        game.clear()
        if (ganadorFinal == "rojo") {
            pantallaFinal.mostrarFondoRojo()
            ganadorSoundo.play()
            game.addVisual(pantallaFinal)
        } else if (ganadorFinal == "azul") {
            pantallaFinal.mostrarFondoAzul()
            ganadorSoundo.play()
            game.addVisual(pantallaFinal)
        }
        keyboard.y().onPressDo{self.reiniciar()}
        keyboard.n().onPressDo{game.stop()}
        
    }

    method reiniciarRonda() {
        game.clear()
        rondaFinalizada = false
        publicoSonido.stop()
        robotRojo.reiniciar()
        robotAzul.reiniciar()
        sensorR.hayObstaculo(false)
        sensorA.hayObstaculo(false)
        cronometro.reiniciar()
        //vidaRojo.salud(100)
        //vidaAzul.salud(100)
        vidaRojo.imagenActual("Rojo100V2.png")
        vidaAzul.imagenActual("Azul100V2.png")
        pantallaFinal.mostrarImagen(false)
        game.removeVisual(sobrecalentamientoRojo)
        game.removeVisual(oxidacionR)
        game.removeVisual(cortoCircuitoR)
        

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
        //vidaRojo.salud(100)
        //vidaAzul.salud(100)
        vidaRojo.imagenActual("Rojo100V2.png")
        vidaAzul.imagenActual("Azul100V2.png")
        pantallaFinal.mostrarImagen(false)
        menu.activo(true)
        pantallaHabilidadesRojo.eventosConfigurados(false)
        pantallaHabilidadesAzul.eventosConfigurados(false)
        rondasJugadas = 0
        rondasGanadasRojo = 0
        rondasGanadasAzul = 0
        ganadorFinal = null
        game.schedule(500, { menu.iniciar() })
        
    }

    method iniciar(){
        const contar = game.sound("robotic-countdown.mp3")

        game.clear()
        contar.play()
        game.addVisual(fondo3)
        game.schedule(1000, {
            game.clear()
            game.addVisual(fondo2)
            game.schedule(1000, {
                game.clear()
                game.addVisual(fondo1)
                game.schedule(1000, {
                    game.clear()
                    game.addVisual(fondofight)
                    game.schedule(1000, {
                    game.sound("campanaInicial.mp3").play()
                    contar.stop()
                    game.clear()
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
                    keyboard.w().onPressDo {robotRojo.usarHabilidad()}

                    keyboard.k().onPressDo{robotAzul.bloquear()}
                    keyboard.down().onPressDo{robotAzul.agachar()}
                    keyboard.l().onPressDo{robotAzul.golpear()}
                    keyboard.left().onPressDo{robotAzul.moverIzquierda()}
                    keyboard.right().onPressDo{robotAzul.moverDerecha()}
                    keyboard.up().onPressDo {robotAzul.usarHabilidad()}

                    keyboard.y().onPressDo{self.reiniciar()}

                    game.addVisual(enPausa)
                    keyboard.p().onPressDo{enPausa.alternarPausa()}
                    })

                    
                })
        })
        })
        }
    }
    


object fondo3{
    var property image = "fondo_seg3_v2.jpg"
    method position() = game.at(0, 0)   
}
object fondo2 {
    var property image = "fondo_seg2.jpg"
    method position() = game.at(0, 0)  
}
object fondo1 {
    var property image = "fondo_seg1.jpg"
    method position() = game.at(0, 0)  
}
object fondofight {
    var property image = "fondo_fight.jpg"
    method position() = game.at(0, 0)  
}
/*
object menu {
    var property activo = true

    method iniciar(){
        const musica = game.sound("rocky.mp3")
        game.addVisual(pantallaInicio)
        musica.shouldLoop(true)
        game.schedule(1500, {musica.play()}) // Reproduce la música de fondo al iniciar el juego

        keyboard.any().onPressDo({
        if (activo){
            game.schedule(500, {musica.stop()}) // Detiene la música de fondo al iniciar el juego
            game.removeVisual(pantallaInicio)
            game.addVisual(pantallaControles)
            
            activo = false
            //game.schedule(5000, {juego.iniciar()})
            keyboard.enter().onPressDo {           
                game.schedule(500, {pantallaHabilidadesRojo.iniciar()})
                game.removeVisual(pantallaControles)
            }
            
        }
    })
    }
}
*/

object menu {
    var property activo = true
    var property modo = 1
    method iniciar(){
        const musica = game.sound("rocky.mp3")
        game.clear()
        game.addVisual(pantallaInicio)
        musica.shouldLoop(true)
        game.schedule(1500, {musica.play()}) // Reproduce la música de fondo al iniciar el juego
        keyboard.down().onPressDo(
            {
                if (activo) {
                    if (modo == 1) {
                        pantallaInicio.image("pantallaInicial2V2.png")
                        modo = 2
                    } else {
                        pantallaInicio.image("pantallaInicialV2.png")
                        modo = 1
                    }
                }
            }
        )
        keyboard.up().onPressDo(
            {
                if (activo) {
                    if (modo == 1) {
                        pantallaInicio.image("pantallaInicial2V2.png")
                        modo = 2
                    } else {
                        pantallaInicio.image("pantallaInicialV2.png")
                        modo = 1
                    }
                }
            }
        )
        keyboard.enter().onPressDo({
        if (activo){
            game.schedule(500, {musica.stop()}) // Detiene la música de fondo al iniciar el juego
            game.removeVisual(pantallaInicio)
            game.addVisual(pantallaControles)
            
            activo = false

            //inicia solo
            game.schedule(8000, {
                if(modo ==2){
                    pantallaHabilidadesRojo.iniciar() 
                }
                else{
                    juego.iniciar()
                }
                game.removeVisual(pantallaControles)
                
                })




            //iniciar con el enter
            //keyboard.enter().onPressDo {           
            //    game.schedule(500, {if(modo ==2){
           //     pantallaHabilidadesRojo.iniciar() 
            //    }
            //    else
            //    juego.iniciar() })
            //    game.removeVisual(pantallaControles)
           // }
            
        }
    })
    }
}

object enPausa {
    var property pausa = false
    method alternarPausa() {
    pausa = !pausa
    }
    method image() {
        if (pausa) {
        return "controles1.png"
        } else {
        return null
        }
    }
    method position() = game.at(0, 0) 
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
    var property image = "pantallaInicialV2.png"
    method position() = game.at(0, 0)
}

object pantallaControles {
    var property image = "controles1.png"
    method position() = game.at(0, 0)
} 

object pantallaHabilidadesRojo {
    var property imagenActual = "habilidadesR1V3.png"
    const posicion = game.origin()
    var property datoH = 0
    var property eventosConfigurados = false

    method position() = posicion
    method image() = imagenActual

    method iniciar() {
    game.clear()    
    datoH = 0
    self.actualizarImagen()
    game.addVisual(self)

    if (!eventosConfigurados) {
        eventosConfigurados = true  // Lo marcás para no repetir
        keyboard.a().onPressDo { self.cambiarImagen(-1) }
        keyboard.d().onPressDo { self.cambiarImagen(1) }
        keyboard.enter().onPressDo {
            if (datoH == 2) {
                robotRojo.habilidad(sobrecalentamientoRojo)
            } else if (datoH == 1) {
                robotRojo.habilidad(cortoCircuitoR)
            } else if (datoH == 0) {
                robotRojo.habilidad(oxidacionR)
            }       
            game.removeVisual(self)
            pantallaHabilidadesAzul.resetearEventos()
            game.schedule(100, {pantallaHabilidadesAzul.iniciar()})
        }
    }
}

    method cambiarImagen(direccion) {
        datoH = (datoH + direccion).max(0).min(2)  // Rango entre 0 y 2
        self.actualizarImagen()
    }

    method actualizarImagen() {
        if (datoH == 0) {
            imagenActual = "habilidadesR1V3.png"
        } else if (datoH == 1) {
            imagenActual = "habilidadesR2V4.jpg"
        } else if (datoH == 2) {
            imagenActual = "habilidadesR3V4.jpg"
        }
    }
}

object pantallaHabilidadesAzul {
    var property imagenActual = "habilidadesA1V3.png"
    const posicion = game.origin()
    var property datoH = 0
    var property eventosConfigurados = false

    method position() = posicion
    method image() = imagenActual

    method iniciar() {
    game.clear()
    datoH = 0
    self.actualizarImagen()
    game.addVisual(self)

    if (!eventosConfigurados) {
        eventosConfigurados = true  // Lo marcás para no repetir
        keyboard.left().onPressDo { self.cambiarImagen(-1) }
        keyboard.right().onPressDo { self.cambiarImagen(1) }
        keyboard.enter().onPressDo {
            if (datoH == 2) {
                robotAzul.habilidad(sobrecalentamientoAzul)
            } else if (datoH == 1) {
                robotAzul.habilidad(cortoCircuitoA)
            } else if (datoH == 0) {
                robotAzul.habilidad(oxidacionA)
            }       
            game.removeVisual(self)
            juego.iniciar()
        }
    }
}

    method cambiarImagen(direccion) {
        datoH = (datoH + direccion).max(0).min(2)  // Rango entre 0 y 2
        self.actualizarImagen()
    }

    method actualizarImagen() {
        if (datoH == 0) {
            imagenActual = "habilidadesA1V3.png"
        } else if (datoH == 1) {
            imagenActual = "habilidadesA2V4.jpg"
        } else if (datoH == 2) {
            imagenActual = "habilidadesA3V4.jpg"
        }
    }

    method resetearEventos() {
    eventosConfigurados = false
}
}


object cronometro {
    var tiempoRestante = 120
    var property imagenActual = "sec120.png"
    const posicion = game.at(15, 12)  // Ajustá según tu pantalla
    //const sonidoCuentaRegresiva = game.sound("countdown-122700")
    
    method position() = posicion
    method image()=imagenActual   
    
    method actualizarImagen() =
        if (tiempoRestante >= 120) imagenActual = "sec120.png"
        else if (tiempoRestante < 120 && tiempoRestante >= 105) imagenActual = "sec105.png"
        else if (tiempoRestante < 105 && tiempoRestante >= 90) imagenActual = "sec90.png"
        else if (tiempoRestante < 90 && tiempoRestante >= 60) imagenActual = "sec60.png"
        else if (tiempoRestante < 60 && tiempoRestante >= 45) imagenActual = "sec45.png"
        else if (tiempoRestante < 45 && tiempoRestante >= 30) imagenActual = "sec30.png"
        else if (tiempoRestante < 30 && tiempoRestante >= 10) imagenActual = "sec15.png"
        else imagenActual = "sec" + tiempoRestante + ".png"

    method disminuir() {
        if(!robotAzul.estaDerrotado() && !robotRojo.estaDerrotado() && !enPausa.pausa()) {
            if (tiempoRestante > 0) {
            tiempoRestante -= 1
            self.actualizarImagen()
        }
        self.actualizarImagen()
        if (tiempoRestante == 0) {
            game.sound("campanaFinal.mp3").play()
            //juego.finDelJuego()  // cuando se acaba el tiempo, termina la pelea
            juego.finDeRonda("empate")
        }
        }       
    }

    method reiniciar() {
        tiempoRestante = 120
        self.actualizarImagen()
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
