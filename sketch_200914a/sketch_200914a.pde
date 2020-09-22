float PE = 0.1; //Probabilidad de que un individuo este enfermo
int cantidadPersonas = 300; //cantidad de personas
int tamano = 1024; //tamaño del terreno
//se inicia una nueva poblacion
Poblacion p;

//metodo para preparar el terreno
void setup() {
  size(1024, 1024);
  p = new Poblacion();
}

//metodo para dibujar
void draw() {
  background(0);
  //llamado a la funcion run de la poblacion
  p.run();
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
    if(random(0,1) <= PE){ //bajo la probabilidad establecida se crea un individuo sano o enfermo
      personas.add(new  Enfermo());
    }
    else{
      personas.add(new  Sano());
    }
  }
  //metodo run en el cual se llena la poblacion con la cantidad de personas deseada 
  void run(){
    for(int i = 0; i < cantidadPersonas; i++){
      agregarPersona();
      Individuo ind = personas.get(i); //se inicia el movimiento de cada individuo nuevo
      ind.run();
    }
  }
}

//super clase individuo
public class Individuo{
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
  }
  void display(){};
  
  //metodo para incial el movimiento del individuo y actualizarlo
  void run(){
   update();
   display();
  }
  
  //movimiento uniforme
  void movimiento(){
    posicion.add(velocidad);
  }
  
  //metodo para actualizar la posicion del inividuo
  void update() {
    
    movimiento();
    
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
}

//clases que heredan de individuo:

//clase para individuo enfermo
public class Enfermo extends Individuo{
  void display(){
    stroke(#ff0000);
    fill(#ff0000);
    ellipse(posicion.x, posicion.y, 8, 8);
  }
}

//clase para individuo sano
public class Sano extends Individuo{
  void display(){
    stroke(#00ff00);
    fill(#00ff00);
    ellipse(posicion.x, posicion.y, 8, 8);
  }
}
