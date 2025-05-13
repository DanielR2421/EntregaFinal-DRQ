// // Código base para la Visualización delPoema "Viajar" de Gabriel Gamar
// Tengo que hacerle varios cambios, esta es solo la versión inicial; la ia me ayudo a crear parte de las funciones del codigo

// Estan serian las variables para las imágenes de fondo las voy a dibujar con un estilo de tinta china o como si fueran hechas con esfero , que sean algo sencillo pero interactivo
PImage[] fondos;
int escenaActual = 0;
int totalEscenas = 5;

// Variables para el pájaro; este tambien lo voy a insertar como una imagen dibujada
float pajaroX, pajaroY;
float pajaroVelocidadX, pajaroVelocidadY;
int formaPajaro = 0; // 0 = pájaro, 1 = mariposa, 2 = avión, 3 = hoja, 4 = pluma; Esta es una posibilidad que se transforme en otras figuras o formas relacionadas con el poema pero, nose si vala la pena o que mas bien lo que se transforme sea el fondo 

// Variables para los símbolos interactivos; Quiero tambien dibujar varios simbolos interactivos relacionados con cada estrofa en especifico, pero tengo que definir bien cuales serian
float[][] posicionesSimbolo;
int tamanoSimbolo = 30;

// Variables para el poema; Esto si es bastante obvio, es para los textos que quiero que aparezcan como una luz que se prende como momentaneamente
String[] estrofas;
int estrofaVisible = 0;

// Variables para la interacción con el mouse; la idea que que la figura del pajaro interactue con el mouse, y se aleje y cambie de dirección cada vez que uno se le acerque, que sea como un tipo de juego raro
float radioInfluencia = 150; // Radio de influencia del mouse; que tan cerca interactua el pajaro con el mouse (valores temporales)
float factorRepulsion = 0.5; // Qué tan fuerte es la repulsión; que tan imapactante es el cambio de dirección (valores temaporales)

void setup() {
  size(800, 600);
  smooth();
  
// variable PImage para la activación de los distintos fondos de acuerdo con cada estrofa
  fondos = new PImage[totalEscenas];
  // Aca toca descomentar estas líneas cuando tengas las imágenes
  // fondos[0] = loadImage("fondo1.jpg");
  // fondos[1] = loadImage("fondo2.jpg");
  // fondos[2] = loadImage("fondo3.jpg");
  // fondos[3] = loadImage("fondo4.jpg");
  // fondos[4] = loadImage("fondo5.jpg");
  
  // Variables para inicializar posición del pájaro
  pajaroX = width/2;
  pajaroY = height/2;
  pajaroVelocidadX = 2;
  pajaroVelocidadY = 1;
  
  //Variables para inicializar posiciones de símbolos interactivos, seria chevere que las posiciones sean aleatorias pero que estas, se cogenien con el fondo, eso lo tengo que hacer en el proceso de dibujo
  posicionesSimbolo = new float[totalEscenas][2];
  for (int i = 0; i < totalEscenas; i++) {
    posicionesSimbolo[i][0] = random(100, width-100);
    posicionesSimbolo[i][1] = random(100, height-100);
  }
  
  // Cargar estrofas del poema "Viajar" de Gabriel Gamar; Esto no se si lo quiera mostrar asi con texto o con imagenes con otra fuente serifada mas adecuada con mi concepto e idea de como se vera el proyecto
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
  // Dibujo fondo del fondo; esto es temporal aun la idea es que las lineas de los fondos se transformen en los fondos sobre los cuales se hace el cambio (osea que el fondo 1 se transforme en el fondo 2)
  if (fondos[escenaActual] != null) {
    image(fondos[escenaActual], 0, 0, width, height);
  } else {
    // Fondo temporal hasta que se carguen las imágenes
    background(50 + escenaActual * 40, 100, 150);
  }
  
  // Dibujo del símbolo interactivo; esta parte del codigo se editara para albergar las imagenes interactivas de los simbolos, por lo que tocaria crear una clase especifica para estos y facilitar su interacción y comportamiento
  dibujarSimbolo(posicionesSimbolo[escenaActual][0], posicionesSimbolo[escenaActual][1]);
  
  // Aca de debría de calcular la interacción con el mouse
  interactuarConMouse();
  
  // EStos serian los cambios de movimiento del el pájaro o dibujo qque vaya a moverse
  pajaroX += pajaroVelocidadX;
  pajaroY += pajaroVelocidadY;
  
  // Codigo para que rebote en los bordes del canvas
  if (pajaroX < 0 || pajaroX > width) {
    pajaroVelocidadX *= -1;
  }
  if (pajaroY < 0 || pajaroY > height) {
    pajaroVelocidadY *= -1;
  }
  
  // dibujo del el pájaro según su forma actual; esto es temporal y lo hizo la ia
  dibujarPajaro();
  
  // Mostrar estrofa actual
  mostrarEstrofa();
  
  // Opcional: mostrar el radio de influencia (quitar en producción); no creo que esto lo ponga porque le quitya la gracia pero lo tengo ahia para saber hasta donde hay una acción
  // noFill();
  // stroke(255, 50);
  // ellipse(mouseX, mouseY, radioInfluencia*2, radioInfluencia*2);
}

void interactuarConMouse() {
  // Calculo de la distancia de interacción entre el pájaro y el mouse
  float distancia = dist(pajaroX, pajaroY, mouseX, mouseY);
  
  // verificación sobre si el mouse está dentro del radio de influencia
  if (distancia < radioInfluencia) {
    // Dirección del pajaro con relación al mouse; la ia me ayudo a cuadrar esto con mayor facilidad, pero toca ver como interactua al ser una imagen 
    float direccionX = pajaroX - mouseX;
    float direccionY = pajaroY - mouseY;
    
    // Transformación de variables de direción (cambio de dirección entre coordenadas X y Y) (convertirlo a longitud 1); la ia me ayudo con esto
    float longitud = sqrt(direccionX*direccionX + direccionY*direccionY);
    if (longitud > 0) {
      direccionX /= longitud;
      direccionY /= longitud;
    }
    
    // Calculo de la fuerza de repulsión basada en la distancia
    // Cuanto más cerca, más fuerte es la repulsión (la del mouse, los valores son provisionales porque toca ver como se comportaría con la imagen) 
    float fuerza = map(distancia, 0, radioInfluencia, factorRepulsion, 0);
    
    // Fuerza aplicada de la cercania del mouse l al pájaro ( que tanto afecta la cercania del mouse la direciión del pajaro)
    pajaroVelocidadX += direccionX * fuerza;
    pajaroVelocidadY += direccionY * fuerza;
    
    // Limitación de la velocidad máxima para que no se vuelva demasiado rápido (esto es para los cambios de dirección no sean tan abrubtos; la ia me ayudo con esto)
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
  
  //Esto es provisional ya que no creo que lo llegue a necesitar con la imagen intersatda del pajaro pero iguelamente creo que es interesante dejarlo por ahora para tenerlo como base)
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
      
      //Esto también es provisional y nose si al fin y al cabo lo cambie
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

//Esto probabalemente se modifique para insertar iamgenes de los simbolos y que cuadren mas con la estetica de los dibujos y de como se transmite la historia
void dibujarSimbolo(float x, float y) {
  pushMatrix();
  translate(x, y);
  
  fill(250, 220, 50);
  stroke(200, 150, 0);
  strokeWeight(2);
  
  // Diferentes símbolos para cada escena, esto probablemente se modifique ya que no se si esos simbolos vayan a ser aquellos que termine usando
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

//Esto también probalamente sea provisional ya que el fondo cambiara paro no creo que la sea dibujado en processiong sino mas bien creo que sera insertado, aunque quiero buscar una forma de que se vea animado el cambio o la modificación del fondo de manera fluida y no se solo un corte / cambio como se ve actualmente
void mostrarEstrofa() {
  // Fondo semitransparente para el texto (temporal)
  fill(0, 150);
  rect(50, height - 200, width - 100, 180, 10);
  
  // Texto de la estrofa (temporal)
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(18);
  text(estrofas[escenaActual], width/2, height - 110);
  
  // Instrucciones (temporal, probablemete sea otro tipo de texto / imagen insertada que cuadre con la estetica de los dibujos)
  textSize(12);
  text("Haz clic en el símbolo para cambiar de escena", width/2, height - 25);
}

void mousePressed() {
  // esta base si probablemente la use para ver las interacciónes con los eventos que suceden para que la historia se vea de manera interactiva
  float distancia = dist(mouseX, mouseY, 
                         posicionesSimbolo[escenaActual][0], 
                         posicionesSimbolo[escenaActual][1]);
  
  if (distancia < tamanoSimbolo) {
    // Cambio a la siguiente escena
    escenaActual = (escenaActual + 1) % totalEscenas;
    
    // Transformación del pájaro en otra forma (temporal, porque tal vez se vea mejor modificar el fondo)
    formaPajaro = escenaActual;
    
    // Reposición del pájaro cerca del centro, esto probablemete sea innecesario
    pajaroX = width/2 + random(-100, 100);
    pajaroY = height/2 + random(-100, 100);
  }
}
//Probablemente le agregue mas venetos con otras teclas para visualizar las escenas y tal vez volver la histotia mas dinamica porque esta algo sencilla de este modo
//También probablemete le agregue alguna canción de fondo de un piano o algo de por el estilo que siga la estetica que me imagino de como  se relataria el poema
//Quiero que este sea sencillo pero interactivo y pulido porloque debo investigar sobre como hacer las transiciones fluidas ydinamicas y que no se como un cmabio de pagina en un libro digital
//También quiero saber si es posible hacer algo del estilo stop-motion para mostrar lo que quiero hacer pero se requeriran de mas imagenes con cambios mas espaciosos, por lo que quien sabe si seria mas facil hacer el dibujo de una vez en processing
