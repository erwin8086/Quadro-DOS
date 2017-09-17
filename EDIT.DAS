
edit.o:     file format coff-go32


Disassembly of section .text:

00000000 <_init_mouse>:
extern volatile int esc;
extern volatile int key_p;
extern char framebuffer[320*200];

int init_mouse()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 58             	sub    $0x58,%esp
  __dpmi_regs r;
  r.x.ax = 0x0;
   6:	66 c7 45 e0 00 00    	movw   $0x0,-0x20(%ebp)
  __dpmi_int(0x33, &r);
   c:	8d 45 c4             	lea    -0x3c(%ebp),%eax
   f:	89 44 24 04          	mov    %eax,0x4(%esp)
  13:	c7 04 24 33 00 00 00 	movl   $0x33,(%esp)
  1a:	e8 e1 ff ff ff       	call   0 <_init_mouse>
  if(r.x.ax == 0xFFFF) return 0;
  1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  22:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  26:	75 07                	jne    2f <_init_mouse+0x2f>
  28:	b8 00 00 00 00       	mov    $0x0,%eax
  2d:	eb 05                	jmp    34 <_init_mouse+0x34>
  return 1;
  2f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  34:	c9                   	leave  
  35:	c3                   	ret    

00000036 <_update_mouse>:

void update_mouse()
{
  36:	55                   	push   %ebp
  37:	89 e5                	mov    %esp,%ebp
  39:	53                   	push   %ebx
  3a:	83 ec 54             	sub    $0x54,%esp
  __dpmi_regs r;
  r.x.ax = 0x3;
  3d:	66 c7 45 e0 03 00    	movw   $0x3,-0x20(%ebp)
  __dpmi_int(0x33, &r);
  43:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  46:	89 44 24 04          	mov    %eax,0x4(%esp)
  4a:	c7 04 24 33 00 00 00 	movl   $0x33,(%esp)
  51:	e8 aa ff ff ff       	call   0 <_init_mouse>
  mouse_x = r.x.cx % 320;
  56:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  59:	89 ca                	mov    %ecx,%edx
  5b:	81 e2 ff ff 00 00    	and    $0xffff,%edx
  61:	89 d0                	mov    %edx,%eax
  63:	01 c0                	add    %eax,%eax
  65:	01 d0                	add    %edx,%eax
  67:	89 c3                	mov    %eax,%ebx
  69:	c1 e3 04             	shl    $0x4,%ebx
  6c:	01 d8                	add    %ebx,%eax
  6e:	89 c3                	mov    %eax,%ebx
  70:	c1 e3 08             	shl    $0x8,%ebx
  73:	01 d8                	add    %ebx,%eax
  75:	c1 e0 02             	shl    $0x2,%eax
  78:	01 d0                	add    %edx,%eax
  7a:	c1 e8 10             	shr    $0x10,%eax
  7d:	89 c2                	mov    %eax,%edx
  7f:	66 c1 ea 08          	shr    $0x8,%dx
  83:	89 d0                	mov    %edx,%eax
  85:	c1 e0 02             	shl    $0x2,%eax
  88:	01 d0                	add    %edx,%eax
  8a:	c1 e0 06             	shl    $0x6,%eax
  8d:	89 ca                	mov    %ecx,%edx
  8f:	29 c2                	sub    %eax,%edx
  91:	89 d0                	mov    %edx,%eax
  93:	25 ff ff 00 00       	and    $0xffff,%eax
  98:	a3 10 00 00 00       	mov    %eax,0x10
  mouse_y = r.x.dx % 200;
  9d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  a0:	89 c8                	mov    %ecx,%eax
  a2:	66 c1 e8 03          	shr    $0x3,%ax
  a6:	89 c2                	mov    %eax,%edx
  a8:	81 e2 ff ff 00 00    	and    $0xffff,%edx
  ae:	89 d0                	mov    %edx,%eax
  b0:	c1 e0 02             	shl    $0x2,%eax
  b3:	01 d0                	add    %edx,%eax
  b5:	c1 e0 03             	shl    $0x3,%eax
  b8:	01 d0                	add    %edx,%eax
  ba:	c1 e0 05             	shl    $0x5,%eax
  bd:	29 d0                	sub    %edx,%eax
  bf:	c1 e0 02             	shl    $0x2,%eax
  c2:	29 d0                	sub    %edx,%eax
  c4:	c1 e8 10             	shr    $0x10,%eax
  c7:	89 c2                	mov    %eax,%edx
  c9:	66 d1 ea             	shr    %dx
  cc:	89 d0                	mov    %edx,%eax
  ce:	c1 e0 02             	shl    $0x2,%eax
  d1:	01 d0                	add    %edx,%eax
  d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  da:	01 d0                	add    %edx,%eax
  dc:	c1 e0 03             	shl    $0x3,%eax
  df:	89 ca                	mov    %ecx,%edx
  e1:	29 c2                	sub    %eax,%edx
  e3:	89 d0                	mov    %edx,%eax
  e5:	25 ff ff 00 00       	and    $0xffff,%eax
  ea:	a3 10 00 00 00       	mov    %eax,0x10
  mouse_btn = r.x.bx;
  ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  f2:	25 ff ff 00 00       	and    $0xffff,%eax
  f7:	a3 10 00 00 00       	mov    %eax,0x10
}
  fc:	83 c4 54             	add    $0x54,%esp
  ff:	5b                   	pop    %ebx
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <_draw_grid>:

void draw_grid()
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 10             	sub    $0x10,%esp
  int x,y;
  for(x=0;x<32;x++) {
 108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10f:	eb 3c                	jmp    14d <_draw_grid+0x4b>
    for(y=0;y<200;y++) {
 111:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 118:	eb 27                	jmp    141 <_draw_grid+0x3f>
      framebuffer[y*320+x*10] = COLOR_WHITE;
 11a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 11d:	89 d0                	mov    %edx,%eax
 11f:	c1 e0 02             	shl    $0x2,%eax
 122:	01 d0                	add    %edx,%eax
 124:	c1 e0 06             	shl    $0x6,%eax
 127:	89 c1                	mov    %eax,%ecx
 129:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12c:	89 d0                	mov    %edx,%eax
 12e:	c1 e0 02             	shl    $0x2,%eax
 131:	01 d0                	add    %edx,%eax
 133:	01 c0                	add    %eax,%eax
 135:	01 c8                	add    %ecx,%eax
 137:	c6 80 00 00 00 00 01 	movb   $0x1,0x0(%eax)

void draw_grid()
{
  int x,y;
  for(x=0;x<32;x++) {
    for(y=0;y<200;y++) {
 13e:	ff 45 f8             	incl   -0x8(%ebp)
 141:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
 148:	7e d0                	jle    11a <_draw_grid+0x18>
}

void draw_grid()
{
  int x,y;
  for(x=0;x<32;x++) {
 14a:	ff 45 fc             	incl   -0x4(%ebp)
 14d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
 151:	7e be                	jle    111 <_draw_grid+0xf>
    for(y=0;y<200;y++) {
      framebuffer[y*320+x*10] = COLOR_WHITE;
    }
  }

  for(y=0;y<20;y++) {
 153:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 15a:	eb 3c                	jmp    198 <_draw_grid+0x96>
    for(x=0;x<320;x++) {
 15c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 163:	eb 27                	jmp    18c <_draw_grid+0x8a>
      framebuffer[y*3200+x] = COLOR_WHITE;
 165:	8b 55 f8             	mov    -0x8(%ebp),%edx
 168:	89 d0                	mov    %edx,%eax
 16a:	c1 e0 02             	shl    $0x2,%eax
 16d:	01 d0                	add    %edx,%eax
 16f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 176:	01 d0                	add    %edx,%eax
 178:	c1 e0 07             	shl    $0x7,%eax
 17b:	89 c2                	mov    %eax,%edx
 17d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 180:	01 d0                	add    %edx,%eax
 182:	c6 80 00 00 00 00 01 	movb   $0x1,0x0(%eax)
      framebuffer[y*320+x*10] = COLOR_WHITE;
    }
  }

  for(y=0;y<20;y++) {
    for(x=0;x<320;x++) {
 189:	ff 45 fc             	incl   -0x4(%ebp)
 18c:	81 7d fc 3f 01 00 00 	cmpl   $0x13f,-0x4(%ebp)
 193:	7e d0                	jle    165 <_draw_grid+0x63>
    for(y=0;y<200;y++) {
      framebuffer[y*320+x*10] = COLOR_WHITE;
    }
  }

  for(y=0;y<20;y++) {
 195:	ff 45 f8             	incl   -0x8(%ebp)
 198:	83 7d f8 13          	cmpl   $0x13,-0x8(%ebp)
 19c:	7e be                	jle    15c <_draw_grid+0x5a>
    for(x=0;x<320;x++) {
      framebuffer[y*3200+x] = COLOR_WHITE;
    }
  }
}
 19e:	c9                   	leave  
 19f:	c3                   	ret    
 1a0:	45                   	inc    %ebp
 1a1:	72 72                	jb     215 <_save_level+0x12>
 1a3:	6f                   	outsl  %ds:(%esi),(%dx)
 1a4:	72 20                	jb     1c6 <_draw_grid+0xc4>
 1a6:	4d                   	dec    %ebp
 1a7:	61                   	popa   
 1a8:	6c                   	insb   (%dx),%es:(%edi)
 1a9:	6c                   	insb   (%dx),%es:(%edi)
 1aa:	6f                   	outsl  %ds:(%esi),(%dx)
 1ab:	63 3a                	arpl   %di,(%edx)
 1ad:	20 65 64             	and    %ah,0x64(%ebp)
 1b0:	69 74 2e 63 3a 20 73 	imul   $0x6173203a,0x63(%esi,%ebp,1),%esi
 1b7:	61 
 1b8:	76 65                	jbe    21f <_save_level+0x1c>
 1ba:	5f                   	pop    %edi
 1bb:	6c                   	insb   (%dx),%es:(%edi)
 1bc:	65                   	gs
 1bd:	76 65                	jbe    224 <_save_level+0x21>
 1bf:	6c                   	insb   (%dx),%es:(%edi)
 1c0:	3a 20                	cmp    (%eax),%ah
 1c2:	62 75 66             	bound  %esi,0x66(%ebp)
 1c5:	66                   	data16
 1c6:	65                   	gs
 1c7:	72 00                	jb     1c9 <_draw_grid+0xc7>
 1c9:	77 00                	ja     1cb <_draw_grid+0xc9>
 1cb:	6e                   	outsb  %ds:(%esi),(%dx)
 1cc:	65                   	gs
 1cd:	77 6c                	ja     23b <_save_level+0x38>
 1cf:	76 6c                	jbe    23d <_save_level+0x3a>
 1d1:	2e 74 78             	je,pn  24c <_save_level+0x49>
 1d4:	74 00                	je     1d6 <_draw_grid+0xd4>
 1d6:	66 90                	xchg   %ax,%ax
 1d8:	46                   	inc    %esi
 1d9:	69 6c 65 20 66 6f 72 	imul   $0x20726f66,0x20(%ebp,%eiz,2),%ebp
 1e0:	20 
 1e1:	73 61                	jae    244 <_save_level+0x41>
 1e3:	76 69                	jbe    24e <_save_level+0x4b>
 1e5:	6e                   	outsb  %ds:(%esi),(%dx)
 1e6:	67 20 6c 65          	and    %ch,0x65(%si)
 1ea:	76 65                	jbe    251 <_save_level+0x4e>
 1ec:	6c                   	insb   (%dx),%es:(%edi)
 1ed:	20 63 6f             	and    %ah,0x6f(%ebx)
 1f0:	6c                   	insb   (%dx),%es:(%edi)
 1f1:	64 20 6e 6f          	and    %ch,%fs:0x6f(%esi)
 1f5:	74 20                	je     217 <_save_level+0x14>
 1f7:	62 65 65             	bound  %esp,0x65(%ebp)
 1fa:	6e                   	outsb  %ds:(%esi),(%dx)
 1fb:	20 6f 70             	and    %ch,0x70(%edi)
 1fe:	65 6e                	outsb  %gs:(%esi),(%dx)
 200:	65 64 00 55 89       	gs add %dl,%fs:%gs:-0x77(%ebp)

00000203 <_save_level>:
static char lo_colors[] = { COLOR_KEVIL, COLOR_SEVIL, COLOR_WALL, COLOR_BLACK };

int *level;

static void save_level()
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	53                   	push   %ebx
 207:	83 ec 24             	sub    $0x24,%esp
  int x,y;
  char *buffer = malloc(34);
 20a:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
 211:	e8 ea fd ff ff       	call   0 <_init_mouse>
 216:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(!buffer)
 219:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 21d:	75 31                	jne    250 <_save_level+0x4d>
  {
    LOG("Error Malloc: edit.c: save_level: buffer");
 21f:	a1 00 00 00 00       	mov    0x0,%eax
 224:	89 44 24 0c          	mov    %eax,0xc(%esp)
 228:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
 22f:	00 
 230:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 237:	00 
 238:	c7 04 24 a0 01 00 00 	movl   $0x1a0,(%esp)
 23f:	e8 bc fd ff ff       	call   0 <_init_mouse>
    exit(ERROR_MALLOC);
 244:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 24b:	e8 b0 fd ff ff       	call   0 <_init_mouse>
  }
  FILE *f = fopen("newlvl.txt", "w");
 250:	c7 44 24 04 c9 01 00 	movl   $0x1c9,0x4(%esp)
 257:	00 
 258:	c7 04 24 cb 01 00 00 	movl   $0x1cb,(%esp)
 25f:	e8 9c fd ff ff       	call   0 <_init_mouse>
 264:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(!f)
 267:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 26b:	75 31                	jne    29e <_save_level+0x9b>
  {
    LOG("File for saving level cold not been opened");
 26d:	a1 00 00 00 00       	mov    0x0,%eax
 272:	89 44 24 0c          	mov    %eax,0xc(%esp)
 276:	c7 44 24 08 2a 00 00 	movl   $0x2a,0x8(%esp)
 27d:	00 
 27e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 285:	00 
 286:	c7 04 24 d8 01 00 00 	movl   $0x1d8,(%esp)
 28d:	e8 6e fd ff ff       	call   0 <_init_mouse>
    exit(ERROR_FOPEN);
 292:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
 299:	e8 62 fd ff ff       	call   0 <_init_mouse>
  }
  for(y=0;y<20;y++)
 29e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2a5:	eb 62                	jmp    309 <_save_level+0x106>
  {
    for(x=0;x<32;x++)
 2a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2ae:	eb 2c                	jmp    2dc <_save_level+0xd9>
    {
      buffer[x] = lo[level[y*32+x]];
 2b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2b6:	01 c2                	add    %eax,%edx
 2b8:	a1 10 00 00 00       	mov    0x10,%eax
 2bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 2c0:	89 cb                	mov    %ecx,%ebx
 2c2:	c1 e3 05             	shl    $0x5,%ebx
 2c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 2c8:	01 d9                	add    %ebx,%ecx
 2ca:	c1 e1 02             	shl    $0x2,%ecx
 2cd:	01 c8                	add    %ecx,%eax
 2cf:	8b 00                	mov    (%eax),%eax
 2d1:	8a 80 00 00 00 00    	mov    0x0(%eax),%al
 2d7:	88 02                	mov    %al,(%edx)
    LOG("File for saving level cold not been opened");
    exit(ERROR_FOPEN);
  }
  for(y=0;y<20;y++)
  {
    for(x=0;x<32;x++)
 2d9:	ff 45 f4             	incl   -0xc(%ebp)
 2dc:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
 2e0:	7e ce                	jle    2b0 <_save_level+0xad>
    {
      buffer[x] = lo[level[y*32+x]];
    }
    buffer[32] = '\n';
 2e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2e5:	83 c0 20             	add    $0x20,%eax
 2e8:	c6 00 0a             	movb   $0xa,(%eax)
    buffer[33] = '\0';
 2eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2ee:	83 c0 21             	add    $0x21,%eax
 2f1:	c6 00 00             	movb   $0x0,(%eax)
    fputs(buffer, f);
 2f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2fe:	89 04 24             	mov    %eax,(%esp)
 301:	e8 fa fc ff ff       	call   0 <_init_mouse>
  if(!f)
  {
    LOG("File for saving level cold not been opened");
    exit(ERROR_FOPEN);
  }
  for(y=0;y<20;y++)
 306:	ff 45 f0             	incl   -0x10(%ebp)
 309:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
 30d:	7e 98                	jle    2a7 <_save_level+0xa4>
    }
    buffer[32] = '\n';
    buffer[33] = '\0';
    fputs(buffer, f);
  }
  fclose(f);
 30f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 312:	89 04 24             	mov    %eax,(%esp)
 315:	e8 e6 fc ff ff       	call   0 <_init_mouse>
  free(buffer);
 31a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 31d:	89 04 24             	mov    %eax,(%esp)
 320:	e8 db fc ff ff       	call   0 <_init_mouse>
}
 325:	83 c4 24             	add    $0x24,%esp
 328:	5b                   	pop    %ebx
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret    
 32b:	72 00                	jb     32d <_save_level+0x12a>
 32d:	8d 76 00             	lea    0x0(%esi),%esi
 330:	45                   	inc    %ebp
 331:	72 72                	jb     3a5 <_load_level+0x36>
 333:	6f                   	outsl  %ds:(%esi),(%dx)
 334:	72 20                	jb     356 <_save_level+0x153>
 336:	62 75 66             	bound  %esi,0x66(%ebp)
 339:	66                   	data16
 33a:	65                   	gs
 33b:	72 20                	jb     35d <_save_level+0x15a>
 33d:	63 6f 6c             	arpl   %bp,0x6c(%edi)
 340:	64 20 6e 6f          	and    %ch,%fs:0x6f(%esi)
 344:	74 20                	je     366 <_save_level+0x163>
 346:	62 65 65             	bound  %esp,0x65(%ebp)
 349:	6e                   	outsb  %ds:(%esi),(%dx)
 34a:	20 6d 61             	and    %ch,0x61(%ebp)
 34d:	6c                   	insb   (%dx),%es:(%edi)
 34e:	6c                   	insb   (%dx),%es:(%edi)
 34f:	6f                   	outsl  %ds:(%esi),(%dx)
 350:	63 27                	arpl   %sp,(%edi)
 352:	64 20 65 64          	and    %ah,%fs:0x64(%ebp)
 356:	69 74 2e 63 3a 20 6c 	imul   $0x6f6c203a,0x63(%esi,%ebp,1),%esi
 35d:	6f 
 35e:	61                   	popa   
 35f:	64                   	fs
 360:	5f                   	pop    %edi
 361:	6c                   	insb   (%dx),%es:(%edi)
 362:	65                   	gs
 363:	76 65                	jbe    3ca <_load_level+0x5b>
 365:	6c                   	insb   (%dx),%es:(%edi)
 366:	3a 20                	cmp    (%eax),%ah
 368:	62 75 66             	bound  %esi,0x66(%ebp)
 36b:	66                   	data16
 36c:	65                   	gs
 36d:	72 00                	jb     36f <_load_level>

0000036f <_load_level>:

static void load_level()
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 38             	sub    $0x38,%esp
  FILE* f = fopen("newlvl.txt", "r");
 375:	c7 44 24 04 2b 03 00 	movl   $0x32b,0x4(%esp)
 37c:	00 
 37d:	c7 04 24 cb 01 00 00 	movl   $0x1cb,(%esp)
 384:	e8 77 fc ff ff       	call   0 <_init_mouse>
 389:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int x, y, x2;
  char* buffer = malloc(64);
 38c:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
 393:	e8 68 fc ff ff       	call   0 <_init_mouse>
 398:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(!buffer)
 39b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 39f:	75 31                	jne    3d2 <_load_level+0x63>
  {
    LOG("Error buffer cold not been malloc'd edit.c: load_level: buffer");
 3a1:	a1 00 00 00 00       	mov    0x0,%eax
 3a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
 3aa:	c7 44 24 08 3e 00 00 	movl   $0x3e,0x8(%esp)
 3b1:	00 
 3b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 3b9:	00 
 3ba:	c7 04 24 30 03 00 00 	movl   $0x330,(%esp)
 3c1:	e8 3a fc ff ff       	call   0 <_init_mouse>
    exit(ERROR_MALLOC);
 3c6:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 3cd:	e8 2e fc ff ff       	call   0 <_init_mouse>
  }
  if(f)
 3d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 3d6:	0f 84 c4 00 00 00    	je     4a0 <_load_level+0x131>
  {
    y=0;
 3dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(!feof(f))
 3e3:	e9 94 00 00 00       	jmp    47c <_load_level+0x10d>
    {
      if(!fgets(buffer, 64, f)) break;
 3e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 3eb:	89 44 24 08          	mov    %eax,0x8(%esp)
 3ef:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
 3f6:	00 
 3f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3fa:	89 04 24             	mov    %eax,(%esp)
 3fd:	e8 fe fb ff ff       	call   0 <_init_mouse>
 402:	85 c0                	test   %eax,%eax
 404:	0f 84 87 00 00 00    	je     491 <_load_level+0x122>
      for(x=0;x<32;x++)
 40a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 411:	eb 57                	jmp    46a <_load_level+0xfb>
      {
        if(buffer[x])
 413:	8b 55 f4             	mov    -0xc(%ebp),%edx
 416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 419:	01 d0                	add    %edx,%eax
 41b:	8a 00                	mov    (%eax),%al
 41d:	84 c0                	test   %al,%al
 41f:	74 51                	je     472 <_load_level+0x103>
        {
          for(x2=0;x2<4;x2++)
 421:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 428:	eb 37                	jmp    461 <_load_level+0xf2>
          {
            if(lo[x2] == buffer[x])
 42a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42d:	05 00 00 00 00       	add    $0x0,%eax
 432:	8a 10                	mov    (%eax),%dl
 434:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 43a:	01 c8                	add    %ecx,%eax
 43c:	8a 00                	mov    (%eax),%al
 43e:	38 c2                	cmp    %al,%dl
 440:	75 1c                	jne    45e <_load_level+0xef>
            {
              level[y*32+x] = x2;
 442:	a1 10 00 00 00       	mov    0x10,%eax
 447:	8b 55 f0             	mov    -0x10(%ebp),%edx
 44a:	89 d1                	mov    %edx,%ecx
 44c:	c1 e1 05             	shl    $0x5,%ecx
 44f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 452:	01 ca                	add    %ecx,%edx
 454:	c1 e2 02             	shl    $0x2,%edx
 457:	01 c2                	add    %eax,%edx
 459:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45c:	89 02                	mov    %eax,(%edx)
      if(!fgets(buffer, 64, f)) break;
      for(x=0;x<32;x++)
      {
        if(buffer[x])
        {
          for(x2=0;x2<4;x2++)
 45e:	ff 45 ec             	incl   -0x14(%ebp)
 461:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
 465:	7e c3                	jle    42a <_load_level+0xbb>
  {
    y=0;
    while(!feof(f))
    {
      if(!fgets(buffer, 64, f)) break;
      for(x=0;x<32;x++)
 467:	ff 45 f4             	incl   -0xc(%ebp)
 46a:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
 46e:	7e a3                	jle    413 <_load_level+0xa4>
 470:	eb 01                	jmp    473 <_load_level+0x104>
            {
              level[y*32+x] = x2;
            }
          }
        } else {
          break;
 472:	90                   	nop
        }
      }
      y++;
 473:	ff 45 f0             	incl   -0x10(%ebp)
      if(y>=20) break;
 476:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
 47a:	7f 18                	jg     494 <_load_level+0x125>
    exit(ERROR_MALLOC);
  }
  if(f)
  {
    y=0;
    while(!feof(f))
 47c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 47f:	89 04 24             	mov    %eax,(%esp)
 482:	e8 79 fb ff ff       	call   0 <_init_mouse>
 487:	85 c0                	test   %eax,%eax
 489:	0f 84 59 ff ff ff    	je     3e8 <_load_level+0x79>
 48f:	eb 04                	jmp    495 <_load_level+0x126>
    {
      if(!fgets(buffer, 64, f)) break;
 491:	90                   	nop
 492:	eb 01                	jmp    495 <_load_level+0x126>
        } else {
          break;
        }
      }
      y++;
      if(y>=20) break;
 494:	90                   	nop
    }
    fclose(f);
 495:	8b 45 e8             	mov    -0x18(%ebp),%eax
 498:	89 04 24             	mov    %eax,(%esp)
 49b:	e8 60 fb ff ff       	call   0 <_init_mouse>
  }
  free(buffer);
 4a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a3:	89 04 24             	mov    %eax,(%esp)
 4a6:	e8 55 fb ff ff       	call   0 <_init_mouse>
}
 4ab:	c9                   	leave  
 4ac:	c3                   	ret    
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
 4b0:	6c                   	insb   (%dx),%es:(%edi)
 4b1:	65                   	gs
 4b2:	76 65                	jbe    519 <_load_level+0x1aa>
 4b4:	6c                   	insb   (%dx),%es:(%edi)
 4b5:	20 63 6f             	and    %ah,0x6f(%ebx)
 4b8:	6c                   	insb   (%dx),%es:(%edi)
 4b9:	64 20 6e 6f          	and    %ch,%fs:0x6f(%esi)
 4bd:	74 20                	je     4df <_load_level+0x170>
 4bf:	62 65 65             	bound  %esp,0x65(%ebp)
 4c2:	6e                   	outsb  %ds:(%esi),(%dx)
 4c3:	20 6d 61             	and    %ch,0x61(%ebp)
 4c6:	6c                   	insb   (%dx),%es:(%edi)
 4c7:	6c                   	insb   (%dx),%es:(%edi)
 4c8:	6f                   	outsl  %ds:(%esi),(%dx)
 4c9:	63 27                	arpl   %sp,(%edi)
 4cb:	64 20 61 74          	and    %ah,%fs:0x74(%ecx)
 4cf:	20 65 64             	and    %ah,0x64(%ebp)
 4d2:	69 74 2e 63 3a 20 67 	imul   $0x6f67203a,0x63(%esi,%ebp,1),%esi
 4d9:	6f 
 4da:	5f                   	pop    %edi
 4db:	65 64 69 74 3a 20 6c 	gs imul $0x6576656c,%fs:%gs:0x20(%edx,%edi,1),%esi
 4e2:	65 76 65 
 4e5:	6c                   	insb   (%dx),%es:(%edi)
 4e6:	00 90 65 64 69 74    	add    %dl,0x74696465(%eax)
 4ec:	2e 63 3a             	arpl   %di,%cs:(%edx)
 4ef:	20 49 6e             	and    %cl,0x6e(%ecx)
 4f2:	76 61                	jbe    555 <_go_edit+0x36>
 4f4:	6c                   	insb   (%dx),%es:(%edi)
 4f5:	69 64 20 63 6f 6e 74 	imul   $0x65746e6f,0x63(%eax,%eiz,1),%esp
 4fc:	65 
 4fd:	6e                   	outsb  %ds:(%esi),(%dx)
 4fe:	74 20                	je     520 <_go_edit+0x1>
 500:	6f                   	outsl  %ds:(%esi),(%dx)
 501:	66                   	data16
 502:	20 6c 65 76          	and    %ch,0x76(%ebp,%eiz,2)
 506:	65                   	gs
 507:	6c                   	insb   (%dx),%es:(%edi)
 508:	21 00                	and    %eax,(%eax)
 50a:	46                   	inc    %esi
 50b:	72 61                	jb     56e <_go_edit+0x4f>
 50d:	6d                   	insl   (%dx),%es:(%edi)
 50e:	65 62 75 66          	bound  %esi,%gs:0x66(%ebp)
 512:	66                   	data16
 513:	65                   	gs
 514:	72 20                	jb     536 <_go_edit+0x17>
 516:	74 6f                	je     587 <_go_edit+0x68>
 518:	20 73 6d             	and    %dh,0x6d(%ebx)
 51b:	61                   	popa   
 51c:	6c                   	insb   (%dx),%es:(%edi)
 51d:	6c                   	insb   (%dx),%es:(%edi)
	...

0000051f <_go_edit>:

void go_edit()
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	83 ec 48             	sub    $0x48,%esp
  if(init_mouse()) exit(ERROR_MOUSE);
 525:	e8 d6 fa ff ff       	call   0 <_init_mouse>
 52a:	85 c0                	test   %eax,%eax
 52c:	74 0c                	je     53a <_go_edit+0x1b>
 52e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 535:	e8 c6 fa ff ff       	call   0 <_init_mouse>
  level = malloc(sizeof(int)*32*20);
 53a:	c7 04 24 00 0a 00 00 	movl   $0xa00,(%esp)
 541:	e8 ba fa ff ff       	call   0 <_init_mouse>
 546:	a3 10 00 00 00       	mov    %eax,0x10
  if(!level)
 54b:	a1 10 00 00 00       	mov    0x10,%eax
 550:	85 c0                	test   %eax,%eax
 552:	75 31                	jne    585 <_go_edit+0x66>
  {
    LOG("level cold not been malloc'd at edit.c: go_edit: level");
 554:	a1 00 00 00 00       	mov    0x0,%eax
 559:	89 44 24 0c          	mov    %eax,0xc(%esp)
 55d:	c7 44 24 08 36 00 00 	movl   $0x36,0x8(%esp)
 564:	00 
 565:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 56c:	00 
 56d:	c7 04 24 b0 04 00 00 	movl   $0x4b0,(%esp)
 574:	e8 87 fa ff ff       	call   0 <_init_mouse>
    exit(ERROR_MALLOC);
 579:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 580:	e8 7b fa ff ff       	call   0 <_init_mouse>
  }
  int sel = 0;
 585:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int x, y, x2, y2;
  char col;
  for(x=0;x<32*20;x++) level[x] = 3;
 58c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 593:	eb 16                	jmp    5ab <_go_edit+0x8c>
 595:	a1 10 00 00 00       	mov    0x10,%eax
 59a:	8b 55 f0             	mov    -0x10(%ebp),%edx
 59d:	c1 e2 02             	shl    $0x2,%edx
 5a0:	01 d0                	add    %edx,%eax
 5a2:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
 5a8:	ff 45 f0             	incl   -0x10(%ebp)
 5ab:	81 7d f0 7f 02 00 00 	cmpl   $0x27f,-0x10(%ebp)
 5b2:	7e e1                	jle    595 <_go_edit+0x76>

  load_level();
 5b4:	e8 b6 fd ff ff       	call   36f <_load_level>
  
  while(!esc)
 5b9:	e9 18 03 00 00       	jmp    8d6 <_go_edit+0x3b7>
  {
    for(y=0;y<20;y++)
 5be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 5c5:	e9 60 01 00 00       	jmp    72a <_go_edit+0x20b>
    {
      for(x=0;x<32;x++)
 5ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5d1:	e9 47 01 00 00       	jmp    71d <_go_edit+0x1fe>
      {
        if(level[y*32+x] > 3)
 5d6:	a1 10 00 00 00       	mov    0x10,%eax
 5db:	8b 55 ec             	mov    -0x14(%ebp),%edx
 5de:	89 d1                	mov    %edx,%ecx
 5e0:	c1 e1 05             	shl    $0x5,%ecx
 5e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
 5e6:	01 ca                	add    %ecx,%edx
 5e8:	c1 e2 02             	shl    $0x2,%edx
 5eb:	01 d0                	add    %edx,%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	83 f8 03             	cmp    $0x3,%eax
 5f2:	7e 2b                	jle    61f <_go_edit+0x100>
        {
          LOG("edit.c: Invalid content of level!");
 5f4:	a1 00 00 00 00       	mov    0x0,%eax
 5f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
 5fd:	c7 44 24 08 21 00 00 	movl   $0x21,0x8(%esp)
 604:	00 
 605:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 60c:	00 
 60d:	c7 04 24 e8 04 00 00 	movl   $0x4e8,(%esp)
 614:	e8 e7 f9 ff ff       	call   0 <_init_mouse>
          col=3;
 619:	c6 45 e3 03          	movb   $0x3,-0x1d(%ebp)
 61d:	eb 22                	jmp    641 <_go_edit+0x122>
        } else {
          col = lo_colors[level[y*32+x]];
 61f:	a1 10 00 00 00       	mov    0x10,%eax
 624:	8b 55 ec             	mov    -0x14(%ebp),%edx
 627:	89 d1                	mov    %edx,%ecx
 629:	c1 e1 05             	shl    $0x5,%ecx
 62c:	8b 55 f0             	mov    -0x10(%ebp),%edx
 62f:	01 ca                	add    %ecx,%edx
 631:	c1 e2 02             	shl    $0x2,%edx
 634:	01 d0                	add    %edx,%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	8a 80 04 00 00 00    	mov    0x4(%eax),%al
 63e:	88 45 e3             	mov    %al,-0x1d(%ebp)
        }
        for(y2=0;y2<10;y2++)
 641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 648:	e9 c3 00 00 00       	jmp    710 <_go_edit+0x1f1>
        {
          for(x2=0;x2<10;x2++)
 64d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 654:	e9 aa 00 00 00       	jmp    703 <_go_edit+0x1e4>
          {
            if((y*10+y2)*320+x*10+x2 >= 320*200) {
 659:	8b 55 ec             	mov    -0x14(%ebp),%edx
 65c:	89 d0                	mov    %edx,%eax
 65e:	c1 e0 02             	shl    $0x2,%eax
 661:	01 d0                	add    %edx,%eax
 663:	01 c0                	add    %eax,%eax
 665:	89 c2                	mov    %eax,%edx
 667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66a:	01 c2                	add    %eax,%edx
 66c:	89 d0                	mov    %edx,%eax
 66e:	c1 e0 02             	shl    $0x2,%eax
 671:	01 d0                	add    %edx,%eax
 673:	c1 e0 06             	shl    $0x6,%eax
 676:	89 c1                	mov    %eax,%ecx
 678:	8b 55 f0             	mov    -0x10(%ebp),%edx
 67b:	89 d0                	mov    %edx,%eax
 67d:	c1 e0 02             	shl    $0x2,%eax
 680:	01 d0                	add    %edx,%eax
 682:	01 c0                	add    %eax,%eax
 684:	8d 14 01             	lea    (%ecx,%eax,1),%edx
 687:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68a:	01 d0                	add    %edx,%eax
 68c:	3d ff f9 00 00       	cmp    $0xf9ff,%eax
 691:	7e 31                	jle    6c4 <_go_edit+0x1a5>
              LOG("Framebuffer to small");
 693:	a1 00 00 00 00       	mov    0x0,%eax
 698:	89 44 24 0c          	mov    %eax,0xc(%esp)
 69c:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
 6a3:	00 
 6a4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 6ab:	00 
 6ac:	c7 04 24 0a 05 00 00 	movl   $0x50a,(%esp)
 6b3:	e8 48 f9 ff ff       	call   0 <_init_mouse>
              exit(ERROR_OVERFLOW);
 6b8:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
 6bf:	e8 3c f9 ff ff       	call   0 <_init_mouse>
            }
            framebuffer[(y*10+y2)*320+x*10+x2] = col;
 6c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 6c7:	89 d0                	mov    %edx,%eax
 6c9:	c1 e0 02             	shl    $0x2,%eax
 6cc:	01 d0                	add    %edx,%eax
 6ce:	01 c0                	add    %eax,%eax
 6d0:	89 c2                	mov    %eax,%edx
 6d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	89 d0                	mov    %edx,%eax
 6d9:	c1 e0 02             	shl    $0x2,%eax
 6dc:	01 d0                	add    %edx,%eax
 6de:	c1 e0 06             	shl    $0x6,%eax
 6e1:	89 c1                	mov    %eax,%ecx
 6e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
 6e6:	89 d0                	mov    %edx,%eax
 6e8:	c1 e0 02             	shl    $0x2,%eax
 6eb:	01 d0                	add    %edx,%eax
 6ed:	01 c0                	add    %eax,%eax
 6ef:	8d 14 01             	lea    (%ecx,%eax,1),%edx
 6f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f5:	01 c2                	add    %eax,%edx
 6f7:	8a 45 e3             	mov    -0x1d(%ebp),%al
 6fa:	88 82 00 00 00 00    	mov    %al,0x0(%edx)
        } else {
          col = lo_colors[level[y*32+x]];
        }
        for(y2=0;y2<10;y2++)
        {
          for(x2=0;x2<10;x2++)
 700:	ff 45 e8             	incl   -0x18(%ebp)
 703:	83 7d e8 09          	cmpl   $0x9,-0x18(%ebp)
 707:	0f 8e 4c ff ff ff    	jle    659 <_go_edit+0x13a>
          LOG("edit.c: Invalid content of level!");
          col=3;
        } else {
          col = lo_colors[level[y*32+x]];
        }
        for(y2=0;y2<10;y2++)
 70d:	ff 45 e4             	incl   -0x1c(%ebp)
 710:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 714:	0f 8e 33 ff ff ff    	jle    64d <_go_edit+0x12e>
  
  while(!esc)
  {
    for(y=0;y<20;y++)
    {
      for(x=0;x<32;x++)
 71a:	ff 45 f0             	incl   -0x10(%ebp)
 71d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
 721:	0f 8e af fe ff ff    	jle    5d6 <_go_edit+0xb7>

  load_level();
  
  while(!esc)
  {
    for(y=0;y<20;y++)
 727:	ff 45 ec             	incl   -0x14(%ebp)
 72a:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
 72e:	0f 8e 96 fe ff ff    	jle    5ca <_go_edit+0xab>
            framebuffer[(y*10+y2)*320+x*10+x2] = col;
          }
        }
      }
    }
    draw_grid();
 734:	e8 c9 f9 ff ff       	call   102 <_draw_grid>
    update_mouse();
 739:	e8 f8 f8 ff ff       	call   36 <_update_mouse>
    if(mouse_btn & 2)
 73e:	a1 10 00 00 00       	mov    0x10,%eax
 743:	83 e0 02             	and    $0x2,%eax
 746:	85 c0                	test   %eax,%eax
 748:	74 26                	je     770 <_go_edit+0x251>
    {
      sel++;
 74a:	ff 45 f4             	incl   -0xc(%ebp)
      if(sel>3) sel=0;
 74d:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
 751:	7e 10                	jle    763 <_go_edit+0x244>
 753:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      while(mouse_btn & 2) update_mouse();
 75a:	eb 07                	jmp    763 <_go_edit+0x244>
 75c:	e8 d5 f8 ff ff       	call   36 <_update_mouse>
 761:	eb 01                	jmp    764 <_go_edit+0x245>
 763:	90                   	nop
 764:	a1 10 00 00 00       	mov    0x10,%eax
 769:	83 e0 02             	and    $0x2,%eax
 76c:	85 c0                	test   %eax,%eax
 76e:	75 ec                	jne    75c <_go_edit+0x23d>
    }
    if(mouse_btn & 1)
 770:	a1 10 00 00 00       	mov    0x10,%eax
 775:	83 e0 01             	and    $0x1,%eax
 778:	85 c0                	test   %eax,%eax
 77a:	0f 84 96 00 00 00    	je     816 <_go_edit+0x2f7>
    {
      x = mouse_x/10;
 780:	8b 0d 10 00 00 00    	mov    0x10,%ecx
 786:	ba 67 66 66 66       	mov    $0x66666667,%edx
 78b:	89 c8                	mov    %ecx,%eax
 78d:	f7 ea                	imul   %edx
 78f:	c1 fa 02             	sar    $0x2,%edx
 792:	89 c8                	mov    %ecx,%eax
 794:	c1 f8 1f             	sar    $0x1f,%eax
 797:	89 d1                	mov    %edx,%ecx
 799:	29 c1                	sub    %eax,%ecx
 79b:	89 c8                	mov    %ecx,%eax
 79d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      y = mouse_y/10;
 7a0:	8b 0d 10 00 00 00    	mov    0x10,%ecx
 7a6:	ba 67 66 66 66       	mov    $0x66666667,%edx
 7ab:	89 c8                	mov    %ecx,%eax
 7ad:	f7 ea                	imul   %edx
 7af:	c1 fa 02             	sar    $0x2,%edx
 7b2:	89 c8                	mov    %ecx,%eax
 7b4:	c1 f8 1f             	sar    $0x1f,%eax
 7b7:	89 d1                	mov    %edx,%ecx
 7b9:	29 c1                	sub    %eax,%ecx
 7bb:	89 c8                	mov    %ecx,%eax
 7bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      x %= 32;
 7c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c3:	89 c2                	mov    %eax,%edx
 7c5:	c1 fa 1f             	sar    $0x1f,%edx
 7c8:	c1 ea 1b             	shr    $0x1b,%edx
 7cb:	01 d0                	add    %edx,%eax
 7cd:	83 e0 1f             	and    $0x1f,%eax
 7d0:	29 d0                	sub    %edx,%eax
 7d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      y %= 20;
 7d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d8:	b9 14 00 00 00       	mov    $0x14,%ecx
 7dd:	89 c2                	mov    %eax,%edx
 7df:	c1 fa 1f             	sar    $0x1f,%edx
 7e2:	f7 f9                	idiv   %ecx
 7e4:	89 55 ec             	mov    %edx,-0x14(%ebp)
      level[y*32+x] = sel;
 7e7:	a1 10 00 00 00       	mov    0x10,%eax
 7ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ef:	89 d1                	mov    %edx,%ecx
 7f1:	c1 e1 05             	shl    $0x5,%ecx
 7f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 7f7:	01 ca                	add    %ecx,%edx
 7f9:	c1 e2 02             	shl    $0x2,%edx
 7fc:	01 c2                	add    %eax,%edx
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	89 02                	mov    %eax,(%edx)
      while(mouse_btn & 1) update_mouse();
 803:	eb 05                	jmp    80a <_go_edit+0x2eb>
 805:	e8 2c f8 ff ff       	call   36 <_update_mouse>
 80a:	a1 10 00 00 00       	mov    0x10,%eax
 80f:	83 e0 01             	and    $0x1,%eax
 812:	85 c0                	test   %eax,%eax
 814:	75 ef                	jne    805 <_go_edit+0x2e6>
    }
    if(mouse_x>2 && mouse_y>2)
 816:	a1 10 00 00 00       	mov    0x10,%eax
 81b:	83 f8 02             	cmp    $0x2,%eax
 81e:	7e 4b                	jle    86b <_go_edit+0x34c>
 820:	a1 10 00 00 00       	mov    0x10,%eax
 825:	83 f8 02             	cmp    $0x2,%eax
 828:	7e 41                	jle    86b <_go_edit+0x34c>
      draw_rect(mouse_x-2, mouse_y-2, 4, 4, lo_colors[sel]);
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	05 04 00 00 00       	add    $0x4,%eax
 832:	8a 00                	mov    (%eax),%al
 834:	0f be c0             	movsbl %al,%eax
 837:	8b 15 10 00 00 00    	mov    0x10,%edx
 83d:	8d 4a fe             	lea    -0x2(%edx),%ecx
 840:	8b 15 10 00 00 00    	mov    0x10,%edx
 846:	83 ea 02             	sub    $0x2,%edx
 849:	89 44 24 10          	mov    %eax,0x10(%esp)
 84d:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
 854:	00 
 855:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 85c:	00 
 85d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 861:	89 14 24             	mov    %edx,(%esp)
 864:	e8 97 f7 ff ff       	call   0 <_init_mouse>
 869:	eb 38                	jmp    8a3 <_go_edit+0x384>
    else
      draw_rect(mouse_x, mouse_y, 2, 2, lo_colors[sel]);
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	05 04 00 00 00       	add    $0x4,%eax
 873:	8a 00                	mov    (%eax),%al
 875:	0f be c8             	movsbl %al,%ecx
 878:	8b 15 10 00 00 00    	mov    0x10,%edx
 87e:	a1 10 00 00 00       	mov    0x10,%eax
 883:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 887:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 88e:	00 
 88f:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
 896:	00 
 897:	89 54 24 04          	mov    %edx,0x4(%esp)
 89b:	89 04 24             	mov    %eax,(%esp)
 89e:	e8 5d f7 ff ff       	call   0 <_init_mouse>
    draw();
 8a3:	e8 58 f7 ff ff       	call   0 <_init_mouse>
    if(key_p)
 8a8:	a1 00 00 00 00       	mov    0x0,%eax
 8ad:	85 c0                	test   %eax,%eax
 8af:	74 25                	je     8d6 <_go_edit+0x3b7>
    {
      save_level();
 8b1:	e8 4d f9 ff ff       	call   203 <_save_level>
      run_level("newlvl.txt");
 8b6:	c7 04 24 cb 01 00 00 	movl   $0x1cb,(%esp)
 8bd:	e8 3e f7 ff ff       	call   0 <_init_mouse>
      while(key_p);
 8c2:	90                   	nop
 8c3:	a1 00 00 00 00       	mov    0x0,%eax
 8c8:	85 c0                	test   %eax,%eax
 8ca:	75 f7                	jne    8c3 <_go_edit+0x3a4>
      while(esc);
 8cc:	90                   	nop
 8cd:	a1 00 00 00 00       	mov    0x0,%eax
 8d2:	85 c0                	test   %eax,%eax
 8d4:	75 f7                	jne    8cd <_go_edit+0x3ae>
  char col;
  for(x=0;x<32*20;x++) level[x] = 3;

  load_level();
  
  while(!esc)
 8d6:	a1 00 00 00 00       	mov    0x0,%eax
 8db:	85 c0                	test   %eax,%eax
 8dd:	0f 84 db fc ff ff    	je     5be <_go_edit+0x9f>
      while(key_p);
      while(esc);
    }
  }

  save_level();
 8e3:	e8 1b f9 ff ff       	call   203 <_save_level>
  free(level);
 8e8:	a1 10 00 00 00       	mov    0x10,%eax
 8ed:	89 04 24             	mov    %eax,(%esp)
 8f0:	e8 0b f7 ff ff       	call   0 <_init_mouse>
}
 8f5:	c9                   	leave  
 8f6:	c3                   	ret    
 8f7:	90                   	nop
 8f8:	90                   	nop
 8f9:	90                   	nop
 8fa:	90                   	nop
 8fb:	90                   	nop
 8fc:	90                   	nop
 8fd:	90                   	nop
 8fe:	90                   	nop
 8ff:	90                   	nop
