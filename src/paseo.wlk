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
	method promedioCalidad() = self.prendas().sum({_prenda => _prenda.calidad()}) / self.cantidadDePrendas()
	method algunaPrendaConAbrigoMayorA3() = self.prendas().any({_prenda => _prenda.abrigo()>=3})
	
	method comodidadTotal() = self.prendas().sum({_prenda => _prenda.comodidadTotalPara(self)})
	
	method listoParaSalir() = self.cantidadDePrendas()>5 && self.algunaPrendaConAbrigoMayorA3() && self.promedioCalidad()
}

class NinioProblematico inherits Ninio{
	
}

class Familia{
	var property ninios = #{}
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
		return self.comodidadPara(ninio) - 
			if (self.desgasteTotal()<0) 
				error.throwWithMessage('Desgaste menor a 0 no permitido') 
			else 
				self.desgasteTotal()
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
	
	method intercambiarCon(otroPar){
		if(self.talle()==otroPar.talle()){
			var temp = otroPar.derecho()
			otroPar.cambiarDerecho(self.derecho())
			self.cambiarDerecho(temp)
		}
		else error.throwWithMessage('Las prendas a intercambiar no tienen el mismo talle')
	}
}

class RopaLiviana inherits Prenda {
	override method desgaste() = valores.desgasteRopaLiviana()
	override method abrigo() = valores.nivelDeAbrigoLiviano()
	override method comodidadTotalPara(ninio){
		return super(ninio)+2
	}
}

class RopaPesada inherits Prenda {
	var nivelDeAbrigo = 3
	override method desgaste() = valores.desgasteRopaPesada()
	override method abrigo() = nivelDeAbrigo
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
	method desgasteRopaLiviana()=0
	method desgasteRopaPesada()=0
	method nivelDeAbrigoLiviano()=1
}