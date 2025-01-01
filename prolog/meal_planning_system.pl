% Faptele ce descriu alimentele sunt de forma:
% nume, proteine, carbohidrati, grasimi, calorii per 100g, categorie (mic_dejun, pranz, cina)

aliment('ovaz', 17, 66, 7, 389, mic_dejun). 
aliment('ou', 13, 1, 11, 155, mic_dejun).
aliment('paine_integrala', 9, 49, 3, 265, mic_dejun).
aliment('iaurt', 5, 4, 3, 59, mic_dejun).
aliment('avocado', 2, 9, 15, 160, mic_dejun).
aliment('quinoa', 14, 64, 6, 368, mic_dejun).
aliment('banane', 1, 23, 0, 89, mic_dejun).
aliment('lapte', 3, 5, 1, 42, mic_dejun).
aliment('miere', 0, 82, 0, 304, mic_dejun).
aliment('unt_de_arahide', 25, 20, 50, 588, mic_dejun).
aliment('clatite', 6, 40, 7, 230, mic_dejun).
aliment('fructe_uscate', 3, 65, 1, 300, mic_dejun).
aliment('chia', 17, 42, 31, 486, mic_dejun).
aliment('gem', 0, 65, 0, 250, mic_dejun).
aliment('ceai_verde', 0, 0, 0, 2, mic_dejun).

aliment('broccoli', 3, 7, 0, 34, pranz).
aliment('pui', 27, 0, 14, 239, pranz).
aliment('orez', 2, 28, 0, 130, pranz).
aliment('cartofi', 2, 17, 0, 77, pranz).
aliment('morcovi', 1, 10, 0, 41, pranz).
aliment('avocado', 2, 9, 15, 160, pranz).
aliment('linte', 9, 20, 0, 116, pranz).
aliment('branza_cottage', 11, 3, 4, 98, pranz).
aliment('dovlecei', 1, 3, 0, 16, pranz).
aliment('porumb', 3, 19, 1, 86, pranz).
aliment('spanac', 3, 1, 0, 23, pranz).
aliment('vinete', 1, 6, 0, 25, pranz).
aliment('ardei_gras', 1, 6, 0, 30, pranz).
aliment('supa_linte', 8, 15, 4, 160, pranz).
aliment('paste_integrale', 5, 30, 1, 150, pranz).
aliment('ficat_de_pui', 17, 1, 4, 130, pranz).

aliment('somon', 20, 0, 13, 208, cina).
aliment('cartofi', 2, 17, 0, 77, cina).
aliment('morcovi', 1, 10, 0, 41, cina).
aliment('avocado', 2, 9, 15, 160, cina).
aliment('nuci', 15, 14, 65, 654, cina).
aliment('tofu', 8, 2, 4, 76, cina).
aliment('ciuperci', 3, 4, 0, 22, cina).
aliment('sparanghel', 2, 4, 0, 20, cina).
aliment('branza_feta', 14, 4, 21, 264, cina).
aliment('mazare', 5, 14, 0, 81, cina).


% Activitatea fizica si coeficientii PAL asociati

activitate('sedentar', 1.5).
activitate('activ', 1.8).
activitate('foarte_activ', 2.0).


% Rata metabolica bazala

rata_metabolica(femeie, Greutate, Inaltime, Varsta, Rata) :- 
    Rata is 665.1 + (9.563 * Greutate) + (1.85 * Inaltime) - (4.676 * Varsta).
rata_metabolica(barbat, Greutate, Inaltime, Varsta, Rata) :-
    Rata is 66.47 + (13.75 * Greutate) + (5 * Inaltime) - (6.75 * Varsta).


% Necesar caloric

necesar_caloric(RataMetabolica, Activitate, NecesarCaloric) :-
    activitate(Activitate, Coeficient),
    NecesarCaloric is RataMetabolica * Coeficient.


% Calcul macronutrienti

necesar_macronutrienti(NecesarCaloric, Carbohidrati, Proteine, Grasimi) :-
    Carbohidrati is (0.55 * NecesarCaloric) / 4,
    Proteine is (0.15 * NecesarCaloric) / 4,
    Grasimi is (0.3 * NecesarCaloric) / 9.


% Selecteaza alimente pentru o masa (carbohidrati, proteine, grasimi)

selecteaza_aliment(Carbohidrati, Proteine, Grasimi, MeniuCarb, MeniuProt, MeniuGras) :-
    
    % Selecteaza o sursa de carbohidrati
    
    findall([Aliment, PA, CA, GA, Cal], 
        (aliment(Aliment, PA, CA, GA, Cal, _), CA =< Carbohidrati),
    SurseCarb),
    select([_, _, CarbohidratiValue, _, _], SurseCarb, _), % Extrag doar valoarea de carbohidrati
    
    % Selecteaza o sursa de proteine
   
    findall([Aliment, PA, CA, GA, Cal], 
        (aliment(Aliment, PA, CA, GA, Cal, _), PA =< Proteine),
    SurseProt),
    select([_, ProteineValue, _, _, _], SurseProt, _), % Extrag doar valoarea de proteine
    
    % Selecteaza o sursa de grasimi
    
    findall([Aliment, PA, CA, GA, Cal], 
        (aliment(Aliment, PA, CA, GA, Cal, _), GA =< Grasimi),
    SurseGras),
    select([_, _, _, GrasimiValue, _], SurseGras, _), % Extrag doar valoarea de grasimi
    
    % Adaug valorile extrase in meniu
    
    MeniuCarb = CarbohidratiValue,
    MeniuProt = ProteineValue,
    MeniuGras = GrasimiValue.


% Calculez cantitatea de aliment necesara pentru a ajunge la valoarea tinta

calculeaza_cantitate(Necesar, Macronutrient, Cantitate) :-
    Cantitate is Necesar / Macronutrient * 100.


% Generez meniul

genereaza_meniu(CarbohidratiTotal, ProteineTotal, GrasimiTotal, MicDejun, Pranz, Cina) :-
    
    % Impart necesarul de macronutrienti pe mese
    
    CarbohidratiMicDejun is CarbohidratiTotal * 0.3,
    ProteineMicDejun is ProteineTotal * 0.3,
    GrasimiMicDejun is GrasimiTotal * 0.3,
    
    CarbohidratiPranz is CarbohidratiTotal * 0.4,
    ProteinePranz is ProteineTotal * 0.4,
    GrasimiPranz is GrasimiTotal * 0.4,
    
    CarbohidratiCina is CarbohidratiTotal * 0.3,
    ProteineCina is ProteineTotal * 0.3,
    GrasimiCina is GrasimiTotal * 0.3,

    % Selectez alimentele pentru fiecare masa
    
    select_alimente_masa(mic_dejun, CarbohidratiMicDejun, ProteineMicDejun, GrasimiMicDejun, [], MicDejun, AlimenteFolositeMicDejun),
    select_alimente_masa(pranz, CarbohidratiPranz, ProteinePranz, GrasimiPranz, AlimenteFolositeMicDejun, Pranz, AlimenteFolositePranz),
    select_alimente_masa(cina, CarbohidratiCina, ProteineCina, GrasimiCina, AlimenteFolositePranz, Cina, _).


% Limitez cantitatea unui aliment la maximum 300 g

calculeaza_cantitate_limitata(Necesar, Macronutrient, Cantitate, ConsumReal) :-
    CantitateCalculata is Necesar / Macronutrient * 100,
    (CantitateCalculata > 300 -> Cantitate = 300, ConsumReal is 300 * Macronutrient / 100;
     Cantitate = CantitateCalculata, ConsumReal = Necesar).


% Selectez alimente distincte pentru o masa

select_alimente_masa(Categorie, Carbohidrati, Proteine, Grasimi, AlimenteExclude, Masa, AlimenteFolosite) :-
    
    % Caut surse de carbohidrati, proteine si grasimi distincte
    
    findall([Aliment, PA, CA, GA, Cal], 
        (aliment(Aliment, PA, CA, GA, Cal, Categorie), CA > 0, \+ member(Aliment, AlimenteExclude)), 
        SurseCarb),
    select_distinct(SurseCarb, [CarbAliment, PA_C, CA_C, GA_C, _]),
    calculeaza_cantitate_limitata(Carbohidrati, CA_C, CantCarb, ConsumCarb),

    findall([Aliment, PA, CA, GA, Cal], 
        (aliment(Aliment, PA, CA, GA, Cal, Categorie), PA > 0, \+ member(Aliment, [CarbAliment|AlimenteExclude])), 
        SurseProt),
    select_distinct(SurseProt, [ProtAliment, PA_P, CA_P, GA_P, _]),
    calculeaza_cantitate_limitata(Proteine, PA_P, CantProt, ConsumProt),

    findall([Aliment, PA, CA, GA, Cal], 
        (aliment(Aliment, PA, CA, GA, Cal, Categorie), GA > 0, \+ member(Aliment, [CarbAliment, ProtAliment|AlimenteExclude])), 
        SurseGras),
    select_distinct(SurseGras, [GrasAliment, PA_G, CA_G, GA_G, _]),
    calculeaza_cantitate_limitata(Grasimi, GA_G, CantGras, ConsumGras),

    % Formez lista de alimente pentru masa
    
    Masa = [
        [carbohidrati, CarbAliment, CantCarb],
        [proteine, ProtAliment, CantProt],
        [grasimi, GrasAliment, CantGras]
    ],

    % Actualizez lista de alimente folosite
    
    append([CarbAliment, ProtAliment, GrasAliment], AlimenteExclude, AlimenteFolosite).



% Aleg un aliment distinct din lista surselor disponibile
select_distinct(Surse, Element) :- 
    member(Element, Surse).


% Exclud un aliment specific din lista de surse

exclude_aliment(Surse, AlimentExclus, Rezultat) :-
    exclude(sublist_contine(AlimentExclus), Surse, Rezultat).


%  Verificare pentru excludere

sublist_contine(Aliment, [Aliment|_]).
sublist_contine(Aliment, [_, _, _, _, _]) :- Aliment \= _.


% Afisez meniul intr-o structura tabelara

afiseaza_meniu_tabel([], _) :- nl.  % Daca lista e goala, nu face nimic

afiseaza_meniu_tabel([PrimulElement|Rest], Masa) :-
    
    % Afisez alimentul curent
    
    afiseaza_element_tabel(PrimulElement),
    
    % Afisez restul alimentelor
    
    afiseaza_meniu_tabel(Rest, Masa).


% Afisez un rand de aliment in tabel

afiseaza_element_tabel([Tip, Aliment, Cantitate]) :-
    format('   ~w   | ~w   | ~2f g~n', [Tip, Aliment, Cantitate]).


% Interfata principala

start :- 
    
    % Colectez informatii despre utilizator
    
    write('Introduceti numele: '), read(_Nume),
    write('Gen (femeie/barbat): '), read(Gen),
    write('Varsta (ani): '), read(Varsta),
    write('Greutate (kg): '), read(Greutate),
    write('Inaltime (cm): '), read(Inaltime), 
    write('Nivel de activitate (sedentar/activ/foarte_activ): '), read(Activitate),
    
    % Calculez parametrii nutritionali
    
    rata_metabolica(Gen, Greutate, Inaltime, Varsta, RataMetabolica),
    necesar_caloric(RataMetabolica, Activitate, NecesarCaloric),
    necesar_macronutrienti(NecesarCaloric, Carbohidrati, Proteine, Grasimi),
    
    % Afisez calculele
    
    write('Necesar caloric zilnic: '), format('~2f~n', [NecesarCaloric]),
    write('Necesar macronutrienți (g/zi):'), nl,
    write('   Carbohidrati: '), format('~2f~n', [Carbohidrati]),
	write('   Proteine: '), format('~2f~n', [Proteine]),
	write('   Grasimi: '), format('~2f~n', [Grasimi]),

    
    % Generez meniurile
    
    genereaza_meniu(Carbohidrati, Proteine, Grasimi, MicDejun, Pranz, Cina),
    
    % Afisez meniurile in forma tabelara
    
    write('========================='), nl,
    write('MicDejun'), nl,
    afiseaza_meniu(MicDejun),
    write('========================='), nl,
    write('Pranz'), nl,
    afiseaza_meniu(Pranz),
    write('========================='), nl,
    write('Cina'), nl,
    afiseaza_meniu(Cina).


% Afisez meniul unui singur tip de masa

afiseaza_meniu(Meniu) :-
    
    % Antetul
    
    format('   ~w   | ~w       | Cantitate (g)~n', ['Tip', 'Aliment']),
    format('-------------------------~n', []),
    
    % Elementele din meniu
    afiseaza_meniu_tabel(Meniu, _).