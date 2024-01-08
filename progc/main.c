#include <stdio.h>
#include <stdlib.h>

// implémenter le code de l'avl et voir comment trier en l'utilisant
typedef struct arbre{
    int var;
    struct arbre *fg;
    struct arbre *fd;
    int equilibre; 
}avl;

avl *creerarbre(int var){
    avl *nv = malloc(sizeof(avl));
    nv -> var = var;
    nv -> fg = NULL;
    nv -> fd = NULL; 
    nv -> equilibre = 0;
    return nv;
}


avl * rotationg(avl *pavl){
    int equ1, equp;
    avl *pivot = pavl -> fd;
    pavl -> fd = pivot -> fg;
    pivot -> fg = pavl;
    equ1 = pavl -> equilibre;
    equp = pivot -> equilibre;
    pavl -> equilibre = equ1 - fmax(equp, 0)-1;
    pivot -> equilibre = fmin(equ1-2, fmin(equ1+equp-2,equp-1));
    pavl = pivot;
    return pavl;
}

avl * rotationd(avl *pavl){
    int equ1, equp;
    avl *pivot = pavl -> fg;
    pavl -> fg = pivot -> fd;
    pivot -> fd = pavl;
    equ1 = pavl -> equilibre;
    equp = pivot -> equilibre;
    pavl -> equilibre = equ1 - fmin(equp, 0)+1;
    pivot -> equilibre = fmax(equ1+2, fmax(equ1+equp+2,equp+1));
    pavl = pivot;
    return pavl;
}

avl * ajouterfilsgauche(avl *pavl, int nb){
    if (pavl == NULL || pavl -> fg != NULL){
        printf("Je ne peux pas ajouter de fils gauche");
        exit(1);
    }
    pavl -> fg = creerarbre(nb);
    return pavl;
}

avl * ajouterfilsdroit(avl *pavl, int nb){
    if (pavl == NULL || pavl -> fd != NULL){
        printf("Je ne peux pas ajouter de fils droit");
        exit(1);
    }
    pavl -> fg = creerarbre(nb);
    return pavl;
}

int main(){
    return 0;
}