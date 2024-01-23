#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<math.h>

//Structure représentant une ville
typedef struct Ville{
    char * nom;
    int trajets_total;
    int trajets_depart;
}Ville;

// Structure d'un noeud AVL
typedef struct AVL{
    Ville * ville;
    struct AVL* gch;
    struct AVL* drt;
    int eq;
}AVL;


// Minimum
int min(int a, int b){
    if (a < b){
        return a;
    }
    else {
        return b;
    }
}
// Maximum
int max(int a, int b){
    if (a > b){
        return a;
    }
    else {
        return b;
    }
}


// Fonction qui crée un nouveau noeud
AVL * creernoeud(Ville * v){
    AVL * noeud = malloc(sizeof(AVL));
    if (noeud == NULL){
        exit(1);
    }
    noeud->gch = NULL;
    noeud->ville = v;
    noeud->drt = NULL;
    noeud->eq = 0;

    return noeud;    
}

// Fonction qui effectue une rotation simple gauche
AVL* SG(AVL * a){
  if (a == NULL) {
    return a;
  }

  int eqa, eqp; // définir l'équilibre de l'avl et du pivot
  AVL * p = a->drt;

  eqa = a->eq;
  eqp = p->eq;

  a->drt = p->gch;
  p->gch = a;

  a->eq = eqa - max(eqp, 0) - 1;
  p->eq = min(eqa - 2, min(eqa + eqp - 2, eqp - 1));

  return p;
}

// Fonction qui effectue une rotation simple droite
AVL* SD(AVL * a){
  if (a == NULL) {
    return a;
  }

  int eqa, eqp; // définir l'équilibre de l'avl et du pivot
  AVL * p = a->gch;

  a->gch = p->drt;
  p->drt = a;

  eqa = a->eq;
  eqp = p->eq;

  a->eq = eqa - min(eqp, 0) + 1;
  p->eq = max(eqa + 2, max(eqa + eqp + 2, eqp + 1));

  return p;
}

// Fonction qui effectue une rotation double gauche
AVL * DG(AVL * a){
  if (a == NULL) {
    return a;
  }

  a->drt = SD(a->drt);
  return SG(a);
}

// Fonction qui effectue une rotation double droite
AVL * DD(AVL * a){
  if (a == NULL) {
    return a;
  }

  a->gch = SG(a->gch);
  return SD(a);
}


// Fonction qui réequilibre l'AVL en cas de déséquilibre
AVL * equilibre(AVL * a){
    if(a == NULL){
        return a;
    }

    if(a->eq >= 2){
        if(a->drt->eq >= 0 ){
            return SG(a);
        }
        else{
            return DG(a);
        }
    }

    else if(a->eq <= -2){
        if(a->gch->eq <= 0 ){
            return SD(a);
        }
        else{
            return DD(a);
        }
    }
    return a;
}


AVL * insertion_n(AVL * a, Ville * v, int * h) {
    if (a == NULL) {
        *h = 1;
        return creernoeud(v);
    } 

    else{
        int comp = strcmp(v->nom, a->ville->nom); // strcmp(a,b) compare a et b si a > b alors une valeur positive est renvoyée si a < b une valeur négative
        
        if (comp < 0) {
            a->gch = insertion_n(a->gch, v, h);
            *h = -*h;
        } 
        else if (comp > 0) {
            a->drt = insertion_n(a->drt, v, h);
        } 
        else if (a->ville->nom == v->nom) {

            if (a->ville->trajets_total < v->trajets_total) {
                a->drt = insertion_n(a->drt, v, h);
            } 
            else {
                a->gch = insertion_n(a->gch, v, h);
                *h = -*h;
            }
        } else {
            *h = 0;
            return a;
        }

    }

    if (*h != 0) {
        a->eq = a->eq + *h;
        a = equilibre(a);
        if (a->eq == 0) {
            *h = 0;
        } else {
            *h = 1;
        }
    }
    return a;
}




// Fonction qui récupère les données afin de les inserer dans un AVL en fonction des noms
AVL * donnee_n(char *nom_f) {
    FILE *fichier = NULL;
    fichier = fopen(nom_f, "r");
    if (fichier == NULL) {
        exit(1);
    }
    AVL * a = NULL;
    char ligne[500];

    while (fgets(ligne, sizeof(ligne), fichier) != NULL) {
        char *token = strtok(ligne, ";");
        if (token != NULL) {
            Ville * v = malloc(sizeof(Ville));
            v->nom = strdup(token);

            token = strtok(NULL, ";");
            v->trajets_total= atoi(token);

            token = strtok(NULL, ";");
            v->trajets_depart = atoi(token);

            int h = 0;
            a = insertion_n(a, v, &h);
        }
    }
    fclose(fichier);
    return a;
}


void affichage(AVL * a, int * cpt){
    if (a != NULL && *cpt > 0) {
            affichage(a->gch,cpt);
        if (*cpt > 0) {
            int h = 0;
            printf("%s,%d,%d\n", a->ville->nom, a->ville->trajets_total, a->ville->trajets_depart);
            (*cpt)--;
        }
           affichage(a->drt,cpt);
    }

}

void libererVille(Ville * v) {
    if (v != NULL) {
        free(v->nom);
        free(v);
    }
}

void libererAVL(AVL * a){
    if(a != NULL){
        libererAVL(a->gch);
        libererAVL(a->drt);
        libererVille(a->ville);
        free(a);
    }
}


int main(){
    AVL * avl = donnee_n("temp/t_top_non_trie.csv"); // voir le dossier
    int compte  = 10;

    printf("Ville,Nombre de trajets,Nombre de depart\n");
    affichage(avl, &compte);
    libererAVL(avl);
    return 0;
}