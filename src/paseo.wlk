//Nota 9 (nueve)
//test todos bien menos el último punto
//1) B+ Algun problema con la prenda par
//2) MB
//3) B problemas manejando valores por default. Mal la ropa liviana
//4) MB
//5) MB
//6) MB
//7) B Problemas de delegacion
//8) MB

class Ninio{
	var property talle
	var property edad
	var property prendas = #{}
	method cantidadDePrendas() = self.prendas().size()
	method cantidadDePrendasParaSalir() = 5 
	method promedioCalidad() = self.prendas().sum({_prenda => _prenda.calidad(self)}) / self.cantidadDePrendas()
	method algunaPrendaConAbrigoMayorA3() = self.prendas().any({_prenda => _prenda.abrigo()>=3})
	
	method comodidadTotal() = self.prendas().sum({_prenda => _prenda.comodidadTotalPara(self)})
	
	method listoParaSalir() = (self.cantidadDePrendas()>=self.cantidadDePrendasParaSalir()) && self.algunaPrendaConAbrigoMayorA3() && (self.promedioCalidad()>8)
	
	method usarPrendas() = self.prendas().forEach({_prenda => _prenda.usarse()})
}

class NinioProblematico inherits Ninio{
	var property juguete
	override method cantidadDePrendasParaSalir() = 4
	method jugueteRecomendado() = self.edad().between(self.juguete().min(),self.juguete().max())
	override method listoParaSalir() = super() && self.jugueteRecomendado()
}

class Juguete{
	var property min
	var property max
}

class Familia{
	var property ninios = #{}
	method puedePasear() = self.ninios().all({_ninio => _ninio.listoParaSalir()})
	method chiquitos() = self.ninios().filter({_ninio => _ninio.edad()<4})
	//TODO Delegar mejor: pedirle la prenda infaltable directamente el niño
	method infaltables() = self.ninios().map({_ninio => _ninio.prendas().max({_prenda => _prenda.calidad(_ninio)})}).asSet()
	method pasear(){
		if(self.puedePasear()){
			self.ninios().forEach({_ninio => _ninio.usarPrendas()})
		}
		else error.throwWithMessage('Familia no esta lista para pasear')
	}
}

class Prenda {
	var property talle
	var desgaste = 0 
	var abrigo = 1
	
	method comodidadPara(ninio){
		return if (ninio.talle()==self.talle()) 8 
			else 0
	}
	method desgasteTotal(){
		return if (self.desgaste()>3) 3 
			else self.desgaste() 
	}
	method comodidadTotalPara(ninio){
		return self.comodidadPara(ninio) - self.desgasteTotal()
	}
	
	method abrigo()=abrigo
	method desgaste()=desgaste
	method calidad(ninio)=self.abrigo()+self.comodidadTotalPara(ninio)
	
	method gastar(x){
		desgaste+=x
	}
	
	method usarse(){
		self.gastar(1)
	}
}

class PrendaDeAPar inherits Prenda {
	var property izquierdo = new Prenda (talle='s')
	var property derecho = new Prenda (talle='s')
	
	override method abrigo() = self.derecho().abrigo()+self.izquierdo().abrigo()
	
	method desgasteDelPar() = (self.derecho().desgaste() + self.izquierdo().desgaste())/2
	
	method cambiarDerecho(otroDerecho){
		derecho = otroDerecho
	}
	
	override method comodidadTotalPara(ninio){
		return super(ninio) - if(ninio.edad()<4) 1 else 0
	}
	
	//TODO: Quedó el máximo duplicado. Te convenía simplement sobreescribir el metodo desgaste
	//para que haga lo que hace desgasteDelPar. De hecho ahora entiende el mensaje "desgaste"
	//y no sirve para nada lo que devuelve
	override method desgasteTotal(){
		return if (self.desgasteDelPar()>3) 3 else self.desgasteDelPar() 
	}
	
	method intercambiar(otroPar){
		if(self.talle()==otroPar.talle()){
			var temp = otroPar.derecho()
			otroPar.cambiarDerecho(self.derecho())
			self.cambiarDerecho(temp)
		}
		else error.throwWithMessage('Las prendas a intercambiar no tienen el mismo talle')
	}
	
	override method usarse(){
		izquierdo=self.izquierdo().gastar(0.8)
		derecho=self.derecho().gastar(1.2)
	}
}

class RopaLiviana inherits Prenda {
	//TODO: No no! por que te complicas? `return objetoQueSabeElValr.valorRopaLiviana()`.
	// de manera tal qeu al cambiar el valor en el objeto valores ya las ropas livianas contestan el valor nuevo
	//Esto que hiciste de recordarlo en una variable no solo es innecesario
	//si no que está mal, porque si de repente disminuyo el valor de la configuracion la prenda no se actual no se actualiza
	override method abrigo() = if (abrigo<valores.valorInicialRopaLiviana()) valores.valorInicialRopaLiviana() else abrigo
	override method comodidadTotalPara(ninio){
		return super(ninio)+2
	}
}

class RopaPesada inherits Prenda {
	//TODO: mal manejado el valor default. 
	override method abrigo() = if (abrigo<valores.valorInicialRopaPesada()) valores.valorInicialRopaPesada() else abrigo
}

//Objetos usados para los talles
object xs {
}

object s {	
}

object m {
}

object l{
}

object xl{	
}

object valores{
	method valorInicialRopaLiviana()=0
	method valorInicialRopaPesada()=3
	method nivelDeAbrigoLiviano()=1
}