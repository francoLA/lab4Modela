PVector posicion;  // Location of shape
PVector velocidad;  // Velocity of shape
PVector aceleracion;   // Gravity acts at the shape's acceleration

float PE = 0.1; //Probabilidad de que un individuo este enfermo

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
    for(int i = 0; i < 50; i++){
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
    velocidad = new PVector(random(-1, 1), random(-2, 0));
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
  
  void update() {
    velocidad.add(aceleracion);
    posicion.add(velocidad);
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
