# Cifrado completo in-place usando TEA.
#
# Este archivo documenta la intencion de alto nivel del ASM/HEX de TEA.
# El cargador escribe la configuracion en data_mem usando direcciones byte:
#
#   data_mem[0] = base_address
#   data_mem[4] = block_count
#
# TEA opera sobre bloques de 64 bits: dos palabras consecutivas de data_mem.
# Como data_mem[...] indexa direcciones byte, offset + 4 es la siguiente palabra.
# La llave de 128 bits vive en vault[0..3].

int base_address;       # Direccion byte inicial donde se cargo el archivo.
int block_count;        # ceil(file_size / 8).
vault[4] key;           # key[0..3] desde la boveda segura.

@secure(0xA9C1F)
func void tea_encrypt_file(){
    int offset = base_address;

    for (int block = 0; block += 1; block < block_count) {
        int v0 = data_mem[offset + 0];
        int v1 = data_mem[offset + 4];
        int sum = 0;

        for (int round = 0; round += 1; round < 32) {
            sum += delta;
            v0 += ((v1 << 4) + key[0]) ^ (v1 + sum) ^ ((v1 >> 5) + key[1]);
            v1 += ((v0 << 4) + key[2]) ^ (v0 + sum) ^ ((v0 >> 5) + key[3]);
        }

        data_mem[offset + 0] = v0;
        data_mem[offset + 4] = v1;
        offset += 8;
    }
}

func void main(){
    tea_encrypt_file();
}
