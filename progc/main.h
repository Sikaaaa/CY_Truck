#ifndef HEADER_FUNCTION
#define HEADER_FUNCTION

//déclaration des constantes 
#define true 1
#define false 0

//déclaration des bibliothèques
#include <stdio.h>
#include <stdlib.h>

//déclaration structure utilisée
typedef struct arbre{
    int var;
    struct arbre *fg;
    struct arbre *fd;
    int equilibre; 
}avl;

//déclaration des fonctions 
avl *creerarbre(int var);
avl * rotationg(avl *pavl);
avl * rotationd(avl *pavl);
avl * ajouterfilsgauche(avl *pavl, int nb);
avl * ajouterfilsdroit(avl *pavl, int nb);
int main();


#endif