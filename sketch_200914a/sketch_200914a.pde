float PE = 0.1; //Probabilidad de que un individuo este enfermo
int cantidadPersonas = 50;
int tamano = 1024;
float velocidadMin = -2;
float velocidadMax = 2;

Poblacion p;

void setup() {
  size(1024, 1024);
  p = new Poblacion();
}

void draw() {
  background(0);
  p.run();
}

public class Poblacion{
  ArrayList<Individuo> personas;
  
  Poblacion(){
    personas = new ArrayList<Individuo>();
  }
  
  void agregarPersona(){
    personas.add(new  Individuo());
  }
  
  void run(){
    for(int i = 0; i < cantidadPersonas; i++){
      agregarPersona();
      Individuo ind = personas.get(i);
      ind.run();
    }
  }
}

public class Individuo{
  PVector posicion;
  PVector velocidad;
  PVector aceleracion;
  Boolean enfermo;
  
  
  
  Individuo(){
    aceleracion = new PVector(0, 0);
    velocidad = new PVector(random(velocidadMin, velocidadMax), random(velocidadMin, velocidadMax));
    posicion = new PVector(random(0, 1023), random(0, 1023));
    enfermo = false;
    if(random(0,1) <= PE){
      enfermo = true;
    }
  }
  
  void run(){
   update();
   display();
  }
  
  void movimientoRandomGauss(){
    float nuevaX = posicion.x + (randomGaussian() * 1.5);
    float nuevaY = posicion.y + (randomGaussian() * 1.5);
    posicion.x = nuevaX;
    posicion.y = nuevaY;
    
  }
  
  void update() {
    
    movimientoRandomGauss();
    
    if(posicion.x < 0){
      posicion.x = width;
    }else if(posicion.x > width){
      posicion.x = 0;
    }
    if(posicion.y < 0){
      posicion.y = height;
    }else if(posicion.y > height){
      posicion.y = 0;
    }
  }
  
  void display() {
    //Enfermos de color rojo
    if(this.enfermo){
      stroke(#ff0000);
      fill(#ff0000);
    }
    //Sanos de color verde
    else{
      stroke(#00ff00);
      fill(#00ff00);
    }
    ellipse(posicion.x, posicion.y, 8, 8);
  }
}
