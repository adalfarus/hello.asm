NASM=nasm
NASMFLAGS=-f win64
LINK=link
LINKFLAGS=/subsystem:console /entry:main /nodefaultlib /out:hello.exe
LINKLIBS=kernel32.lib
DEL=del

program=hello
obj-y=$(program).obj
all: $(program)
$(program): $(obj-y)

%: %.obj
	$(LINK) $^ $(LINKFLAGS) $(LINKLIBS)

%.obj: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	@$(DEL) $(program).exe $(obj-y) $(obj-y:.obj)

.SUFFIXES:
.PHONY: all clean
.PRECIOUS: $(obj-y)
