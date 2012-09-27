NAME=zados
$(NAME).exe: $(NAME).obj
        Link   /SUBSYSTEM:WINDOWS /LIBPATH:c:\masm32\lib $(NAME).obj
$(NAME).obj: $(NAME).asm
        ml /c /coff /Cp  $(NAME).asm
