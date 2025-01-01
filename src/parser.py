import xml.etree.ElementTree as ET

def parse_data_from_xml(xml_file_path):
    
    # Parsez fisierul XML si obtin radacina
    tree = ET.parse(xml_file_path)
    root = tree.getroot()

    ## 1. Alimente
    # Initializez un dictionar gol pentru a stoca alimentele
    alimente = {}
    alimente_tag = root.find('alimente')
    if alimente_tag is not None:
        # Iterez prin fiecare categorie
        for categorie_tag in alimente_tag.findall('categorie'):
            cat_name = categorie_tag.get('name')
            # Creez o lista goala pentru fiecare categorie
            alimente[cat_name] = []
            for aliment_tag in categorie_tag.findall('aliment'):
                # Creez un dictionar pentru fiecare aliment cu valorile atributelor sale
                aliment_data = {
                    'nume': aliment_tag.get('nume'),
                    'proteine': float(aliment_tag.get('proteine', 0)),
                    'carbohidrati': float(aliment_tag.get('carbohidrati', 0)),
                    'grasimi': float(aliment_tag.get('grasimi', 0)),
                    'calorii': float(aliment_tag.get('calorii', 0))
                }
                # Adaug dictionarul in lista categoriei asociate
                alimente[cat_name].append(aliment_data)

    ## 2. Activitati
    # Initializez o lista goala, pentru a o popula cu activitati
    activitati = []
    activitati_tag = root.find('activitati')
    if activitati_tag is not None:
        for act_tag in activitati_tag.findall('activitate'):
            activ_data = {
                'nume': act_tag.get('nume'),
                'pal': float(act_tag.get('pal', 1.0))
            }
            activitati.append(activ_data)

    ## 3. Reguli
    # Initializez o lista goala, pentru a o popula cu reguli
    reguli = []
    reguli_tag = root.find('reguli')
    if reguli_tag is not None:
        for regula_tag in reguli_tag.findall('regula'):
            if_element = regula_tag.find('if')
            then_element = regula_tag.find('then')
            # Extrag textul asociat elementului if
            if_text = if_element.text.strip() if if_element is not None else ''
            # Extrag textul asociat elementului then
            then_text = then_element.text.strip() if then_element is not None else ''
            # Adaug dictionarul asociat fiecarei reguli in lista
            reguli.append({
                'if': if_text,
                'then': then_text
            })
    
    ## Returnez datele parsate
    return {
        # Un dictionar cu categorii de alimente si detaliile fiecarui aliment
        'alimente': alimente,
        # O lista de activitati cu numele si PAL-ul asociat fiecareia
        'activitati': activitati,
        # O lista de reguli cu conditiile "if" si actiunile "then"
        'reguli': reguli
    }