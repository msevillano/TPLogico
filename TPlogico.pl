% Punto 1 - Modelado De Informacion y Principio de universo cerrado(Todo lo que no esta en mi base de conocimientos se presume Falso)
serie(dexter, 8, drama(800000)).
serie(scandal, 2, drama(500000)).
serie(breakingBad, 5, drama(10000000)).
serie(prisonBreak, 4, accion(750000,fox)).
serie(theWalkingDead, 7, accion(5000000,fox)).
serie(friends, 10, comedia(2500000,1994,warner)).
serie(howIMetYourMother, 9, comedia(100000,2005,sony)).
serie(theBigBangTheory, 3, comedia(900000,2007,hbo)).

actor(aaronPaul, protagonista(breakingBad)).
actor(aaronPaul, protagonista(dexter)).
actor(michaelHall, secundario(dexter)).
actor(michaelHall, secundario(breakingBad)).
actor(jeffPerry, secundario(scandal)).
actor(jenniferAniston, protagonista(friends)).
actor(jenniferAniston, secundario(prisonBreak)).

% Punto 2 Inversivilidad, se puede consultar trabajaEn(aaronPaul, breakingBad) y obtener True or False; o consultar trabajaEn(Persona, breakingBad) y obtener los actores de breakingBad
trabajaEn(Persona, Serie):-
	actor(Persona,protagonista(Serie)).

trabajaEn(Persona, Serie):-
	actor(Persona,secundario(Serie)).

% Punto 3 - polimorfismo, el predicado esClasico se da cuenta del tipo de serie que recibe y opera distinto en caso de ser comedia o accion 
esClasico(Serie):-
	serie(Serie, _, comedia(_, Fecha, _)), Fecha < 2006.

esClasico(Serie):-
	emisora(Serie, fox).

esClasico(Serie):-
	emisora(Serie, warner).

esClasico(breakingBad).

emisora(Serie, Cadena):-
	serie(Serie, _, accion(_, Cadena)).

emisora(Serie, Cadena):-
	serie(Serie, _, comedia(_ ,_ ,Cadena)).

% Punto 4
tieneBuenElenco(Serie):-
	trabajaEn(_, Serie), forall(trabajaEn(Persona, Serie), esProtagonista(Persona, Serie)).

esProtagonista(Persona, Serie):-
	actor(Persona, protagonista(Serie)).

% Punto 5 
cuantosLaMiran(Cantidad, Serie):-
	serie(Serie, _, drama(Cantidad)).

cuantosLaMiran(Cantidad, Serie):-
	serie(Serie, _, accion(Cantidad, _)).

cuantosLaMiran(Cantidad,Serie):-
	serie(Serie, _, comedia(Cantidad, _, _)).

% Punto 6 - Cuantificador universal (TODAS las series en las que trabaja la persoa deben tener =4 temporadas o ser emitidas por Fox/Warner); negacion en la funcion muyVista
esFamoso(Persona):- 
	siempreProtagonista(Persona), trabajaEn(Persona, Serie), muyVista(Serie).

esFamoso(Persona):-
	siempreProtagonista(Persona), forall((trabajaEn(Persona, Serie), serie(Serie, Temporadas, _)), Temporadas > 4).

esFamoso(Persona):-
	siempreProtagonista(Persona), forall(trabajaEn(Persona, Serie), emisora(Serie, fox)).

esFamoso(Persona):-
	siempreProtagonista(Persona), forall(trabajaEn(Persona, Serie), emisora(Serie, warner)).

siempreProtagonista(Persona):-
	trabajaEn(Persona, _), forall(trabajaEn(Persona, Serie), esProtagonista(Persona, Serie)).

muyVista(Serie):-
	cuantosLaMiran(_, Serie), not((forall(miran(Espectadores, Serie),Espectadores < 1000000))).

% Punto 7
seLlevanBien(Persona1, Persona2):-
	actor(Persona1, _), actor(Persona2, _), Persona1 \= Persona2, findall(_, (trabajaEn(Persona1, serieEnComun), trabajaEn(Persona2, serieEnComun)), Serie), length(Serie, Cantidad), Cantidad > 1.

% Punto 8
ameritaNuevaTemporada(Serie):-
	trabajaEn(Persona, Serie), esFamoso(Persona), forall((trabajaEn(Amigos, Serie), Persona \= Amigos), seLlevanBien(Persona, Amigos)).

% Punto 9
puedeContratarA(Persona):-
	soloUnaSerie(Persona), actorSecundario(Persona, Serie), menosTresT(Serie).

soloUnaSerie(Persona):-
	trabajaEn(Persona, Serie), forall(trabajaEn(Persona, UnicaSerie), Serie == UnicaSerie).

actorSecundario(Persona,Serie):- 
	actor(Persona, secundario(Serie)).

menosTresT(Serie):-
	serie(Serie, Cantidad, _), Cantidad < 4.