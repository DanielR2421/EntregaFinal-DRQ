// Código corregido para la Visualización del Poema "Viajar" de Gabriel Gamar

// Variables para las imágenes de fondo
PImage fondoEscena1;  // Escena 1: imagen única con zoom

// GIFs de fondo para cada escena
BackgroundGif gifTinta;
BackgroundGif gifBosque;
BackgroundGif gifMontana;
BackgroundGif gifPajaros;

// Pájaro animado (independiente de los fondos)
BirdAnimation pajaro;

int escenaActual = 0;
int totalEscenas = 5;

// Variables para el zoom de la escena 1
float zoomEscena1 = 2.5;
float zoomMinimo = 1.0;
float velocidadZoom = 0.008;

// Variables para los símbolos interactivos
float[][] posicionesSimbolo;
int tamanoSimbolo = 30;

// Variables para transiciones
float alpha = 0;  // Opacidad para fade
boolean enTransicion = false;
int siguienteEscena = 0;
float velocidadTransicion = 10;

// Variables para interacción con mouse
float radioInfluencia = 150;
float factorRepulsion = 0.5;

// Variables para música
import processing.sound.*;
SoundFile cancion;

// Instrucciones
String instruccion = "Haz clic en el círculo dorado para continuar";
boolean mostrarInstruccion = true;
float tiempoInstruccion = 5;  // segundos que se muestra

// Variables para las estrofas del poema
String[] estrofas;

// Variables para la transición del texto
float opacidadTexto = 0;
float targetOpacidadTexto = 255;
PFont fuentePoema;

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
  smooth(4);  // Mejorar calidad de renderizado
  
  println("=== INICIANDO CARGA DE RECURSOS ===");
  
  // Inicializar sistema de audio
  try {
    cancion = new SoundFile(this, "Das Versprechen.mp3"); // Asegúrate de tener este archivo
    cancion.loop(); // Reproducir en bucle
    println("Música cargada y reproduciéndose");
  } catch (Exception e) {
    println("No se pudo cargar la música - verifica que tengas 'cancion.mp3' en la carpeta del sketch");
    println("Error: " + e.getMessage());
  }
  
  // Cargar poema y configurar texto
  cargarPoema();
  setupTexto();
  
  // Cargar imagen única para escena 1
  fondoEscena1 = cargarImagenConDiagnostico("nido1.png");
  if (fondoEscena1 != null) {
    fondoEscena1.resize(width, height);
  }
  
  // Cargar fondos animados con diferentes velocidades
  gifTinta = new BackgroundGif("tinta", 0.05, 1.0);    // Más lento
  gifBosque = new BackgroundGif("bosque", 0.08, 1.0);  // Lento
  gifMontana = new BackgroundGif("montana", 0.1, 1.2);  // Medio, escalado a 1.2
  gifPajaros = new BackgroundGif("pajaros", 0.15, 1.1); // Normal, escalado a 1.1
  
  // Crear pájaro animado
  pajaro = new BirdAnimation(80);  // Tamaño del pájaro: 80 píxeles
  
  // Inicializar símbolos
  posicionesSimbolo = new float[totalEscenas][2];
  for (int i = 0; i < totalEscenas; i++) {
    posicionesSimbolo[i][0] = width - 50;  // X
    posicionesSimbolo[i][1] = height - 50;  // Y
  }
}

void draw() {
  background(0);
  
  if (!enTransicion) {
    // Dibujar fondo según la escena actual
    dibujarEscena(escenaActual);
    
    // Dibujar símbolos interactivos
    dibujarSimbolos();
    
    // Actualizar y dibujar pájaro
    pajaro.update();
    pajaro.evadirMouse(mouseX, mouseY, radioInfluencia);
    pajaro.display();
    
    // Mostrar texto
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
      // Fade out
      dibujarEscena(escenaActual);
      fill(0, alpha);
      rect(0, 0, width, height);
      alpha += velocidadTransicion;
    } else if (alpha < 510) {
      // Fade in
      dibujarEscena(siguienteEscena);
      fill(0, 510 - alpha);
      rect(0, 0, width, height);
      alpha += velocidadTransicion;
      
      if (alpha >= 510) {
        // Terminar transición
        enTransicion = false;
        escenaActual = siguienteEscena;
        alpha = 0;
      }
    }
  }
  
  // Actualizar interacción con el mouse
  interactuarConMouse();
}

void setupTexto() {
  fuentePoema = createFont("Georgia", 24);
}

void mostrarEstrofa() {
  // Actualizar opacidad con transición suave
  opacidadTexto = lerp(opacidadTexto, targetOpacidadTexto, 0.1);
  
  // Fondo degradado para el texto
  rectMode(CORNER);
  noStroke();
  
  // Gradiente vertical más oscuro
  for (int y = height - 220; y < height; y++) {
    float inter = map(y, height - 220, height, 0, 1);
    float alphaGrad = lerp(0, 250, inter);
    fill(0, alphaGrad * (opacidadTexto/255.0));
    rect(0, y, width, 1);
  }
  
  // Texto del poema con doble sombra para más contraste
  textFont(fuentePoema);
  textAlign(CENTER, CENTER);
  
  // Sombra exterior
  fill(0, 200 * (opacidadTexto/255.0));
  for (int i = 0; i < 360; i += 45) {
    float rad = radians(i);
    text(estrofas[escenaActual], 
         width/2 + cos(rad) * 2,
         height - 100 + sin(rad) * 2);
  }
  
  // Texto principal con brillo
  fill(255, 255, 220, opacidadTexto);
  text(estrofas[escenaActual], width/2, height - 100);
}

void mousePressed() {
  // Verificar si se hace clic en el símbolo
  float distancia = dist(mouseX, mouseY, 
                         posicionesSimbolo[escenaActual][0], 
                         posicionesSimbolo[escenaActual][1]);
  
  if (distancia < tamanoSimbolo && !enTransicion) {
    // Iniciar transición a la siguiente escena
    siguienteEscena = (escenaActual + 1) % totalEscenas;
    enTransicion = true;
    alpha = 0;
    
    // Reiniciar el texto
    opacidadTexto = 0;
    targetOpacidadTexto = 255;
    
    // Reiniciar instrucción
    if (siguienteEscena != 0) {
      mostrarInstruccion = true;
      tiempoInstruccion = 3;
    }
  }
}

void dibujarSimbolos() {
  // Dibujar símbolo actual
  float x = posicionesSimbolo[escenaActual][0];
  float y = posicionesSimbolo[escenaActual][1];
  
  float distancia = dist(mouseX, mouseY, x, y);
  
  // Cambiar apariencia si el mouse está cerca
  if (distancia < tamanoSimbolo) {
    fill(250, 220, 50, 200);  // Más transparente
    strokeWeight(3);
  } else {
    fill(250, 220, 50);
    strokeWeight(2);
  }
  
  // Dibujar símbolo
  pushMatrix();
  translate(x, y);
  
  fill(250, 220, 50);
  stroke(200, 150, 0);
  strokeWeight(2);
  
  switch(escenaActual) {
    case 0: // Casa
      rect(-15, -5, 30, 20);
      triangle(-15, -5, 15, -5, 0, -20);
      break;
    case 1: // Copa
      triangle(-10, 0, 10, 0, 0, 15);
      line(0, 15, 0, 20);
      ellipse(0, -5, 20, 10);
      break;
    case 2: // Carta
      rect(-15, -10, 30, 20);
      line(-10, -5, 10, -5);
      line(-10, 0, 5, 0);
      line(-10, 5, 0, 5);
      break;
    case 3: // Mano
      ellipse(0, 0, 15, 15);
      for (int i = 0; i < 5; i++) {
        float angulo = PI/2 - PI/8 * i;
        line(0, 0, cos(angulo) * 15, sin(angulo) * 15);
      }
      break;
    case 4: // Postal
      rect(-15, -10, 30, 20);
      line(-10, -5, 10, -5);
      rect(-10, 0, 5, 5);
      break;
  }
  
  popMatrix();
}

void interactuarConMouse() {
  // Calcular distancia al símbolo actual
  float distancia = dist(mouseX, mouseY, 
                         posicionesSimbolo[escenaActual][0], 
                         posicionesSimbolo[escenaActual][1]);
  
  // Cambiar cursor si está cerca del símbolo
  if (distancia < tamanoSimbolo) {
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
}

// Función auxiliar para dibujar una escena específica
void dibujarEscena(int escena) {
  if (escena == 0) {
    if (fondoEscena1 != null) {
      // Actualizar zoom
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

// Función auxiliar para cargar imágenes
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

// Función para limpiar recursos de audio al cerrar
void stop() {
  if (cancion != null) {
    cancion.stop();
  }
}

// ===== CLASES AUXILIARES =====

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
        // Ajustar tamaño para llenar la pantalla
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
        
        // Aplicar escala
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
      
      // Actualizar frame con velocidad suave
      currentFrame = (currentFrame + velocidad) % frames.length;
    }
  }
  
  void reset() {
    currentFrame = 0;
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
    
    // Cargar frames del pájaro
    println("Cargando frames del pájaro...");
    for (int i = 0; i < 5; i++) {
      frames[i] = cargarImagenConDiagnostico("pajaro" + (i+1) + ".png");
      if (frames[i] != null) {
        frames[i].resize(int(tamano), int(tamano));
      }
    }
    
    // Posición inicial
    reset();
  }
  
  void update() {
    // Actualizar frame
    currentFrame = (currentFrame + 0.2) % frames.length;
    
    // Aplicar velocidad
    x += velocidadX;
    y += velocidadY;
    
    // Rebotar en los bordes - llegar exactamente al borde
    if (x <= tamano/2) {
      x = tamano/2;
      velocidadX = abs(velocidadX);  // Forzar dirección positiva
    }
    if (x >= width - tamano/2) {
      x = width - tamano/2;
      velocidadX = -abs(velocidadX);  // Forzar dirección negativa
    }
    if (y <= tamano/2) {
      y = tamano/2;
      velocidadY = abs(velocidadY);  // Forzar dirección positiva
    }
    if (y >= height - tamano/2) {
      y = height - tamano/2;
      velocidadY = -abs(velocidadY);  // Forzar dirección negativa
    }
    
    // Mantener velocidad base constante
    float velocidadActual = sqrt(velocidadX*velocidadX + velocidadY*velocidadY);
    if (velocidadActual < 0.5) {
      // Si se detiene demasiado, darle un impulso aleatorio
      float angulo = random(TWO_PI);
      velocidadX = cos(angulo) * velocidadBase;
      velocidadY = sin(angulo) * velocidadBase;
    } else if (velocidadActual != velocidadBase) {
      // Normalizar velocidad para mantenerla constante
      float factor = velocidadBase / velocidadActual;
      velocidadX *= factor;
      velocidadY *= factor;
    }
    
    // Actualizar ángulo suavemente
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
