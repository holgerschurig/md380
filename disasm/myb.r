e cfg.fortunes = false
e asm.lines.ret = true

(func addr sz name,af $2 $0)

# Define a function, optionally analyze it recursively and seek to it
(f addr,af @ $0,s $0)
(fr addr,afr @ $0,s $0)
(fnr addr name,afr $1 @ $0,s $0) # dito, but with a name

# Define a data section and seek to it
(d4 addr size,Cd 4 $1 @ $0,s $0)

. cpu.r
. bootloader.r


.(fr 0x080019ec)
.(fr 0x08001a14)
.(fr 0x08001a2a)
.(fr 0x08001a4e)
.(fr 0x08001a72)
.(fr 0x08001aa0)
.(fr 0x08001af6)
.(fr 0x08001b18)
.(fr 0x08001b3c)
.(fr 0x08001b70)
.(fr 0x08001b82)
.(fr 0x08001b9c)
.(fr 0x08001c14)
.(fr 0x08001c26)
.(fr 0x08001c38)
.(fr 0x08001c52)
.(fr 0x08001c68)
.(fr 0x08001c8c)
.(fr 0x08001ce2)
.(f 0y08001cfc) # TODO using "afr" here trashes the data area @ 0x08001df0)
.(fr 0x08001d1e)
.(fr 0x08001d74)
.(fr 0x08001d8a)
.(fr 0x08001d8a)
.(fr 0x08001da0)
.(fr 0x08001da0)
.(fr 0x08001db6)
.(fr 0x08001db6)
.(fr 0x08001dce)
.(fr 0x08001dce)
.(fr 0x08001dde)
.(fr 0x08001dde)
.(d4 0x08001df0 26)
.(fr 0x08001e58)  # unsure
.(fr 0x08001e8a)
.(fr 0x08001f3a)
.(fr 0x08001f8c)
.(fr 0x08001fa2)
.(d4 0x8002038 10)

# Cd 4 30 0x08000000 # TODO, unsure about reset vectors


.(f 0x080001ce)
.(f 0x08000204)      # TODO .(fr) here trashes data area @ 0x08000dd4
.(f 0x080002c2)
.(fnr 0x080007f4 ret_false)
.(fr 0x080007f8)
.(fr 0x0800089a)
.(f 0x08000942)
.(d4 0x08000dd4 11)
.(f 0x08000e00)
.(d4 0x08000fe8 1)
.(fr 0x08001050)
.(d4 0x0800105c 7)
.(d4 0x080010dc 1)
.(fr 0x08001140)
.(fr 0x08001148)
.(d4 0x0800116c 15)
.(fr 0x080011a8)
.(fr 0x080011d2)
.(f 0x080011fc)
.(f 0x08001248)
.(f 0x08001298)
.(f 0x080012ce)
.(fr 0x0800132e)
.(fr 0x08001364)
.(d4 0x0800135c 2)
.(fr 0x08001364)
.(fr 0x080013bc)
.(fr 0x0800140c)
.(fr 0x08001574)
.(fr 0x0800169c)
.(fr 0x080016f4)
.(fr 0x080017ec)
.(fr 0x08001822)
.(d4 0x080018ac 5)
.(fr 0x080018c0)
# unknown 0x080018f4
.(fr 0x08001938)
.(fr 0x08001954)
.(fr 0x0800199a)
.(fr 0x080019ae)

Vp
#pd 600

