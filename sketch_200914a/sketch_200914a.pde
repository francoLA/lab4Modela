float PE = 0.1; //Probabilidad de que un individuo este enfermo
int cantidadPersonas = 300; //cantidad de personas
int tamano = 1024; //tamaño del terreno
float radius = 8.0;
float minDistance = 2 * radius;
int maxTiempoEnfermo = 50;
//se inicia una nueva poblacion
Poblacion p;

//metodo para preparar el terreno
void setup() {
  size(1024, 1024);
  p = new Poblacion();
  p.run();
}

//metodo para dibujar
void draw() {
  background(0);
  //llamado a la funcion run de la poblacion
  for(Individuo persona : p.personas){
    persona.update();
    persona.display();
  }
}




/////////////////DEFINICION DE CLASES//////////////////////////


//clase de la poblacion
public class Poblacion{
  ArrayList<Individuo> personas; //se crea un arreglo de individuos
  
  //constructor
  Poblacion(){
    personas = new ArrayList<Individuo>(); //se inicializa el arreglo
  }
  //metodo para agregar personas al arreglo
  void agregarPersona(){
    Individuo individuo = new  Individuo();
    if(random(0,1) <= PE){ //bajo la probabilidad establecida se crea un individuo sano o enfermo
      individuo.setEstado(new Enfermo());
    }
    personas.add(individuo);
  }
  //metodo run en el cual se llena la poblacion con la cantidad de personas deseada 
  void run(){
    for(int i = 0; i < cantidadPersonas; i++){
      agregarPersona();
    }
  }
}

//super clase individuo (conext del patron de diseno state)
public class Individuo{
  private EstadoIndividuo estado; // Patron de diseno state
  PVector posicion;
  PVector velocidad;
  PVector aceleracion;
  
  //constructor
  Individuo(){
    //no se usa la aceleracion
    aceleracion = new PVector(0, 0);
    //se obtiene una velocidad inicial random
    velocidad = PVector.random2D();
    //se obtiene la posicion en el terreno de forma random
    posicion = new PVector(random(0, 1023), random(0, 1023));
    this.estado = new Sano();
  }
  
  //Patron de diseno state
  public void setEstado(EstadoIndividuo estado){
    this.estado = estado;
  }
  
  //Patron de diseno state
  public void colorFigura(){
    this.estado.colorFigura();
  }
  
  void display(){
    colorFigura();
    circle(posicion.x, posicion.y, radius);
  }
  
  //metodo para incial el movimiento del individuo y actualizarlo
  void run(){
   update();
   display();
  }
  
  //movimiento uniforme
  void movimiento(){
    posicion.add(velocidad);
    //se hace que el terreno sea circular
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
  
  //metodo para actualizar la posicion del inividuo
  void update() {
    movimiento();
    if(estado instanceof Enfermo){
      if(frameCount - estado.tiempoEnfermo >= maxTiempoEnfermo){
        this.setEstado(new Recuperado());
      }
    }
  }
}

//state del patron de disno stateu
public abstract class EstadoIndividuo{
  int tiempoEnfermo;
  public abstract void colorFigura();
}


//clases que heredan de individuo:

//clase para individuo enfermo (concreteState)
public class Enfermo extends EstadoIndividuo{
  int tiempoEnfermo = frameCount;
  void colorFigura(){
    ellipseMode(RADIUS);
    stroke(#ff0000);
    fill(#ff0000);
  }
}

//clase para individuo sano (concreteState)
public class Sano extends EstadoIndividuo{
  void colorFigura(){
    ellipseMode(RADIUS);
    stroke(#00ff00);
    fill(#00ff00);
  }
}

//clase para individuo recuperado (concreteState)
public class Recuperado extends EstadoIndividuo{
  void colorFigura(){
    ellipseMode(RADIUS);
    stroke(#0000ff);
    fill(#0000ff);
  }
}
