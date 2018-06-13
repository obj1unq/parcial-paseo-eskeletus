//Esta clase no debe existir, 
//está para que el test compile al inicio del examen
//al finalizar el examen hay que borrar esta clase
class XXX {
	var talle= null
	var desgaste= null
	var min= null
	var max= null
	var prendas= null
	var ninios= null
	var edad= null
	var juguete = null
	var abrigo = null
}

class Ninio{
	var property talle
	var property edad
	var property prendas = #{}
	method cantidadDePrendas() = self.prendas().size()
	method cantidadDePrendasParaSalir() = 5 
	method promedioCalidad() = self.prendas().sum({_prenda => _prenda.calidad()}) / self.cantidadDePrendas()
	method algunaPrendaConAbrigoMayorA3() = self.prendas().any({_prenda => _prenda.abrigo()>=3})
	
	method comodidadTotal() = self.prendas().sum({_prenda => _prenda.comodidadTotalPara(self)})
	
	method listoParaSalir() = (self.cantidadDePrendas()>=self.cantidadDePrendasParaSalir()) && self.algunaPrendaConAbrigoMayorA3() && (self.promedioCalidad()>8)
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
	method puedePasear() = self.ninios().all({_pendejo => _pendejo.listoParaSalir()})
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
	method calidad()=self.abrigo()+self.desgaste()
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
}

class RopaLiviana inherits Prenda {
	override method abrigo() = if (abrigo<valores.valorInicialRopaLiviana()) valores.valorInicialRopaLiviana() else abrigo
	override method comodidadTotalPara(ninio){
		return super(ninio)+2
	}
}

class RopaPesada inherits Prenda {
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