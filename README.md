### 实验一问题清单

#### 0. 关于NASM的一些参考

- [NASM Tutorial](https://asmtutor.com/)
- [NASM汇编随笔]( https://blog.csdn.net/HermitSun/article/details/101835258 )

#### 1. 请简述80x86 系列的发展历史

1978年6月，Intel公司推出了它的第一个16位微处理器8086。8086的位长为16位，采用了20条地址线，可以寻址的范围为220个字节地址，即1 MB。

1982年，发布了80286处理器，主频提高到了12 MHz。

1985年，推出了32位的80386处理器，地址线扩展到32条，直接寻址的能力达到4 GB。80386处理器在设计的时候考虑了多用户及多任务的需要，在芯片中增加了保护模式、优先级、任务切换和片内的存储单元管理等硬件单元。80386的出现使Windows和UNIX等多任务的操作系统可以在PC上运行。直到现在，运行于80x86处理器之上的多任务操作系统都是以80386的运行模式为基础的。

1989年，Intel公司推出80486处理器，在芯片内集成了浮点处理器和8 KB的一级缓存。80486处理器开始使用流水线技术。为了使计算机中的其他部件不至于成为CPU速度发展的瓶颈，80486处理器开始使用了倍频技术，即让处理器速度（CPU主频）数倍于系统总线速度（外频）。

1993年3月Intel公司推出80586处理器。由于无法阻止其他公司把自己的兼容产品也叫做x86，所以把产品取名为Pentium，并且进行了商标注册，同时启用了中文名称“奔腾”。Pentium处理器采用许多新技术，其中最重要的变化是采用了超标量体系结构。即将两个同时工作的指令执行部件封装在同一芯片中，用两条并行的通道来执行指令，这相当于两个CPU同时工作，大大提高了处理速度。

Intel的80x86系列处理器看起来属于CISC体系，但实际上，从Pentium处理器开始，都已不是单纯的CISC体系了。因为它们引入了很多RISC体系里的先进技术来大幅度提高性能。但是，好马也得配好鞍——没有软件支持的CPU再快也不是好CPU。为了兼容已有的软件，80x86系列处理器也不得不背上沉重的历史包袱。如CPU的位长还是停留在32位；在寄存器、运行模式与内存管理模式等方面还是继承了早期的80386模式；80386以后的处理器虽然增加了不少新指令，但大多用于多媒体扩展，其中很少有和操作系统密切相关的指令。所以，如果不涉及3D及密集运算方面的运算，仅从操作系统的角度看，这些处理器只能算是一个快速的80386处理器而已。  

##### 参考

- [80x86系列处理器简史](https://bbs.pediy.com/thread-197638.htm)

#### 2. 说明小端和大端的区别，并说明80x86 系列采用了哪种方式？

##### 小端存储

数据的高字节保存在内存的高地址中，而数据的低字节保存在内存的低地址中。

| 地址   | 数据 |
| ------ | ---- |
| buf[0] | 0x78 |
| buf[1] | 0x56 |
| buf[2] | 0x34 |
| buf[3] | 0x12 |

##### 大端存储

数据的高字节保存在内存的低地址中，而数据的低字节保存在内存的高地址中，符合人的阅读习惯。

| 地址   | 数据 |
| ------ | ---- |
| buf[0] | 0x12 |
| buf[1] | 0x34 |
| buf[2] | 0x56 |
| buf[3] | 0x78 |

##### 80x86

采用小端存储。所以在进行byte操作时，一般使用al寄存器。

#### 3. 8086 有哪五类寄存器，请分别举例说明其作用？

![图片1.png](https://i.loli.net/2019/10/03/rzBdVpYeP8A2HXi.png)

##### 数据寄存器

用于存储一般的数据。当然，EAX和EDX在乘除法时有特殊用途。

##### ESP寄存器

指向栈顶。

##### EBP寄存器

指向栈底。

##### ESI、EDI寄存器

事实上，ESI、EDI还是通用寄存器，只是在某些指令中有要求。

> 在8086CPU中，只有bx、si、di、bp寄存器可以在“[…]”中来进行内存单元的寻址，比如下面指令是正确的：
>
> ```assembly
> MOV      AX,        [BX + SI]
> MOV      AX,        [BX + DI]
> MOV      AX,        [BP]
> MOV      AX,        [BP + SI]
> MOV      AX,        [BP + DI]
> ```

##### IP寄存器

指向下一条指令（偏移量）。

`CS:IP`通过地址加法器得到下一行代码的物理地址，决定了下面执行哪行代码。

###### 地址加法器合成物理地址

物理地址=段地址*16+偏移地址

##### FLAG寄存器

通常情况下，由cmp指令置位，用于条件跳转。

进位标志CF（Carry Flag）

奇偶标志PF（Parity Flag）

> 奇偶标志PF用于反映运算结果中“1”的个数的奇偶性。如果“1”的个数为偶数，则PF的值为1，否则其值为0。利用PF可进行奇偶校验检查

零标志ZF（Zero Flag）

符号标志SF（Sign Flag）

> 符号标志SF用来反映运算结果的符号位，它与运算结果的最高位相同。运算结果为正数时，SF的值为0，否则其值为1。

溢出标志OF（Overflow Flag）

##### 段寄存器

表明某一段的起始地址（高16位），和IP结合可以访问各个区域的内容。比如，`CS:IP`可以用于语句跳转，`DS:IP`可以用于访问数据，SS

#### 4. 什么是寻址？立即寻址和直接寻址的区别是什么？

##### 寻址

找到操作数的地址（从而能够取出操作数）叫做寻址。

##### 立即寻址

```assembly
mov eax, 0x1234
```

坦率地讲，并没有寻址的过程，而是直接把需要的操作数放进了寄存器里。

##### 直接寻址

```assembly
mov eax, [0x1234]
```

直接给出了目标地址，然后从给定的地址里取出操作数放进寄存器。

#### 5. 请举例说明寄存器间接寻址、寄存器相对寻址、基址加变址寻址、相对基址加变址寻址四种方式的区别

##### 寄存器间接寻址

```assembly
mov	ax, [bx]     
```

##### 寄存器相对寻址

```assembly
mov	ax, [si + 3]
```

##### 基址加变址

```
mov	ax, [bx + di]
```

##### 相对基址加变址

```assembly
mov	ax, [bx + di + 3]
```

#### 6. 请分别简述MOV 指令和LEA 指令的用法和作用？

##### 用法

顾名思义，LEA，Load Effective Address，取有效地址，自然是取对应的地址了。

LEA指令可以用来将一个内存地址直接赋给目的操作数，例如：

```assembly
lea eax, [ebx+8]
```

就是将ebx+8这个值直接赋给eax，而不是把ebx+8处的内存地址里的数据赋给eax。

而MOV指令则恰恰相反，是对地址里的数据进行赋值：

```assembly
mov eax, [ebx+8]
```

如果用C语言来表述：

`lea eax,[eax+2*eax]`的效果是`eax = eax + eax * 2`

`mov edx [ebp+16]`的效果是`edx=*(dword*)(ebp+16)`

也就是说，“LEA不解引用”。

##### 区别

这两者之间的重要区别在对`[]`运算符的处理。对于MOV指令，加`[]`是取值，不加`[]`是地址；而对于LEA来说，加`[]`是地址，不加`[]`是值。

对于mov指令来说，有没有[]对于变量是无所谓的，其结果都是取值； 对于寄存器而言，有[]表示取地址，没[]表示取值。

对于lea指令来说，有没有[]对于变量是无所谓的，其结果都是取变量的地址，相当于指针（与mov相反）；对于寄存器而言，有[]表示取值，没[]表示取地址。

##### 参考

- [汇编语言中mov和lea的区别有哪些](https://www.zhihu.com/question/40720890)
- [总结一下汇编中mov,lea指令的区别](https://www.cnblogs.com/codechild/p/6638861.html)

​                      有没有[]对于变量是无所谓的，其结果都是取变量的地址，相当于指针（与mov相反）

#### 7. 请说出主程序与子程序之间至少三种参数传递方式

- 寄存器传递

  - 寄存器数量有限，导致能传递的参数有限

- 约定地址传递

  - 需要确保约定的地址安全、可用

- 栈传递

  - ```assembly
    _start:
    	push eax	; store the arg
    ; ...
    func:
    	pop  eax	; get the arg
    ```

#### 8. 如何处理输入和输出，代码中哪里体现出来？

通过系统调用，3号sys_read和4号sys_write。

| 名称      | eax     | ebx                            | ecx                                 | edx                       |
| --------- | ------- | ------------------------------ | ----------------------------------- | ------------------------- |
| sys_read  | 调用号3 | 文件描述符<br/>unsigned int fd | 文件地址<br/>char __user *buf       | 文件长度<br/>size_t count |
| sys_write | 调用号4 | 文件描述符<br/>unsigned int fd | 文件地址<br/>const char __user *buf | 文件长度<br/>size_t count |

至于代码，简单说来：

```assembly
SECTION .data
	msg		db	"Hello World!", 0H
SECTION	.bss
	input	db	255
SECTION .text
	global	_start
_start:
	; output
	mov	edx, 13
	mov	ecx, msg
	mov	ebx, 1		; STDOUT
	mov	eax, 4
	; input
	mov	edx, 255
	mov	ecx, input
	mov	ebx, 0		; STDIN
	mov	eax, 3
```

#### 9. 有哪些段寄存器

CS 代码段寄存器（Code）

DS 数据段寄存器（Data）

SS 堆栈段寄存器（Stack）

ES 附加段寄存器（Extension）

#### 10. 通过什么寄存器保存前一次的运算结果，在代码中哪里体现出来。

坦率地讲，如果是数值运算（尤其是乘除法），会放在eax里；因为eax是累加寄存器。

```assembly
add	eax, ebx	; eax += ebx
sub	eax, ebx	; eax -= ebx
mul	ebx			; eax *= ebx
div	ebx			; eax /= ebx
```

除法还有一点不同，商在eax里，余数在ebx里。

#### 11. 解释boot.asm 文件中，org 0700h 的作用

告诉编译器，接下来的代码从地址0x0700开始，为了符合和硬件厂商的约定。

如果不加这一行，代码会被加载到地址0x0000处。

#### 12. boot.bin 应该放在软盘的哪一个扇区？为什么？

0面0磁道1扇区，因为引导扇区是第一个扇区。从指令里也可以看出来：

```assembly
dd if=boot.bin of=a.img bs=512 count=1 conv=notrunc
```

11、12两个问题问的其实是同一个，就是BIOS的加载过程：

> BIOS程序检查软盘0面0磁道1扇区，如果扇区以0xAA55结束，则认定为引导扇区，将其512字节的数据加载到内存的0x7C00处，然后设置PC，跳到内存0x7C00处开始执行代码。

#### 13. loader 的作用有哪些？

##### 突破512B限制

除了加载内核，还要准备保护模式等，512字节显然不够。也就是说，需要一个在boot和kernel之间的broker。

##### 进入保护模式

最开始的8086处理器只有16位，寄存器用ax, bx等表示，称为实模式。后来扩充成32位，eax，ebx等，为了向前兼容，提出了保护模式。必须从实模式跳转到保护模式，才能访问1M以上的内存。

##### 启动内存分页

……

##### 加载内核

引导扇区将loader加载入内存，并转交控制权，由loader将操作系统内核kernel加载入内存并启动。

因为文件格式的问题，内核并不能像boot.bin或loader.bin那样直接放入内存中，需要loader从kernel.bin中提取出需要放入内存中的部分。

#### 14. 解释NASM 语言中[ ] 的作用

取出对应地址中的值，类似于指针解引用。

> Memory access (use register as pointer): "[rax]".  Same as C "*rax".
> Memory access with offset (use register + offset as pointer): "[rax+4]".  Same as C "*(rax+4)".
> Memory access with scaled index (register + another register * scale): "[rax+rbx*4]".  Same as C "*(rax+rbx*4)".

##### 参考

- [x86_64 NASM Assembly Quick Reference](https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html?tdsourcetag=s_pctim_aiomsg)

#### 15. 解释语句times 510-($-$$) db 0，为什么是510? $ 和$$ 分别表示什么？

times表示重复执行，相当于重复执行`510-($-$$)`次`db 0`语句。

为什么是510？因为第一个扇区一共512B，最后标志引导扇区结束的`dw 0xAA55`需要两个B，就剩下510B了。

`$`代表当前行，`$$`代表当前`SECTION`的第一行。

#### 16. 解释配置文件bochsrc文件中各参数的含义

##### megs:32

分配需要模拟的内存量，这里是32M。megs指令将guest和host的内存量设为相同，如果需要不同的内存量需要使用memory指令。

> megs: This option sets the 'guest' and 'host' memory parameters to the same value. In all other cases the 'memory' option should be used instead.
>
> memory: Set the amount of physical memory you want to emulate.

###### 关于guest和host

![Guest_os_diagram.jpg](https://i.loli.net/2019/10/03/nWjeNCDhPpSf8sU.jpg)

##### display_library: sdl

指定bochs运行时使用的GUI。

事实上，不指定也是可以的，尤其是在搞不清楚用什么的情况下（比如CentOS）。

> The display library is the code that displays the Bochs VGA screen. Bochs has a selection of about 10 different display library implementations for different platforms. If you run configure with multiple `--with-*` options, the display_library option lets you choose which one you want to run with. If you do not use a display_library line, Bochs will choose a default for you.

###### 可用的GUI

| Option    | Description                                                  |
| --------- | ------------------------------------------------------------ |
| x         | use X windows interface, cross platform                      |
| win32     | use native win32 libraries                                   |
| carbon    | use Carbon library (for MacOS X)                             |
| macintosh | use MacOS pre-10                                             |
| amigaos   | use native AmigaOS libraries                                 |
| sdl       | use SDL 1.2.x library, cross platform                        |
| sdl2      | use SDL 2.x library, cross platform                          |
| svga      | use SVGALIB library for Linux, allows graphics without X windows |
| term      | text only, uses curses/ncurses library, cross platform       |
| rfb       | provides an interface to AT&T's VNC viewer, cross platform   |
| vncsrv    | use LibVNCServer for extended RFB(VNC) support               |
| wx        | use wxWidgets library, cross platform                        |
| nogui     | no display at all                                            |

##### floppya: 1_44=a.img, status=inserted

将引导扇区对应的软盘映像（a.img）放进第一个软驱里，这个软盘是1.44M的。

至于为什么是第一个软驱，因为第一个软驱一般是用来引导启动的。

> Floppya is the first drive, and floppyb is the second drive. If you're booting from a floppy, floppya should point to a bootable disk. To read from a disk image, write the name of the image file.

##### boot: floppy

指定引导方式，这里是通过软盘引导。

> This defines the boot sequence. You can specify up to 3 boot drives, which can be 'floppy', 'disk', 'cdrom' or 'network' (boot ROM). Legacy 'a' and 'c' are also supported.

##### 参考

- [The configuration file bochsrc](http://bochs.sourceforge.net/doc/docbook/user/bochsrc.html)