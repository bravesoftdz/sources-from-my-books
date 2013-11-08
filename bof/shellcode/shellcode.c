#include <stdio.h>

void main() { 

char *nome[2];

nome[0] = "/bin/sh"; 
nome[1] = NULL; 
execve(nome[0], nome, NULL); 
} 