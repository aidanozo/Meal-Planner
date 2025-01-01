import re

def apply_rules(context, reguli):
   # Iterez prin reguli
    for regula in reguli:
        # Extrag textul conditiei si al actiunii
        if_text = regula['if']
        then_text = regula['then']

        # Separ conditiile complexe (care contin "AND")
        conditions = [c.strip() for c in if_text.split("AND")]
        
        # Initialiez o variabila care indica daca conditiile sunt indeplinite
        all_conditions_met = True
        
        # Verific daca toate conditiile sunt indeplinite
        for cond in conditions:
            if not evaluate_condition(context, cond):
                all_conditions_met = False
                break

        # Daca da, aplic actiunile
        if all_conditions_met:
            # Separ expresiile delimitate de ","
            expressions = [expr.strip() for expr in then_text.split(",")]
            for expr in expressions:
                apply_expression(context, expr)
                
    # Returnez contextul actualizat
    return context

def evaluate_condition(context, condition_str):
    
    # Verific pattern-ul "X = Y"
    match_equals = re.match(r"^(\w+)\s*=\s*(\w+)$", condition_str)
    if match_equals:
        # Prima parte a conditiei
        left_var = match_equals.group(1)
        # A doua parte a conditiei
        right_val = match_equals.group(2)
        # True daca valorile cheii left_var coincid, False in caz contrar
        return context.get(left_var, None) == right_val

    # Verific pattern-ul "X calculata"
    match_calc = re.match(r"^(\w+)\s+calculata$", condition_str)
    if match_calc:
        var_name = match_calc.group(1)
        val = context.get(var_name, None)
        # Conditia e "calculata" daca nu e None si nu e 0
        return val is not None and val != 0

    # Nimic recunoscut
    return False

def apply_expression(context, expression_str):
    
    # Verific pattern-ul "X = Y"
    match_expr = re.match(r"^(\w+)\s*=\s*(.*)$", expression_str)
    if match_expr:
        var_name = match_expr.group(1)
        formula = match_expr.group(2)

        # Inlocuiesc numele variabilelor din formula cu valorile lor reale
        formula_eval = substitute_variables_in_formula(context, formula)

        # Evaluez expresia data de sirul de mai sus
        try:
            val = eval(formula_eval)
        except:
            val = 0  # valoare de fallback
        context[var_name] = val

def substitute_variables_in_formula(context, formula):
   
    # Gasesc toate cuvintele care pot fi variabile
    tokens = re.findall(r"[A-Za-z_]\w*", formula)
    for t in tokens:
        if t in context:
            # In sirul de caractere "formula", se inlocuieste t cu valoarea sa din context, convertita la string
            formula = re.sub(r"\b" + t + r"\b", str(context[t]), formula)
    return formula



def generate_daily_menu(alimente, carbo_total, prot_total, gras_total):
    
    # Impart totalul zilnic de carbohidrati, proteine si grasimi pe mese
    mic_carb = 0.3 * carbo_total
    mic_prot = 0.3 * prot_total
    mic_gras = 0.3 * gras_total

    pranz_carb = 0.4 * carbo_total
    pranz_prot = 0.4 * prot_total
    pranz_gras = 0.4 * gras_total

    cina_carb = 0.3 * carbo_total
    cina_prot = 0.3 * prot_total
    cina_gras = 0.3 * gras_total

    # Initializez setul de alimente folosite
    used_foods = set()

    # Selectez alimentele potrivite pentru fiecare masa, asigurand unicitatea prin setul "used_foods"
    mic_dejun = select_meal(alimente, 'mic_dejun', mic_carb, mic_prot, mic_gras, used_foods)
    pranz = select_meal(alimente, 'pranz', pranz_carb, pranz_prot, pranz_gras, used_foods)
    cina = select_meal(alimente, 'cina', cina_carb, cina_prot, cina_gras, used_foods)

    # Returnez un dictionar care contine alimentele pentru fiecare masa
    return {
        'mic_dejun': mic_dejun,
        'pranz': pranz,
        'cina': cina
    }

def select_meal(alimente, categorie, carb_need, prot_need, gras_need, used_foods):
    
    # Daca, in baza de cunostiinte, nu exista alimente specifice mesei respective, se returneaza o lista goala
    if categorie not in alimente:
        return []

    # Initializez lista de alimente pentru masa
    meal_items = []

    # Selectez sursa de carbohidrati
    carb_item = pick_aliment_for_macro(alimente[categorie], carb_need, 'carbohidrati', used_foods)
    if carb_item:
        # Adaug tuplul (tip macronutrient, nume aliment, cantitate) in lista de alimente
        meal_items.append(('carbohidrati', carb_item['aliment'], carb_item['qty']))
        # Adaug alimentul in setul "used_foods" pentru a evita reutilizarea acestuia
        used_foods.add(carb_item['aliment'])

    # Selectez sursa de proteine
    prot_item = pick_aliment_for_macro(alimente[categorie], prot_need, 'proteine', used_foods)
    if prot_item:
        meal_items.append(('proteine', prot_item['aliment'], prot_item['qty']))
        used_foods.add(prot_item['aliment'])

    # Selectez sursa de grasimi
    gras_item = pick_aliment_for_macro(alimente[categorie], gras_need, 'grasimi', used_foods)
    if gras_item:
        meal_items.append(('grasimi', gras_item['aliment'], gras_item['qty']))
        used_foods.add(gras_item['aliment'])

    # Returnez o lista care contine alimentele pentru masa respectiva
    return meal_items

def pick_aliment_for_macro(food_list, needed_macro, macro_key, used_foods):
   
    # Iterez prin lista de alimente in cautarea unui aliment nefolosit 
    for food in food_list:
        if food['nume'] in used_foods:
            continue
        if food[macro_key] <= 0:
            continue
        
        # Calculez cantitatea necesara din aliment pentru a satisface cantitatea de macro-nutrient
        qty = (needed_macro / food[macro_key]) * 100 
        
        # Limitez cantitatea la 300g
        if qty > 300:
            qty = 300
        
        # Returnez un dictionar cu numele alimentului si cantitatea necesara
        if qty > 0:
            return {
                'aliment': food['nume'],
                'qty': round(qty, 2)
            }
            
    return None