void funcao(int a, int b, int c) { 
  char buffer1[5];
  char buffer2[10];
  int *ret;

  ret = buffer1 + 12;
  (*ret) += 8;
 }

void main() { 
  int x;
  x = 0; 
  funcao(1,2,3); 
  x = 1; 
  printf("%d\n",x); 
}

