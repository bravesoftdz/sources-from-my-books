
void funcao(char *str) {
char buffer[16];


strcpy(buffer,str);
}


void main() {
char texto_grande[256];
int i;


for( i = 0; i < 256; i++)
texto_grande[i] = 'A';


funcao(texto_grande);
} 