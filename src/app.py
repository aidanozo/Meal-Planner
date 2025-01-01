import os
from parser import parse_data_from_xml
from knowledge_engine import apply_rules, generate_daily_menu

def main():
    # Incarc baza de cunostiinte
    xml_path = os.path.join("data", "knowledge_base.xml")
    kb_data = parse_data_from_xml(xml_path)

    # Colectez date de la utilizator
    print("Introduceti urmatoarele informatii:")
    gen = input("Gen (femeie/barbat): ").strip().lower()
    varsta = float(input("Varsta (ani): ").strip())
    greutate = float(input("Greutate (kg): ").strip())
    inaltime = float(input("Inaltime (cm): ").strip())
    activitate = input("Nivel de activitate (sedentar/activ/foarte_activ): ").strip().lower()

    # Construiesc un dictionar care stocheaza date despre utilizator
    context = {
        "Gen": gen,
        "Varsta": varsta,
        "Greutate": greutate,
        "Inaltime": inaltime,
        "Activitate": activitate
    }

    # Aplic regulile pentru a calcula restul de date despre utilizator
    apply_rules(context, kb_data['reguli'])

    # Afisez valorile din context
    print("\nDupa aplicarea regulilor: ")
    for k, v in context.items():
        print(f"{k} = {v}")

    # Generez meniul
    alimente = kb_data['alimente']
    if all(key in context for key in ["Carbohidrati", "Proteine", "Grasimi"]):
        menu = generate_daily_menu(
            alimente,
            context["Carbohidrati"],
            context["Proteine"],
            context["Grasimi"]
        )

        # Afisez meniul in format tabelar
        print("\n=== Meniul generat ===")
        print("-------------------------------------------")
        print("Mic dejun:")
        show_meal(menu['mic_dejun'])
        print("-------------------------------------------")
        print("Pranz:")
        show_meal(menu['pranz'])
        print("-------------------------------------------")
        print("Cina:")
        show_meal(menu['cina'])
    else:
        print("\nEroare: Nu s-au putut calcula macronutrientii. Verifica valorile introduse.")

# Afisez tabelar lista de alimente, cu cantitatea indicata si macronutrientul predominant al acestora
def show_meal(meal_list):
    
    if not meal_list:
        print("  (niciun aliment selectat)")
        return

    print("   Tip Macro   |  Aliment           |  Cantitate (g)")
    print("   -------------------------------------------------")
    for tip_macro, aliment, qty in meal_list:
        print(f"   {tip_macro:<12} |  {aliment:<17} |  {qty:>8.2f}")

if __name__ == "__main__":
    main()