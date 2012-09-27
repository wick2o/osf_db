int
main(int argc, const char* argv[])
{
  /* Syscall 1 is exit on i386 but write on x86_64. */
  asm volatile("movl $1, %eax\n"
               "int $0x80\n");
  for (;;);
}

