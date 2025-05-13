// Visualización Poema "Viajar" de Gabriel García Márquez
// Código base para un proyecto interactivo

// Variables para las imágenes de fondo
PImage[] fondos;
int escenaActual = 0;
int totalEscenas = 5;

// Variables para el pájaro
float pajaroX, pajaroY;
float pajaroVelocidadX, pajaroVelocidadY;
int formaPajaro = 0; // 0 = pájaro, 1 = mariposa, 2 = avión, 3 = hoja, 4 = pluma

// Variables para los símbolos interactivos
float[][] posicionesSimbolo;
int tamanoSimbolo = 30;

// Variables para el poema
String[] estrofas;
int estrofaVisible = 0;

// Variables para la interacción con el mouse
float radioInfluencia = 150; // Radio de influencia del mouse
float factorRepulsion = 0.5; // Qué tan fuerte es la repulsión

void setup() {
  size(800, 600);
  smooth();
  
  // Inicializar arreglo para imágenes de fondo
  fondos = new PImage[totalEscenas];
  // Descomentar estas líneas cuando tengas las imágenes
  // fondos[0] = loadImage("fondo1.jpg");
  // fondos[1] = loadImage("fondo2.jpg");
  // fondos[2] = loadImage("fondo3.jpg");
  // fondos[3] = loadImage("fondo4.jpg");
  // fondos[4] = loadImage("fondo5.jpg");
  
  // Inicializar posición del pájaro
  pajaroX = width/2;
  pajaroY = height/2;
  pajaroVelocidadX = 2;
  pajaroVelocidadY = 1;
  
  // Inicializar posiciones de símbolos interactivos
  posicionesSimbolo = new float[totalEscenas][2];
  for (int i = 0; i < totalEscenas; i++) {
    posicionesSimbolo[i][0] = random(100, width-100);
    posicionesSimbolo[i][1] = random(100, height-100);
  }
  
  // Cargar estrofas del poema "Viajar" de Gabriel García Márquez
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

void draw() {
  // Dibujar fondo
  if (fondos[escenaActual] != null) {
    image(fondos[escenaActual], 0, 0, width, height);
  } else {
    // Fondo temporal hasta que se carguen las imágenes
    background(50 + escenaActual * 40, 100, 150);
  }
  
  // Dibujar símbolo interactivo
  dibujarSimbolo(posicionesSimbolo[escenaActual][0], posicionesSimbolo[escenaActual][1]);
  
  // Calcular interacción con el mouse
  interactuarConMouse();
  
  // Mover el pájaro
  pajaroX += pajaroVelocidadX;
  pajaroY += pajaroVelocidadY;
  
  // Rebotar en los bordes
  if (pajaroX < 0 || pajaroX > width) {
    pajaroVelocidadX *= -1;
  }
  if (pajaroY < 0 || pajaroY > height) {
    pajaroVelocidadY *= -1;
  }
  
  // Dibujar el pájaro según su forma actual
  dibujarPajaro();
  
  // Mostrar estrofa actual
  mostrarEstrofa();
  
  // Opcional: mostrar el radio de influencia (quitar en producción)
  // noFill();
  // stroke(255, 50);
  // ellipse(mouseX, mouseY, radioInfluencia*2, radioInfluencia*2);
}

void interactuarConMouse() {
  // Calcular la distancia entre el pájaro y el mouse
  float distancia = dist(pajaroX, pajaroY, mouseX, mouseY);
  
  // Si el mouse está dentro del radio de influencia
  if (distancia < radioInfluencia) {
    // Calcular vector de dirección desde el mouse hacia el pájaro
    float direccionX = pajaroX - mouseX;
    float direccionY = pajaroY - mouseY;
    
    // Normalizar el vector (convertirlo a longitud 1)
    float longitud = sqrt(direccionX*direccionX + direccionY*direccionY);
    if (longitud > 0) {
      direccionX /= longitud;
      direccionY /= longitud;
    }
    
    // Calcular la fuerza de repulsión basada en la distancia
    // Cuanto más cerca, más fuerte es la repulsión
    float fuerza = map(distancia, 0, radioInfluencia, factorRepulsion, 0);
    
    // Aplicar la fuerza al pájaro
    pajaroVelocidadX += direccionX * fuerza;
    pajaroVelocidadY += direccionY * fuerza;
    
    // Limitar la velocidad máxima para que no se vuelva demasiado rápido
    float velocidadTotal = sqrt(pajaroVelocidadX*pajaroVelocidadX + pajaroVelocidadY*pajaroVelocidadY);
    if (velocidadTotal > 4) {
      pajaroVelocidadX = (pajaroVelocidadX / velocidadTotal) * 4;
      pajaroVelocidadY = (pajaroVelocidadY / velocidadTotal) * 4;
    }
  }
}

void dibujarPajaro() {
  pushMatrix();
  translate(pajaroX, pajaroY);
  
  // Rotar hacia la dirección del movimiento
  float angulo = atan2(pajaroVelocidadY, pajaroVelocidadX);
  rotate(angulo);
  
  fill(255);
  stroke(0);
  strokeWeight(1);
  
  switch(formaPajaro) {
    case 0: // Pájaro
      // Cuerpo
      ellipse(0, 0, 30, 15);
      // Cabeza
      ellipse(10, 0, 15, 15);
      // Cola
      triangle(-15, 0, -25, -8, -25, 8);
      // Alas
      if (frameCount % 20 < 10) {
        triangle(0, 0, -5, -20, 5, -15);
      } else {
        triangle(0, 0, -5, -10, 5, -5);
      }
      break;
      
    case 1: // Mariposa
      // Alas
      ellipse(-10, -10, 20, 15);
      ellipse(-10, 10, 20, 15);
      ellipse(10, -10, 20, 15);
      ellipse(10, 10, 20, 15);
      // Cuerpo
      line(-15, 0, 15, 0);
      ellipse(0, 0, 10, 5);
      break;
      
    case 2: // Avión
      // Forma de avión
      beginShape();
      vertex(15, 0);
      vertex(0, -5);
      vertex(-15, -5);
      vertex(-10, 0);
      vertex(-15, 5);
      vertex(0, 5);
      endShape(CLOSE);
      // Alas
      rect(-5, -15, 10, 30);
      break;
      
    case 3: // Hoja
      // Forma de hoja
      beginShape();
      vertex(0, -15);
      bezierVertex(10, -10, 15, 0, 0, 15);
      bezierVertex(-15, 0, -10, -10, 0, -15);
      endShape();
      // Nervio central
      line(0, -15, 0, 15);
      break;
      
    case 4: // Pluma
      // Eje de la pluma
      line(-15, 0, 15, 0);
      // Barbas de la pluma
      for (int i = -12; i < 12; i += 3) {
        line(i, 0, i - 5, -10);
      }
      break;
  }
  
  popMatrix();
}

void dibujarSimbolo(float x, float y) {
  pushMatrix();
  translate(x, y);
  
  fill(250, 220, 50);
  stroke(200, 150, 0);
  strokeWeight(2);
  
  // Diferentes símbolos para cada escena
  switch(escenaActual) {
    case 0: // Casa (para "marcharse de casa")
      rect(-15, -5, 30, 20);
      triangle(-15, -5, 15, -5, 0, -20);
      break;
    case 1: // Copa (para "saboreando una copa")
      triangle(-10, 0, 10, 0, 0, 15);
      line(0, 15, 0, 20);
      ellipse(0, -5, 20, 10);
      break;
    case 2: // Carta (para "escribir una carta")
      rect(-15, -10, 30, 20);
      line(-10, -5, 10, -5);
      line(-10, 0, 5, 0);
      line(-10, 5, 0, 5);
      break;
    case 3: // Mano (para "extendiendo la mano")
      ellipse(0, 0, 15, 15);
      for (int i = 0; i < 5; i++) {
        float angulo = PI/2 - PI/8 * i;
        line(0, 0, cos(angulo) * 15, sin(angulo) * 15);
      }
      break;
    case 4: // Postal (para "con una postal")
      rect(-15, -10, 30, 20);
      line(-10, -5, 10, -5);
      rect(-10, 0, 5, 5);
      break;
  }
  
  popMatrix();
}

void mostrarEstrofa() {
  // Fondo semitransparente para el texto
  fill(0, 150);
  rect(50, height - 200, width - 100, 180, 10);
  
  // Texto de la estrofa
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(18);
  text(estrofas[escenaActual], width/2, height - 110);
  
  // Instrucciones
  textSize(12);
  text("Haz clic en el símbolo para cambiar de escena", width/2, height - 25);
}

void mousePressed() {
  // Verificar si se hizo clic en el símbolo
  float distancia = dist(mouseX, mouseY, 
                         posicionesSimbolo[escenaActual][0], 
                         posicionesSimbolo[escenaActual][1]);
  
  if (distancia < tamanoSimbolo) {
    // Cambiar a la siguiente escena
    escenaActual = (escenaActual + 1) % totalEscenas;
    
    // Transformar el pájaro
    formaPajaro = escenaActual;
    
    // Reposicionar el pájaro cerca del centro
    pajaroX = width/2 + random(-100, 100);
    pajaroY = height/2 + random(-100, 100);
  }
}
