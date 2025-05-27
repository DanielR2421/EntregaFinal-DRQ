// Código simplificado para la Visualización del Poema "Viajar" de Gabriel Gamar
// Modo recolección de ramas - versión simplificada

// Variables para las imágenes de fondo
PImage fondoEscena1;  // Escena 1: imagen única con zoom

// GIFs de fondo para cada escena
BackgroundGif gifTinta;
BackgroundGif gifBosque;
BackgroundGif gifMontana;
BackgroundGif gifPajaros;

// Pájaro animado
BirdAnimation pajaro;

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
PImage imagenRama;  // Imagen simple para las ramas

// Variables para transiciones
float alpha = 0;
boolean enTransicion = false;
int siguienteEscena = 0;
float velocidadTransicion = 10;

// Variables para interacción con mouse
float radioInfluencia = 150;

// Variables para música
import processing.sound.*;
SoundFile cancion;

// Instrucciones
String instruccion = "Guía al pájaro con el mouse para recoger las ramas doradas";
boolean mostrarInstruccion = true;
float tiempoInstruccion = 5;

// Variables para las estrofas del poema
String[] estrofas;

// Variables para la transición del texto
float opacidadTexto = 0;
float targetOpacidadTexto = 255;
PFont fuentePoema;

// Variables para efectos visuales
ArrayList<ParticleEffect> efectos;

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
  
  println("=== INICIANDO CARGA DE RECURSOS ===");
  
  // Inicializar sistema de audio
  try {
    cancion = new SoundFile(this, "Das Versprechen.mp3");
    cancion.loop();
    println("Música cargada y reproduciéndose");
  } catch (Exception e) {
    println("No se pudo cargar la música");
  }
  
  // Cargar poema y configurar texto
  cargarPoema();
  setupTexto();
  
  // Cargar imagen de rama (archivo simple: "rama.png")
  imagenRama = cargarImagenConDiagnostico("rama.png");
  if (imagenRama != null) {
    imagenRama.resize(60, 60); // Tamaño fijo para simplicidad
  }
  
  // Cargar imagen única para escena 1
  fondoEscena1 = cargarImagenConDiagnostico("nido1.png");
  if (fondoEscena1 != null) {
    fondoEscena1.resize(width, height);
  }
  
  // Cargar fondos animados
  gifTinta = new BackgroundGif("tinta", 0.05, 1.0);
  gifBosque = new BackgroundGif("bosque", 0.08, 1.0);
  gifMontana = new BackgroundGif("montana", 0.1, 1.2);
  gifPajaros = new BackgroundGif("pajaros", 0.15, 1.1);
  
  // Crear pájaro animado
  pajaro = new BirdAnimation(80);
  
  // Inicializar sistema de ramas y efectos
  ramas = new ArrayList<Rama>();
  efectos = new ArrayList<ParticleEffect>();
  generarRamas();
}

void draw() {
  background(0);
  
  if (!enTransicion) {
    // Dibujar fondo según la escena actual
    dibujarEscena(escenaActual);
    
    // Dibujar y actualizar ramas
    actualizarRamas();
    
    // Actualizar y dibujar pájaro
    pajaro.update();
    pajaro.evadirMouse(mouseX, mouseY, radioInfluencia);
    pajaro.display();
    
    // Verificar colisiones entre pájaro y ramas
    verificarColisiones();
    
    // Actualizar y dibujar efectos de partículas
    actualizarEfectos();
    
    // Mostrar texto del poema en la parte inferior
    mostrarEstrofa();
    
    // Mostrar instrucción si es necesario
    if (mostrarInstruccion) {
      if (tiempoInstruccion > 0) {
        fill(255, 200);
        textAlign(CENTER, TOP);
        textSize(16);
        text(instruccion, width/2, 20);
        tiempoInstruccion -= 1.0/frameRate;
      } else {
        mostrarInstruccion = false;
      }
    }
  } else {
    // Dibujar transición
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
        generarRamas();
      }
    }
  }
}

void setupTexto() {
  fuentePoema = createFont("Georgia", 20);
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
  
  // Mostrar solo los versos recolectados (progreso visual)
  float yTexto = height - 130;
  float espaciadoLinea = 22;
  
  for (int i = 0; i < versos.length; i++) {
    if (i < ramasRecolectadas) {
      // Verso visible - color dorado brillante
      // Sombra
      fill(0, 150 * (opacidadTexto/255.0));
      text(versos[i], width/2 + 2, yTexto + 2);
      
      // Texto principal
      fill(250, 220, 50, opacidadTexto);
      text(versos[i], width/2, yTexto);
    } else {
      // Verso no visible - completamente oculto
      // No se muestra nada
    }
    yTexto += espaciadoLinea;
  }
  
  // Mostrar contador en esquina superior derecha
  fill(255, 255, 255, 200);
  textAlign(RIGHT, TOP);
  textSize(16);
  text("Versos revelados: " + ramasRecolectadas + "/" + versos.length, width - 20, 20);
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
      y = random(60, height - 200); // Evitar la zona del texto
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
  for (int i = ramas.size() - 1; i >= 0; i--) {
    Rama rama = ramas.get(i);
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
        siguienteEscena = (escenaActual + 1) % totalEscenas;
        enTransicion = true;
        alpha = 0;
        opacidadTexto = 0;
        targetOpacidadTexto = 255;
        
        if (siguienteEscena != 0) {
          mostrarInstruccion = true;
          tiempoInstruccion = 3;
        }
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
      if (zoomEscena1 > zoomMinimo) {
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
  println("Cargando " + nombre + "...");
  PImage img = loadImage(nombre);
  if (img == null) {
    println("Error al cargar " + nombre);
  } else {
    println("Imagen " + nombre + " cargada correctamente - Tamaño: " + img.width + "x" + img.height);
  }
  return img;
}

void stop() {
  if (cancion != null) {
    cancion.stop();
  }
}

// ===== CLASES SIMPLIFICADAS =====

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
      } else {
        // Dibujar rama simple si no hay imagen
        stroke(139, 69, 19, alpha);
        strokeWeight(6);
        strokeCap(ROUND);
        line(-20, 0, 20, 0);
        line(-10, -10, 10, 10);
        line(-10, 10, 10, -10);
        
        // Hojas simples
        fill(34, 139, 34, alpha);
        noStroke();
        ellipse(-15, -8, 12, 8);
        ellipse(15, -8, 12, 8);
        ellipse(-15, 8, 12, 8);
        ellipse(15, 8, 12, 8);
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
    
    println("Cargando fondo " + nombre + "...");
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
    
    println("Cargando frames del pájaro...");
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
    
    // Rebotar en los bordes
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
    
    // Mantener velocidad constante
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
