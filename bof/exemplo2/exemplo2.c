
void funcao(char *str) {
char buffer[16];


strcpy(buffer,str);
}


void main() {
char texto_grande[20];
int i;


for( i = 0; i < 20; i++)
texto_grande[i] = 'A';


funcao(texto_grande);
} 