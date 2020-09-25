//Variables globales
int cantidadPersonas = 300; //cantidad de personas
int tamano = 1024; //tamaño del terreno

float radius= 8.0;
float vel = 2.0;
float minDistance = 2*radius;
float socialDistancing = 1.5*minDistance;
float pInHouse = 0.2;
float pTransmission = 0.7;
float pEnfermos = 0.3;
int maxTiempoEnfermo = 500;

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
    persona.update(p.personas);
    //persona.checkCollision(p.personas);
    persona.display();
  }
}


/////////////////DEFINICION DE CLASES//////////////////////////


//clase de la poblacion
public class Poblacion{
  public ArrayList<Individuo> personas; //se crea un arreglo de individuos
  //constructor
  Poblacion(){
    personas = new ArrayList<Individuo>(); //se inicializa el arreglo
  }
  public ArrayList<Individuo> getPersonas(){
    return this.personas;
  }
  //metodo para agregar personas al arreglo
  void agregarPersona(){
    Individuo individuo = new  Individuo();
    if(random(0,1) <= pEnfermos){ //bajo la probabilidad establecida se crea un individuo sano o enfermo
      individuo.setEstado(new Enfermo());
    }
    if(random(0,1) <= pInHouse){
      individuo.inHouse = true;
      individuo.velocidad = new PVector(0, 0);
      individuo.aceleracion = new PVector(0, 0);
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
  float m = radius*.1;
  boolean inHouse;
  
  //constructor
  Individuo(){
    //se obtiene la posicion en el terreno de forma random
    posicion = new PVector(random(0, 1023), random(0, 1023));  
    //no se usa la aceleracion
    aceleracion = new PVector(0, 0);
    //se obtiene una velocidad inicial random
    velocidad = PVector.random2D();
    velocidad.x *= vel;
    velocidad.y *= vel;
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
  
  void contagiar(Individuo otroIndividuo){
    if(otroIndividuo.estado instanceof Sano){
      // Get distances between the balls components
      PVector distancia = PVector.sub(otroIndividuo.posicion, posicion);
      // Calculate magnitude of the vector separating the balls
      float magnitudDistancia = distancia.mag();
      if(magnitudDistancia <= minDistance){
        if(random(0,1) <= pTransmission){
          otroIndividuo.setEstado(new Enfermo());
          
        }
      }
    }
  }
  
  void display(){
    colorFigura();
    ellipse(posicion.x, posicion.y, radius, radius);
  }
  
  //metodo para inciar el movimiento del individuo y actualizarlo
  void run(ArrayList<Individuo> personas){
   update(personas);
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
  void update(ArrayList<Individuo> personas) {
    checkCollision(personas);
    movimiento();
    //Nuevos recuperados
    if(this.estado instanceof Enfermo){
      if(frameCount - this.estado.tiempoEnfermo >= maxTiempoEnfermo){
        this.setEstado(new Recuperado());
      }
    }
    //Nuevos contagiados
    if(!inHouse){
      if(estado instanceof Enfermo){
        for(Individuo persona : personas){
          if(!persona.inHouse){
            contagiar(persona);
          }
        }
      }
    }
  }
  
  void checkCollision(ArrayList<Individuo> personas){
    for(Individuo otro : personas){
      if(!otro.inHouse){
        if(!inHouse){
          PVector distanceVec = PVector.sub(otro.posicion, this.posicion);
          float distanceVecMag = distanceVec.mag();
          if(distanceVecMag <= minDistance){
            float distanceCorrec = (minDistance - distanceVecMag) / 2.0;
            PVector d = distanceVec.copy();
            PVector correctionVec = d.normalize().mult(distanceCorrec);
            otro.posicion.add(correctionVec);
            this.posicion.sub(correctionVec);
            
            //obtencion del angulo
            float theta = distanceVec.heading();
            float sine = sin(theta);
            float cosine = cos(theta);
            
            PVector[] bTemp = {
              new PVector(), new PVector()
            };
            
            bTemp[1].x  = cosine * distanceVec.x + sine * distanceVec.y;
            bTemp[1].y  = cosine * distanceVec.y - sine * distanceVec.x;
            
            PVector[] vTemp = {
              new PVector(), new PVector()
            };
            
            vTemp[0].x  = cosine * this.velocidad.x + sine * this.velocidad.y;
            vTemp[0].y  = cosine * this.velocidad.y - sine * this.velocidad.x;
            vTemp[1].x  = cosine * otro.velocidad.x + sine * otro.velocidad.y;
            vTemp[1].y  = cosine * otro.velocidad.y - sine * otro.velocidad.x;
            
            PVector[] vFinal = {
              new PVector(), new PVector()
            };
            
            vFinal[0].x = ((this.m - otro.m) * vTemp[0].x + 2 * otro.m * vTemp[1].x) / (this.m + otro.m);
            vFinal[0].y = vTemp[0].y;
    
            // final rotated velocity for b[0]
            vFinal[1].x = ((otro.m - this.m) * vTemp[1].x + 2 * this.m * vTemp[0].x) / (this.m + otro.m);
            vFinal[1].y = vTemp[1].y;
    
            // hack to avoid clumping
            bTemp[0].x += vFinal[0].x;
            bTemp[1].x += vFinal[1].x;
            
            PVector[] bFinal = {
              new PVector(), new PVector()
            };
            
            bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
            bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
            bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
            bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;
            
            otro.posicion.x = this.posicion.x + bFinal[1].x;
            otro.posicion.y = this.posicion.y + bFinal[1].y;
            
            this.posicion.add(bFinal[0]);
            
            this.velocidad.x = cosine * vFinal[0].x - sine * vFinal[0].y;
            this.velocidad.y = cosine * vFinal[0].y + sine * vFinal[0].x;
            otro.velocidad.x = cosine * vFinal[1].x - sine * vFinal[1].y;
            otro.velocidad.y = cosine * vFinal[1].y + sine * vFinal[1].x;
          }
        }
      }
    }
  }
}

//state del patron de diseno state
public abstract class EstadoIndividuo{
  int tiempoEnfermo;
  public abstract void colorFigura();
}


//clases que heredan de EstadoIndividuo

//clase para individuo enfermo (concreteState)
public class Enfermo extends EstadoIndividuo{
  Enfermo(){
    this.tiempoEnfermo = frameCount;
  }
  void getTiempoEnfermo(){
  }
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
