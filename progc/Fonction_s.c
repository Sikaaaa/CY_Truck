#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


// Structure représentant un trajet
typedef struct Trajet{
    int id;
    float mini;
    float maxi;
    float moy;
    float maxmin;
}Trajet;


// Structure d'un noeud AVL
typedef struct AVL{
    Trajet * trajet;
    struct AVL* gch;
    struct AVL* drt;
    int eq;
}AVL;


// Fonction qui trouve le minimum
int min(int a, int b){
    if (a < b){
        return a;
    }
    else {
        return b;
    }
}


// Fonction qui trouve le maximum
int max(int a, int b){
    if (a > b){
        return a;
    }
    else {
        return b;
    }
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


// Fonction qui crée un nouveau noeud
AVL * creernoeud(Trajet * t){
    AVL * noeud = malloc(sizeof(AVL));

    if (noeud == NULL){
        exit(1);
    }

    noeud->gch = NULL;
    noeud->trajet = t;
    noeud->drt = NULL;
    noeud->eq = 0;

    return noeud;    
}


// Fonction qui insert dans un AVL un objet de la structure Trajet
AVL * insertion(AVL * a, Trajet * t, int * h){
    if( a == NULL){
        *h = 1;
        return creernoeud(t);
    }
    else if(a->trajet->maxmin > t->maxmin){
        a->gch = insertion(a->gch,t,h);
        *h = -*h;
    }
    else if(a->trajet->maxmin < t->maxmin){
        a->drt = insertion(a->drt,t,h);
    }
    else if (a->trajet->maxmin == t->maxmin){
        if(a->trajet->id > t->id){
            a->gch = insertion(a->gch,t,h);
            *h = -*h;
        }
        else{
            a->drt = insertion(a->drt,t,h);
        }
    }
    else{
        *h = 0;
        return a;
    }

    if( *h != 0 ){
        a->eq = a->eq + *h;
        a = equilibre(a);
        if(a->eq == 0){
            *h=0;
        }
        else{
            *h=1;
        }
    }

    return a;
}


// Fonction qui récupère les données afin de les inserer dans un AVL en fonction des trajets
AVL * donnee(char *nom_f) {
    FILE *fichier = NULL;
    fichier = fopen(nom_f, "r");

    if (fichier == NULL) {
        fprintf(stderr, "Le fichier %s est inconnu \n", nom_f); // Ecrire l'erreur dans la sortie stderr
        exit(2);
    }
    AVL * a = NULL;
    char ligne[500];

    while (fgets(ligne, sizeof(ligne), fichier) != NULL) {
        char *token = strtok(ligne, ",");

        if (token != NULL) {
            Trajet * t = malloc(sizeof(Trajet));
            t->id = atoi(token);

            token = strtok(NULL, ",");
            t->mini= atof(token);

            token = strtok(NULL, ",");
            t->maxi = atof(token);

            token = strtok(NULL, ",");
            t->moy = atof(token);

            token = strtok(NULL, ",");
            t->maxmin = atof(token);

            int h = 0;
            a = insertion(a,t,&h);
        }
    }

    fclose(fichier);
    return a;
}


// Fonction qui affiche l'AVL de façon décroissante soit un parcours suffixe
void affichage(AVL * a, int * cpt){
    if (a != NULL && *cpt > 0) {
        affichage(a->drt,cpt);

        if (*cpt > 0) {
            printf("%d,%f,%f,%f,%f\n", a->trajet->id, a->trajet->mini, a->trajet->maxi, a->trajet->moy, a->trajet->maxmin);
            (*cpt)--;
        }
           affichage(a->gch,cpt);
    }
}

// Fonction qui libère l'espace en mémoire d'un objet de la structure trajet
void libererTrajet(Trajet * t) {
    if (t != NULL) {
        free(t);
    }
}


// Fonction qui libère l'espace en mémoire d'un AVL
void libererAVL(AVL * a){
    if(a != NULL){
        libererAVL(a->gch);
        libererAVL(a->drt);
        libererTrajet(a->trajet);
        free(a);
    }
}

int main(int n, char *parametre[]){
    
    // Test s'il y plus de 2 arguments, le premier étant le nom du script et le deuxième le fichier csv utilisé
    if ( n != 2){
        fprintf(stderr, "%s : Nombre de paramètres incorrect, un fichier est attendu \n", parametre[0]); // Ecrire l'erreur dans la sortie stderr
        return 1;
    }

    // Création d'un AVL avec toute les données du fichier csv passé en paramètre
    AVL * avl = donnee(parametre[1]); 
    int compte  = 50;
    
    printf("Id_route,Minimum,Maximum,Moyen,Maximum-Minimum\n");
    // Affichage de 50 premières villes dans un nouveau fichier csv à la sortie un script C
    affichage(avl, &compte);
    // Libération de la mémoire de l'AVL
    libererAVL(avl);

    return 0;
}