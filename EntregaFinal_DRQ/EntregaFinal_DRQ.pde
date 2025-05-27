// Código Finalizado para la Visualización del Poema "Viajar" de Gabriel Gamar
// Variables para las imágenes de fondo; las imagenese de fondo yo las dibuje en illustrator con ayuda de la ia, o calco de imagen la cual des pues yo edite para que se adaptara a mi concepto
// El programa se demora un poco en iniciar porque es algo pesado
//La calidad de la vizualización es terrible por alguna razón desde la ultima actualización de processing, no rederiza bien la imagenes pero no entindo porque
PImage fondoEscena1;

// GIFs de fondo para cada escena; Para entender el funcionamiento de los gifs me ayudo una amiga de otra sección, al igual que la ia porque tiene que funcionar como una animación stop motion
BackgroundGif gifTinta;
BackgroundGif gifBosque;
BackgroundGif gifMontana;
BackgroundGif gifPajaros;

// Pájaro animado
BirdAnimation pajaro;

//VAribales del numero total de escenas
int escenaActual = 0;
int totalEscenas = 5;

// Variables para el zoom de la escena 1
float zoomEscena1 = 2.5;
float zoomMinimo = 1.0;
float velocidadZoom = 0.008;

// Variables para las ramas recolectables
ArrayList<Rama> ramas;
int ramasNecesarias = 5;
int ramasRecolectadas = 0;
PImage imagenRama;

// Variables para transiciones (esto me ayudo la ia para facilitarme el trabajo
float alpha = 0;
boolean enTransicion = false;
int siguienteEscena = 0;
float velocidadTransicion = 10;

// Variables para interacción con mouse; la ia me ayudo con esto para que se viera fluido y sin errores
float radioInfluencia = 150;

// Variables para música; esto me base en la entrega 5 del sonido para darle ambientar el poema con una musica que fuera siguiera esta tematica poetica
import processing.sound.*;
SoundFile cancion;

// Variables para las estrofas del poema
String[] estrofas;

// Variables para la transición del texto
float opacidadTexto = 0;
float targetOpacidadTexto = 255;
PFont fuentePoema;

// Variables para efectos visuales; para esto me ayudo la ia ya que es un efecto visual para volver mas interactivo el funcionamiento del programa
ArrayList<ParticleEffect> efectos;

// Variables para pantalla de carga; la ia me ayudo a cuadrar la funcion de la fuente porque si no yo no pude cuadrar la fuente que me cuadrara con la estetica de programa
boolean pantallaInicial = true;
boolean juegoIniciado = false;
PFont fuenteTitulo, fuenteInstrucciones;
float parpadeoBoton = 0;

// Variables para pantalla final
boolean mostrandoFin = false;
float tiempoFin = 0;
float duracionFin = 180; // 3 segundos a 60fps

//Este es el void para cada escena de poema el cual se relaciona con cada una de las 5 estofas
void cargarPoema() {
  estrofas = new String[totalEscenas];
  estrofas[0] = "Viajar es marcharse de casa,\n" +
                "es dejar los amigos,\n" +
                "es intentar volar.\n" +
                "Volar conociendo otras ramas,\n" +
                "recorriendo caminos,\n" +
                "es intentar cambiar.";
  
  estrofas[1] = "Viajar es vestirse de loco,\n" +
                "es decir \"no me importa\",\n" +
                "es querer regresar.\n" +
                "Regresar valorando lo poco,\n" +
                "saboreando una copa,\n" +
                "es desear empezar.";
  
  estrofas[2] = "Viajar es sentirse poeta,\n" +
                "escribir una carta,\n" +
                "es querer abrazar.\n" +
                "Abrazar al llegar a una puerta,\n" +
                "añorando la calma,\n" +
                "es besarse y partir.";
  
  estrofas[3] = "Viajar es volverse mundano,\n" +
                "es conocer otra gente,\n" +
                "es volver a empezar.\n" +
                "Empezar extendiendo la mano,\n" +
                "aprendiendo del fuerte,\n" +
                "es sentir soledad.";
  
  estrofas[4] = "Viajar es marcharse de casa,\n" +
                "es vestirse de loco,\n" +
                "diciendo todo y nada con una postal.\n" +
                "Es dormir en otra cama,\n" +
                "sentir que el tiempo es corto,\n" +
                "viajar es regresar.";
}

void setup() {
  size(800, 600);
  imageMode(CENTER);
  smooth(4);
  
  // Inicializar sistema de audio; me base en mi entrega 5; aunque el verificador catch me lo ayudo a cuadrar la ai para verificar el funcionamiento correcto del archivo de la canción; esto mismo aplica para las imagenes ya que son demasiados archivos los que permiten ejecutar los gifs por lo que la ia me ayudo a cuadrarlos de mejor manera
  try {
    cancion = new SoundFile(this, "Das Versprechen.mp3");
  } catch (Exception e) {
    println("No se pudo cargar la música");
  }
  
  // Cargar poema y configurar texto
  cargarPoema();
  setupTexto();
  
  // Cargar imagen de rama
  imagenRama = cargarImagenConDiagnostico("rama.png");
  if (imagenRama != null) {
    imagenRama.resize(60, 60);
  }
  
  // Cargar imagen única para escena 1
  fondoEscena1 = cargarImagenConDiagnostico("nido1.png");
  if (fondoEscena1 != null) {
    fondoEscena1.resize(width, height);
  }
  
  // Cargar fondos animados; la ia y una amiga de otra seccion me explicaron como se pueden transformar la imagenes en gifs tipo stop motion; los numero de abajo son el zoom que tienen las imagenes al para que cuadren en la pantalla al igual que cada cuanto rotan las imagenes para que se vea del tipo stop motion
  gifTinta = new BackgroundGif("tinta", 0.05, 1.0);
  gifBosque = new BackgroundGif("bosque", 0.08, 1.0);
  gifMontana = new BackgroundGif("montana", 0.1, 1.2);
  gifPajaros = new BackgroundGif("pajaros", 0.15, 1.1);
  
  // Crear pájaro animado; este pajaro sigue la misma dinamica que el fondo solo que se manipula con un evento del mouse; la ia me ayudo a perfeccionar el funcionamiento del pajaro porque en la pre entrega era muy trabado y precario
  pajaro = new BirdAnimation(80);
  
  // Inicializar sistema de ramas y efectos; esto me lo ayudo a cuadrar la ia para que fuear similar a cuando uno recoje las mondas den algun videojuego de supermario, y con esto se van desbloqueando los versos del poema que permiten que uno avance
  ramas = new ArrayList<Rama>();
  efectos = new ArrayList<ParticleEffect>();
  generarRamas();
}

void draw() {
  background(0);
  
  if (pantallaInicial) {
    mostrarPantallaInicial();
  } else if (mostrandoFin) {
    mostrarPantallaFin();
  } else if (!enTransicion) {
    // Dibujo del fondo según la escena actual
    dibujarEscena(escenaActual);
    
    if (juegoIniciado) {
      // Dibujo y actualizacion de las ramas
      actualizarRamas();
      
      // Actualizacion y dibujo del pájaro (para el stop motion
      pajaro.update();
      pajaro.evadirMouse(mouseX, mouseY, radioInfluencia);
      pajaro.display();
      
      // Verificar colisiones entre pájaro y ramas; la ia me ayudo a cuadrar esto
      verificarColisiones();
      
      // Actualizar y dibujar efectos de partículas
      actualizarEfectos();
      
      // Mostrar texto del poema en la parte inferior
      mostrarEstrofa();
    }
  } else {
    // Dibujar transición; la ia le ayudo a perfeccionar el funcinamiento de esta parte sin tanto problema
    if (alpha < 255) {
      dibujarEscena(escenaActual);
      fill(0, alpha);
      rect(0, 0, width, height);
      alpha += velocidadTransicion;
    } else if (alpha < 510) {
      dibujarEscena(siguienteEscena);
      fill(0, 510 - alpha);
      rect(0, 0, width, height);
      alpha += velocidadTransicion;
      
      if (alpha >= 510) {
        enTransicion = false;
        escenaActual = siguienteEscena;
        alpha = 0;
        ramasRecolectadas = 0;
        
        // Si completamos todas las escenas, mostrar pantalla final
        if (escenaActual >= totalEscenas) {
          mostrandoFin = true;
          tiempoFin = 0;
          juegoIniciado = false;
        } else {
          generarRamas();
        }
      }
    }
  }
}

void mostrarPantallaFin() {
  // Mostrar fondo de la última escena
  if (gifPajaros != null) {
    gifPajaros.display();
  }
  
  // Overlay semi-transparente con gradiente
  noStroke();
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0.3, 0.8);
    float alphaGrad = lerp(0, 220, inter);
    fill(0, alphaGrad);
    rect(0, y, width, 1);
  }
  
 //Textos clave aparte de las estrofas y sus escenas 
  // TEXTO "FIN" con sombra estilo título
  textFont(fuenteTitulo);
  textAlign(CENTER, CENTER);
  
  // Sombra del título
  fill(0, 200);
  for (int j = 0; j < 360; j += 45) {
    float rad = radians(j);
    textSize(72);
    text("FIN", 
         width/2 + cos(rad) * 4,
         height/2 + sin(rad) * 4);
  }
  
  // Título principal
  fill(255, 255, 255);
  textSize(72);
  text("FIN", width/2, height/2);
  
  // Incrementar contador de tiempo
  tiempoFin++;
  
  // Después del tiempo especificado, volver al menú inicial
  if (tiempoFin >= duracionFin) {
    escenaActual = 0;
    pantallaInicial = true;
    mostrandoFin = false;
    juegoIniciado = false;
    if (cancion != null) {
      cancion.stop();
    }
  }
}

void mostrarPantallaInicial() {
  // Mostrar fondo de la escena 1 con zoom fijo
  if (fondoEscena1 != null) {
    float anchoZoom = width * zoomEscena1;
    float altoZoom = height * zoomEscena1;
    imageMode(CENTER);
    image(fondoEscena1, width/2, height/2, anchoZoom, altoZoom);
  }
  
  // Overlay semi-transparente con gradiente
  noStroke();
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0.3, 0.8);
    fill(0, inter * 180);
    rect(0, y, width, 1);
  }
  
  // TÍTULO DEL POEMA con sombra
  textFont(fuenteTitulo);
  textAlign(CENTER, CENTER);
  
  // Sombra del título
  fill(0, 200);
  for (int j = 0; j < 360; j += 45) {
    float rad = radians(j);
    textSize(52);
    text("VIAJAR", 
         width/2 + cos(rad) * 3,
         height/2 - 120 + sin(rad) * 3);
  }
  
  // Título principal
  fill(255, 255, 255);
  textSize(52);
  text("VIAJAR", width/2, height/2 - 120);
  
  // Sombra del autor
  fill(0, 150);
  for (int j = 0; j < 360; j += 45) {
    float rad = radians(j);
    textSize(22);
    text("por Gabriel Gamar", 
         width/2 + cos(rad) * 2,
         height/2 - 80 + sin(rad) * 2);
  }
  
  // Autor
  textSize(22);
  fill(220, 220, 220);
  text("por Gabriel Gamar", width/2, height/2 - 80);
  
  // BOTÓN PLAY
  parpadeoBoton += 0.1;
  float alphaBoton = 200 + sin(parpadeoBoton) * 55;
  
  // Fondo del botón con glow; esto es pura estetica
  fill(50, 150, 250, alphaBoton * 0.3);
  noStroke();
  ellipse(width/2, height/2, 240, 80);
  
  fill(50, 150, 250, alphaBoton * 0.8);
  stroke(255, alphaBoton);
  strokeWeight(3);
  rectMode(CENTER);
  rect(width/2, height/2, 200, 60, 15);
  
  // Sombra del texto del botón
  fill(0, alphaBoton * 0.8);
  noStroke();
  textFont(fuentePoema);
  textSize(24);
  for (int j = 0; j < 360; j += 90) {
    float rad = radians(j);
    text("COMENZAR", 
         width/2 + cos(rad) * 2,
         height/2 + sin(rad) * 2);
  }
  
  // Texto del botón
  fill(255, alphaBoton);
  text("COMENZAR", width/2, height/2);
  
  // INSTRUCCIONES con sombra
  textFont(fuenteInstrucciones);
  textAlign(CENTER, CENTER);
  textSize(16);
  
  String instrucciones = "INSTRUCCIONES:\n\n" +
                        "• Guía al pájaro con el cursor del mouse\n" +
                        "• El pájaro evadirá tu cursor automáticamente\n" +
                        "• Recolecta las ramas para revelar los versos\n" +
                        "• Completa cada escena para avanzar a la siguiente\n";
  
  // Sombra de las instrucciones
  fill(0, 180);
  for (int j = 0; j < 360; j += 90) {
    float rad = radians(j);
    text(instrucciones, 
         width/2 + cos(rad) * 2,
         height/2 + 120 + sin(rad) * 2);
  }
  
  // Texto principal de instrucciones
  fill(240, 240, 240);
  text(instrucciones, width/2, height/2 + 120);
  
  // Indicación adicional con sombra
  textSize(14);
  
  // Sombra
  fill(0, 150);
  for (int j = 0; j < 360; j += 90) {
    float rad = radians(j);
    text("Haz clic en COMENZAR para iniciar la experiencia", 
         width/2 + cos(rad) * 1,
         height - 40 + sin(rad) * 1);
  }
  
  // Texto principal
  fill(200, 200, 200);
  text("Haz clic en COMENZAR para iniciar la experiencia", width/2, height - 40);
}

void mousePressed() {
  if (pantallaInicial) {
    // Verificar si se hizo clic en el botón
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
        mouseY > height/2 - 30 && mouseY < height/2 + 30) {
      pantallaInicial = false;
      juegoIniciado = true;
      
      // Iniciar música
      if (cancion != null) {
        cancion.loop();
      }
      
      // Resetear variables del juego
      escenaActual = 0;
      ramasRecolectadas = 0;
      generarRamas();
      pajaro.reset();
      opacidadTexto = 0;
      targetOpacidadTexto = 255;
    }
  }
}

void setupTexto() {
  fuentePoema = createFont("Georgia", 24, true);
  fuenteTitulo = createFont("Georgia", 48, true);
  fuenteInstrucciones = createFont("Arial", 16, true);
}

void mostrarEstrofa() {
  // Actualizar opacidad con transición suave
  opacidadTexto = lerp(opacidadTexto, targetOpacidadTexto, 0.1);
  
  // Fondo degradado para el texto
  rectMode(CORNER);
  noStroke();
  
  // Gradiente vertical
  for (int y = height - 180; y < height; y++) {
    float inter = map(y, height - 180, height, 0, 1);
    float alphaGrad = lerp(0, 220, inter);
    fill(0, alphaGrad * (opacidadTexto/255.0));
    rect(0, y, width, 1);
  }
  
  // Dividir estrofa en versos
  String[] versos = dividirEnVersos(estrofas[escenaActual]);
  
  textFont(fuentePoema);
  textAlign(CENTER, CENTER);
  
  // Mostrar solo los versos recolectados
  float yTexto = height - 130;
  float espaciadoLinea = 22;
  
  for (int i = 0; i < versos.length; i++) {
    if (i < ramasRecolectadas) {
      // Sombra negra para contraste
      fill(0, 200 * (opacidadTexto/255.0));
      for (int j = 0; j < 360; j += 45) {
        float rad = radians(j);
        text(versos[i], 
             width/2 + cos(rad) * 2,
             yTexto + sin(rad) * 2);
      }
      
      // Texto principal blanco brillante
      fill(255, 255, 255, opacidadTexto);
      text(versos[i], width/2, yTexto);
    }
    yTexto += espaciadoLinea;
  }
}

String[] dividirEnVersos(String estrofa) {
  return estrofa.split("\\n");
}

void generarRamas() {
  ramas.clear();
  
  // Número de ramas = número de versos en la estrofa actual
  String[] versos = dividirEnVersos(estrofas[escenaActual]);
  ramasNecesarias = versos.length;
  
  // Generar ramas distribuidas por la pantalla
  for (int i = 0; i < ramasNecesarias; i++) {
    float x, y;
    boolean posicionValida;
    int intentos = 0;
    
    do {
      x = random(60, width - 60);
      y = random(60, height - 200);
      posicionValida = true;
      
      // Verificar que no esté muy cerca de otras ramas
      for (Rama rama : ramas) {
        if (dist(x, y, rama.x, rama.y) < 80) {
          posicionValida = false;
          break;
        }
      }
      
      // Verificar que no esté muy cerca del pájaro
      if (dist(x, y, pajaro.x, pajaro.y) < 100) {
        posicionValida = false;
      }
      
      intentos++;
    } while (!posicionValida && intentos < 50);
    
    ramas.add(new Rama(x, y));
  }
}

void actualizarRamas() {
  for (Rama rama : ramas) {
    rama.update();
    rama.display();
  }
}

void verificarColisiones() {
  for (int i = ramas.size() - 1; i >= 0; i--) {
    Rama rama = ramas.get(i);
    float distancia = dist(pajaro.x, pajaro.y, rama.x, rama.y);
    
    if (distancia < 40 && rama.activa) {
      rama.activa = false;
      ramasRecolectadas++;
      
      // Crear efecto de partículas
      efectos.add(new ParticleEffect(rama.x, rama.y));
      
      // Verificar si se completó la escena
      if (ramasRecolectadas >= ramasNecesarias) {
        siguienteEscena = (escenaActual + 1);
        enTransicion = true;
        alpha = 0;
        opacidadTexto = 0;
        targetOpacidadTexto = 255;
      }
    }
  }
}

void actualizarEfectos() {
  for (int i = efectos.size() - 1; i >= 0; i--) {
    ParticleEffect efecto = efectos.get(i);
    efecto.update();
    efecto.display();
    
    if (efecto.terminado()) {
      efectos.remove(i);
    }
  }
}

void dibujarEscena(int escena) {
  if (escena == 0) {
    if (fondoEscena1 != null) {
      if (zoomEscena1 > zoomMinimo && juegoIniciado) {
        zoomEscena1 -= velocidadZoom;
        zoomEscena1 = max(zoomEscena1, zoomMinimo);
      }
      
      float anchoZoom = width * zoomEscena1;
      float altoZoom = height * zoomEscena1;
      imageMode(CENTER);
      image(fondoEscena1, width/2, height/2, anchoZoom, altoZoom);
    }
  } else {
    switch(escena) {
      case 1: 
        if (gifTinta != null) gifTinta.display(); 
        break;
      case 2: 
        if (gifBosque != null) gifBosque.display(); 
        break;
      case 3: 
        if (gifMontana != null) gifMontana.display();
        break;
      case 4: 
        if (gifPajaros != null) gifPajaros.display(); 
        break;
    }
  }
}

PImage cargarImagenConDiagnostico(String nombre) {
  PImage img = loadImage(nombre);
  return img;
}

void stop() {
  if (cancion != null) {
    cancion.stop();
  }
}

// Clases de cada objeto interactivo

class Rama {
  float x, y;
  float animacion;
  boolean activa;
  float alpha;
  
  Rama(float x, float y) {
    this.x = x;
    this.y = y;
    this.animacion = random(TWO_PI);
    this.activa = true;
    this.alpha = 255;
  }
  
  void update() {
    if (activa) {
      animacion += 0.08;
    } else {
      alpha = max(0, alpha - 15);
    }
  }
  
  void display() {
    if (activa || alpha > 0) {
      pushMatrix();
      translate(x, y + sin(animacion) * 3);
      
      // Resplandor dorado
      fill(250, 220, 50, 60);
      noStroke();
      ellipse(0, 0, 80, 80);
      
      // Dibujar imagen de rama si está cargada
      if (imagenRama != null) {
        tint(255, alpha);
        imageMode(CENTER);
        image(imagenRama, 0, 0);
        noTint();
      }
      
      popMatrix();
    }
  }
}

class ParticleEffect {
  ArrayList<Particle> particulas;
  float vida;
  
  ParticleEffect(float x, float y) {
    particulas = new ArrayList<Particle>();
    vida = 60;
    
    for (int i = 0; i < 10; i++) {
      particulas.add(new Particle(x, y));
    }
  }
  
  void update() {
    vida--;
    for (int i = particulas.size() - 1; i >= 0; i--) {
      Particle p = particulas.get(i);
      p.update();
      if (p.terminada()) {
        particulas.remove(i);
      }
    }
  }
  
  void display() {
    for (Particle p : particulas) {
      p.display();
    }
  }
  
  boolean terminado() {
    return vida <= 0 && particulas.size() == 0;
  }
}

class Particle {
  float x, y;
  float vx, vy;
  float vida;
  color col;
  
  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    float angulo = random(TWO_PI);
    float velocidad = random(2, 6);
    this.vx = cos(angulo) * velocidad;
    this.vy = sin(angulo) * velocidad;
    this.vida = 30;
    this.col = color(random(200, 255), random(180, 220), random(0, 100));
  }
  
  void update() {
    x += vx;
    y += vy;
    vy += 0.2;
    vida--;
    vx *= 0.98;
  }
  
  void display() {
    float alpha = map(vida, 0, 30, 0, 255);
    fill(red(col), green(col), blue(col), alpha);
    noStroke();
    ellipse(x, y, 4, 4);
  }
  
  boolean terminada() {
    return vida <= 0;
  }
}

class BackgroundGif {
  PImage[] frames;
  float currentFrame;
  String nombre;
  float velocidad;
  
  BackgroundGif(String nombre, float velocidad, float escala) {
    this.nombre = nombre;
    this.velocidad = velocidad;
    frames = new PImage[5];
    
    for (int i = 0; i < 5; i++) {
      frames[i] = loadImage(nombre + (i+1) + ".png");
      if (frames[i] != null) {
        float imgRatio = (float)frames[i].width / frames[i].height;
        float screenRatio = (float)width / height;
        
        int newWidth, newHeight;
        if (imgRatio > screenRatio) {
          newHeight = height;
          newWidth = (int)(height * imgRatio);
        } else {
          newWidth = width;
          newHeight = (int)(width / imgRatio);
        }
        
        newWidth = (int)(newWidth * escala);
        newHeight = (int)(newHeight * escala);
        
        frames[i].resize(newWidth, newHeight);
      }
    }
    currentFrame = 0;
  }
  
  void display() {
    int frameIndex = floor(currentFrame);
    if (frames[frameIndex] != null) {
      imageMode(CENTER);
      image(frames[frameIndex], width/2, height/2);
      currentFrame = (currentFrame + velocidad) % frames.length;
    }
  }
}

class BirdAnimation {
  PImage[] frames;
  float x, y;
  float velocidadX, velocidadY;
  float currentFrame;
  float tamano;
  float anguloActual;
  float velocidadBase = 2;
  
  BirdAnimation(float tamano) {
    this.tamano = tamano;
    frames = new PImage[5];
    currentFrame = 0;
    anguloActual = 0;
    
    for (int i = 0; i < 5; i++) {
      frames[i] = cargarImagenConDiagnostico("pajaro" + (i+1) + ".png");
      if (frames[i] != null) {
        frames[i].resize(int(tamano), int(tamano));
      }
    }
    
    reset();
  }
  
  void update() {
    currentFrame = (currentFrame + 0.2) % frames.length;
    
    x += velocidadX;
    y += velocidadY;
    
    // Rebotar en los bordes; esto me lo ayudo a cuadrar mejor la ia porque en la pre entrega estaba mal cuadrado y era muy confuso y se trababa facil
    if (x <= tamano/2) {
      x = tamano/2;
      velocidadX = abs(velocidadX);
    }
    if (x >= width - tamano/2) {
      x = width - tamano/2;
      velocidadX = -abs(velocidadX);
    }
    if (y <= tamano/2) {
      y = tamano/2;
      velocidadY = abs(velocidadY);
    }
    if (y >= height - tamano/2) {
      y = height - tamano/2;
      velocidadY = -abs(velocidadY);
    }
    
    // Mantener velocidad constante; esto tambien me lo ajusto la ia porque fue un dolor de cabeza ajustralo yo porque todos se me descuadraban
    float velocidadActual = sqrt(velocidadX*velocidadX + velocidadY*velocidadY);
    if (velocidadActual < 0.5) {
      float angulo = random(TWO_PI);
      velocidadX = cos(angulo) * velocidadBase;
      velocidadY = sin(angulo) * velocidadBase;
    } else if (velocidadActual != velocidadBase) {
      float factor = velocidadBase / velocidadActual;
      velocidadX *= factor;
      velocidadY *= factor;
    }
    
    // Actualizar ángulo
    if (abs(velocidadX) > 0.1 || abs(velocidadY) > 0.1) {
      float anguloObjetivo = atan2(velocidadY, velocidadX);
      float diferencia = anguloObjetivo - anguloActual;
      while (diferencia > PI) diferencia -= TWO_PI;
      while (diferencia < -PI) diferencia += TWO_PI;
      anguloActual += diferencia * 0.1;
    }
  }
  
  void display() {
    if (frames[floor(currentFrame)] != null) {
      pushMatrix();
      translate(x, y);
      rotate(anguloActual);
      imageMode(CENTER);
      image(frames[floor(currentFrame)], 0, 0);
      popMatrix();
    }
  }
  
  void reset() {
    x = width/2;
    y = height/2;
    float angulo = random(TWO_PI);
    velocidadX = cos(angulo) * velocidadBase;
    velocidadY = sin(angulo) * velocidadBase;
    currentFrame = 0;
  }
  
  void evadirMouse(float mx, float my, float radio) {
    float dx = x - mx;
    float dy = y - my;
    float distancia = sqrt(dx*dx + dy*dy);
    
    if (distancia < radio) {
      float factor = (radio - distancia) / radio * 0.2;
      velocidadX += (dx/distancia) * factor;
      velocidadY += (dy/distancia) * factor;
    }
  }
}
